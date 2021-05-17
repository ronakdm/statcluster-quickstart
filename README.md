# statcluster-quickstart

A quickstart guide to Python work on the University of Washington Statistics Department computing cluster. This is not meant to replace the extensive [documentation](https://howto.stat.washington.edu/howto/doku.php?id=clusters) that already exists, but instead to provide

- background information for beginners,
- Python-related specifics, and
- a sequential path to go through the documentation.

Feedback is appreciated!

## Background

A **computing cluster** is a set of computers that are connected in a way such that they can operate as a single system. Individual machines are called **nodes**, of which the Statistics cluster has 66. A **job** is a unit of computation (say running some number of computer programs) which is run on the computing cluster. A **scheduler** is a software that takes a job and distributes its computation across the cluster nodes to optimize speed. The **wall time** refers to the actual time elapsed when running a job, as opposed to CPU time, which would measure the number of clock cycles of a microprocessor (i.e. the time that the CPU is actively working as measured by an internal ticker). These nodes are partitioned into seven [groups](https://howto.stat.washington.edu/howto/doku.php?id=slurm) (called partitions) that are based on wall time of the jobs being run and user access limits. 

Users can communicate with the operating system of a "login" node using a `bash` shell. You can access this shell via Secure Shell Protocol (SSH) from your computer's terminal, after which you can run commands on the login node. We refer to the **local** machine as the starting point, whereas the **remote** machine is the destination we want to connect to. The Slurm Workload Manager handles job scheduling for the actual cluster nodes. To communicate with these nodes, we use the `sbatch` command (either within scripts or in the shell) to tell Slurm to perform operations. Files are stored in a Network File System (NFS), so they can be accessed from anywhere in the cluster. All files and directories specific to you will be stored in `/homes/<your-username>`. Read more [here](https://howto.stat.washington.edu/howto/doku.php?id=clusters)

## Setup

### Easy Access

To make iteration and experimentation easier, it is convenient to be able to access the cluster as quickly as possible. The first step is to make and account and get faculty sponsorship by following these [instructions](https://howto.stat.washington.edu/howto/doku.php?id=accessing_the_clusters). After this step, there are three ways to login to the cluster.

#### Method 1

Connect to the UW **virtual private network** (VPN), which is a software that allows you to access a private computing network via the Internet. This would involve downloading a VPN client and logging in using your UW credentials (see [this page](https://www.lib.washington.edu/help/connect/husky-onnet)). Then, to access a remote machine using SSH, you would run the following.
```
ssh <your_username>@<host>
```
A **host** is a string containing either a domain name or an IP address that identifies the computer you wish to access. To connect to the Stat cluster, the host is `cluster.stat.washington.edu`. The username is specifed by the account you created earlier. If you are not connected to the VPN, then this host will not be recognized.  

#### Method 2

First, SSH into another Stat Department machine called the "SSH" machine, identified by host `ssh.stat.washington.edu`, by running the following command. You will be prompted for your UW credentials.
```
ssh <your_netid>@ssh.stat.washington.edu
```
This machine can be accessed without using the VPN, and is already connected to the UW private network. From this machine, you can SSH directly to the cluster. You will also have to log in using your UW credentials in this step.
```
ssh <your_username>@ssh.stat.washington.edu
```
There is a way to avoid these logins. In **key pair authentication**, we create two keys (files), a **private key** and **public key** on the remote machine. The public key is a file that contains an identifiers for the private key. The private key is then copied over to the local machine. When the local connects to the remote via SSH, the remote will recognize the private key saved on the local machine, and let it connect without logging in. To avoid all logins for this method, you must go through the process *twice* - once to authenticate the connection between `ssh.stat.washington.edu` and `cluster.stat.washington.edu`, and another time to authenticate the connection between your local machine and `ssh.stat.washington.edu`. Follow the instructions in the "Connecting From Off Campus" section of this [page](https://howto.stat.washington.edu/howto/doku.php?id=ssh_guide) in order to do this. Now you should be able to run the two commands above without having to log in either time.

#### Method 3

This is most likely the most convenient way, and requires that you already completed the key pair authentication steps in the previous bullet. Here, we basically create a **shell** command (i.e. the language that one uses to communicate a computer's operating system) that SSH's us to `ssh` and `cluster`. For most UNIX systems, `bash` is the shell language. This means that there will be a `.bashrc` file in the home directory that will be executed on startup of the terminal. you can put custom commands and other personalized configurations in this file. MacOS recently switched to the `zsh` (pronounced "zeesh") shell language, which corresponds to the `.zshrc` file for such commands. List the home directory by running the following.
```
cd ~
ls -a
```
You should see your `.bashrc` or `.zshrc` file. Open it, and add the following line.
```
alias statcluster='ssh -J <your_user_name>@ssh.stat.washington.edu <your_user_name>@cluster.stat.washington.edu'
```
We specified a shell **alias** called `statcluster` which is similar to a variable name that stores a command. The `-J` flag on the `ssh` command stands for "jump", in the sense that we are jumping through `ssh.stat.washington.edu` to get to `cluster.stat.washington.edu`. After restaring your terminal, you should be able to access the cluster by simply running the command below.
```
statcluster
```

### Remote Development

**Integrated development environments** (IDEs) are text editors with special features for code such as color coding, linting (checking for correctness and style without execution), autocomplete, and most importantly, debugging. Examples include Visual Studio Code (my favorite), PyCharm, and RStudio. My IDEs offer **remote development**, in which you use an IDE installed on your machine to edit code on a remote machine. This can be a near essential capability, because it allows you to use the IDE's debugger on code as it runs directly on the cluster (and any other machines you may work on). Take a look at your IDE's remote development and debugger instructions to add this to your workflow.

### Environment Setup

The recommended Python environment manager for the cluster is `virtualenv`. This is because `virtualenv` interacts with the built-in Python installation which is optimized for use on the cluster, whereas `conda`, for example, will use a standard Python installation. When creating a virtual environment, it is important to install packages on the `build` partition. The reason is that when a package is installed on the cluster, binaries are downloaded specifically for the hardware on which the install command is run. These files are then saved to the NFS, so that the user can access them anywhere. The `build` partition contains the oldest hardware in the cluster, and the downloaded binaries will be compatible with all of the other hardware in the cluster; this may not not be true for other partitions depending on the software. To move from a login node to a node in the `build` partition, you have to start a Slurm interactive session, which essentially allows you to run `bash` commands directly on a partition node.
```
# 30 minute time limit and 100MB of memory allocated.
srun --pty --time=30 --mem-per-cpu=100 --partition=build /bin/bash
```
After this, run the following to load the built-in Python module and create your environment. Make sure you are in the directory that you want the encvironment files to be saved in (as opposed to a `git` repo for your project, for example).
```
module load Python
virtualenv <your_env_name>
source ./<your_env_name>/bin/activate
pip install --upgrade pip
pip install <first_package> <second_package>
deactivate
```
This repo already contains the `quickstart` environment, which you can activate to run the examples. Make sure that you load the Python module before activating any virtual environments. Read more about `pip` and `virtualenv` [here](https://howto.stat.washington.edu/howto/doku.php?id=virtualenv_and_pip). Read more about environment and modules [here](https://howto.stat.washington.edu/howto/doku.php?id=modules).

## Development

There are two components to a Python job: a `.py` file that executes the desired computation, and a `.sbatch` file which is a Slurm that tells Slurm how to schedule this computation on the cluster. The Slurm script is essentially a `bash` script with some additional syntax, and the Python file will be run within this script. See the the [documentation](https://howto.stat.washington.edu/howto/doku.php?id=slurm_examples) for examples of Slurm scripts (with their corresponding R files). These scripts will typically look like the following.
```
#!/bin/bash
#SBATCH --flag-to-specify-some-parameter value-of-parameter # Repeat this for all parameters.

module load Python
source <path_to_my_virtual_environment>/bin/activate
python <my_script>.py
```
After creating both of these files, just run the Slurm script directly on the remote machine using:
```
sbatch <my_script>.sbatch
```
Some of these parameters are subtle and essential for distributing computation correctly (see Types of Jobs below). Others are self-explanatory, and can be understood by the comments in the documentation.

### Interactive Development

Typically, one might want to test their `.py` file for correctness before running it in a Slurm job. The cluster is optimized to run many jobs in parallel, and it turns out that running code in any one Python environment in the cluster is quite slow. It is difficult to quickly iterate on the cluster itself. Nonetheless, after working out all of the bugs in your code on your local machine, one may still want to try the script on a cluster node to ensure that it runs in that environment. Do not do this on your login node (i.e. SSH-ing into the cluster and just running the file). Instead, move to a node in the `short` partition by starting an interactive session. We did this before on the `build` partition, which is only meant for installing packages and not for running code. You might have to adjust the time and memory limits.
```
# 90 minute time limit and 100MB of memory allocated.
srun --pty --time=90 --mem-per-cpu=100 --partition=short /bin/bash
```
After that, if the script is quick, then you can run the following.
```
module load Python
source ./<your_env_name>/bin/activate # If you are using a virtual environment.
python <your_script.py>
```
If the script is not quick, then this will not be feasible and you will have to submit a job to Slurm regardless.

### Types of Jobs:

There are three formats for distributing computation across the cluster. They depend on the number of **threads** in your program, that is the sequences of actions that can be independently handled by the scheduler. A **single-thread program** cannot distribute any of its computation across multiple machines, whereas a **multi-threaded program** can, as there are independent computations occuring in the program. The examples below can all be found in the `examples` directory.

#### Example 1: Single Job with Single-Threaded Program 

This format should never be used, as it will run faster on a laptop. This is only for illustrative purposes. The pair of `pi_single.py` and `pi_single.sbatch` runs a single job that executes a single-threaded program to estimate $pi$, and dumps the result into the `out` directory. Note that the `--ntasks` (specifying the number of threads) parameter is set to `1`. Run this example on the cluster with:
```
sbatch examples/pi_single.sbatch
```

#### Example 2: Array Job with Single-Threaded Program 

This format uses a single-threaded program, but runs the program multiple times in on various nodes using an **array job**. Here, the scheduling is handled by Slurm. The pair `pi_array.py` and `pi_array.sbatch` accomplishes this. There are a few things to notice here.
- In the Slurm script, the `--ntasks` parameter is still set to `1`, as this is a single-threaded program. 
- We added the additional Slurm parameter `--array=1-20` indicating that this is an array job that will be run 20 times.
- The variable `$SLURM_ARRAY_TASK_ID` is passed as an argument to the program, which will allow the Python file to know the index of the job being run. 
- In Python `sys.argv` returns a list of strings containing the program name and additional arguments. Thus, we can get the job ID using `job_id = int(sys.argv[1])`. This is useful, for example, when the index corresponds to a hyperparameter setting.

Run this example on the cluster with:
```
sbatch examples/pi_array.sbatch
``` 

#### Example 3: Single Job with Multi-Threaded Program 

Finally, one may want to use a different scheduling software, such as `joblib` to handle the parallelization. This might be useful for easily using the same code on different distributed environments without additional work (say, an AWS or Azure instance). There is actually a more subtle advantage; because the cluster software is optimize to handle a few large files per node, operations involving many small files (e.g. loading up a virtual environment) are quite slow. An array job, because it runs the Slurm script many times, will end up loading the virtual enviroment for every iterate of the program. On the other hand, which using a scheduler within Python, one can load the virtual environment only once, and let `joblib` handle distribution within the program. The downside is that these types of software might need to allocate all the nodes for the multi-threaded computation before actually executing it, whereas an array job can run a single job whenever a node becomes available. This is an interesting tradeoff that exists for Python programs, but does not really exist for R. In the case of R, an array job is really the best way to do things. 

The pair `pi_multi.py` and `pi_multi.sbatch` execute this. The multi-thread program is generated using `joblib`. The main thing to note is that we set the `--ntask` parameter to `100`, because this is a program with 100 threads. Run this example on the cluster with:
```
sbatch examples/pi_multi.sbatch
```



