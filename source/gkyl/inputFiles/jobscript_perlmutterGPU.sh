#!/bin/bash -l

#.Declare a name for this job to be my_serial_job
#.it is recommended that this name be kept to 16 characters or less
#SBATCH -J gkyl

#.Request the queue (enter the possible names, if omitted, default is the default)
#.this job is going to use the default
#SBATCH -p regular

#.Number of nodes to request (Perlmutter has 64 cores and 4 GPUs per node)
#SBATCH -N 1

#.Specify GPU needs:
#SBATCH --constraint gpu
#SBATCH --gpus 4

#.Request wall time
#SBATCH -t 00:30:00

#SBATCH --account=m0000

#.Mail is sent to you when the job starts and when it terminates or aborts.
#SBATCH --mail-user=jdoe@fusion.pl
#SBATCH --mail-type=END,FAIL,REQUEUE

module load python/3.9-anaconda-2021.11
module load openmpi/5.0.0rc12
module load cudatoolkit/12.0
module load nccl/2.18.3-cu12
module unload darshan

# For some reason we need to specify the full path to gkyl command in jobscript.
export gComDir="$HOME/gkylsoft/gkyl/bin"

echo 'srun -n 4 --gpus 4 '$gComDir'/gkyl -g gk-sheath.lua'
srun -n 4 --gpus 4 $gComDir/gkyl -g gk-sheath.lua

exit 0
