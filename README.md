# statcluster-quickstart
A quickstart guide to Python work on the University of Washington Statistics Department computing cluster. This is not meant to replace the extensive [documentation](https://howto.stat.washington.edu/howto/doku.php?id=clusters) that already exists, but to supplement it with a focus on introductory cluster computing and Python specifics.

## Background

A **computing cluster** is a set of computers that are connected in a way such that they can operate as a single system. Individual machines are called **nodes**, of which the Statistics cluster has 66. A **job** is a unit of computation (say running some number of computer programs) which is run on the computing cluster. A **scheduler** is a software that takes a job and distributions its computation across the cluster nodes to optimize speed. The **wall time** refers to the actual time elapsed when running a job, as opposed to CPU time, which would measure the number of clock cycles of a microprocessor (i.e. the time that the CPU is actively working as measured by an internal clock). These nodes are partitioned into seven [groups](https://howto.stat.washington.edu/howto/doku.php?id=slurm) (called partitions) that are based on wall time of the computing jobs being run and user access limits. 

Users can communicate with the operating system of a "login" node using a `bash` shell. You can access this shell via Secure Shell Protocol (SSH) from your computer's terminal, after which you can run commands on the login node. The Slurm Workload Manager handles cluster management and job scheduling for the other nodes. To communicate with these nodes, we use the `sbatch` command (either within scripts or in the shell) to tell Slurm to do stuff.

## Accessing the Cluster

## Remote Development

## Environment Setup

The recommended Python environment manager for the cluster is `virtualenv`. This is because `virtualenv` interacts with the built-in Python installation which is optimized for use on the cluster, whereas `conda`, for example, will use a standard Python installation. Note that the base Python environment on the cluster comes with many packages already available, and for some jobs it may be best to not load an environment at all. When doing so, however, it is important to install them on the `build` partition. The reason is that when a package is installed on the cluster, binaries are downloaded specifically for the hardware that the install command is run on. These files are then saved to the NFS, so that the user can access them anywhere. The `build` partition contains the oldest hardware in the cluster, and the downloaded binaries will be compatible with all of the other hardware in the cluster; this may not not be true for other partitions depending on the software.
```
srun --pty --time=30 --mem-per-cpu=100 --partition=build /bin/bash
```
