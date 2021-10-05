#!/bin/bash

#.Declare a name for this job to be my_serial_job
#.it is recommended that this name be kept to 16 characters or less
#SBATCH -J gkyl

#.Select the appropriate queue.
#SBATCH -p general

#.Number of MPI tasks.
#SBATCH -n 64

#.Request wall time.
#SBATCH -t 04:00:00

#.Specify how much memory is needed.
#SBATCH --mem 16G

#.Mail is sent to you when the job starts and when it terminates or aborts.
#SBATCH --mail-user=juliana@gkeyll.pl
#SBATCH --mail-type=END,FAIL,REQUEUE

#.Specify name format of output file.
#SBATCH -o slurm-%j.out

module load gcc
module load openmpi

echo $SLURM_NODELIST
echo $SLURM_NTASKS
echo "Gkeyll simulation of ..."
echo $SLURM_JOBID
echo $SLURM_SUBMIT_DIR

time mpirun -np $SLURM_NTASKS $HOME/gkylsoft/gkyl/bin/gkyl gkylInputFile.lua

exit 0
