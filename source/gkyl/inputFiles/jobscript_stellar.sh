#!/bin/bash -l

#.Declare a name for this job to be my_serial_job
#.it is recommended that this name be kept to 16 characters or less
#SBATCH -J gkyl

#.Select the appropriate queue. See Stellar docs.
#SBATCH --qos pppl-short

#.Number of nodes to request (Stellar has 96 cores per node).
#SBATCH -N 3

#.Total number of cores (96 per node).
#SBATCH --tasks-per-node=96

#.Request wall time.
#SBATCH -t 04:00:00

#.Mail is sent to you when the job starts and when it terminates or aborts.
#SBATCH --mail-user=jorge@gkeyll.pl
#SBATCH --mail-type=END,FAIL,REQUEUE

#.Specify name format of output file.
#SBATCH -o slurm-%j.out

module load intel/2021.1.2
module load openmpi/intel-2021.1/4.1.0

#.For some reason we need to specify the full path to gkyl command in jobscript.
export gComDir="$HOME/gkylsoft/gkyl/bin"

mpirun -n 288 $gComDir/gkyl inputFile.lua


exit 0
