# statcluster-quickstart

A quickstart guide to Python work on the University of Washington Statistics Department computing cluster. This is not meant to replace the extensive [documentation](https://howto.stat.washington.edu/howto/doku.php?id=clusters) that already exists, but to supplement it with a focus on introductory cluster computing and Python specifics.

## Background

A **computing cluster** is a set of computers that are connected in a way such that they can operate as a single system. Individual machines are called **nodes**, of which the Statistics cluster has 66. A **job** is a unit of computation (say running some number of computer programs) which is run on the computing cluster. A **scheduler** is a software that takes a job and distributes its computation across the cluster nodes to optimize speed. The **wall time** refers to the actual time elapsed when running a job, as opposed to CPU time, which would measure the number of clock cycles of a microprocessor (i.e. the time that the CPU is actively working as measured by an internal ticker). These nodes are partitioned into seven [groups](https://howto.stat.washington.edu/howto/doku.php?id=slurm) (called partitions) that are based on wall time of the jobs being run and user access limits. 

Users can communicate with the operating system of a "login" node using a `bash` shell. You can access this shell via Secure Shell Protocol (SSH) from your computer's terminal, after which you can run commands on the login node. The Slurm Workload Manager handles cluster management and job scheduling for the other nodes. To communicate with these nodes, we use the `sbatch` command (either within scripts or in the shell) to tell Slurm to perform operations. Files are stored in a Network File System (NFS), so they can be accessed from anywhere in the cluster. All files and directories specific to you will be stored in `/homes/<your-username>`. Read more [here](https://howto.stat.washington.edu/howto/doku.php?id=clusters)

## Accessing the Cluster

## Remote Development

## Environment Setup

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
This repo already contains the `quickstart` environment, which you can activate to run the examples. Make sure that you load the Python module before activating any virtual environments. Read more [here](https://howto.stat.washington.edu/howto/doku.php?id=virtualenv_and_pip).

## Examples

```
sbatch pi_single.sbatch
sbatch pi_multi.sbatch
sbatch --array=1-100 pi_array.sbatch
squeue -u <your_username>
```
