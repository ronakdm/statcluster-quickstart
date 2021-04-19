#!/bin/bash
#SBATCH --job-name pi              # Set a name for your job. This is especially useful if you have multiple jobs queued.
#SBATCH --partition short          # Slurm partition to use
#SBATCH --ntasks 2                 # Number of tasks to run. By default, one CPU core will be allocated per task
#SBATCH --time 0-01:00             # Wall time limit in D-HH:MM
#SBATCH --mem-per-cpu=100          # Memory limit for each tasks (in MB)
#SBATCH -o pi_%j.out               # File to which STDOUT will be written
#SBATCH -e pi_%j.err               # File to which STDERR will be written
#SBATCH --mail-type=ALL            # Type of email notification- NONE,BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ronakdm@uw.edu # Email to which notifications will be sent
 
module load Python
source ./quickstart/bin/activate
python pi.py