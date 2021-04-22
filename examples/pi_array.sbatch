#!/bin/bash
#SBATCH --job-name pi_array        # Set a name for your job. This is especially useful if you have multiple jobs queued.
#SBATCH --partition short          # Slurm partition to use
#SBATCH --array=1-20               # How many tasks in the array
#SBATCH --time 0-00:10             # Wall time limit in D-HH:MM
#SBATCH --mem-per-cpu=1            # Memory limit for each tasks (in MB)
#SBATCH -o out/pi_array.out        # File to which STDOUT will be written
#SBATCH -e out/pi_array.err        # File to which STDERR will be written
#SBATCH --mail-type=ALL            # Type of email notification- NONE,BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ronakdm@uw.edu # Email to which notifications will be sent
 
module load Python
source ./quickstart/bin/activate
python examples/pi_array.py $SLURM_ARRAY_TASK_ID
