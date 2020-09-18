#!/bin/bash -l

#.Submit a CPU node in Princeton's Adroit cluster.

#SBATCH -J gkyl                    #.Job name (recommended 16 characters or less).

#SBATCH -p all                     #.Specify which queue to run on.
#SBATCH -N 1                       #.Number of nodes to request (CPU nodes have 32 cores/node).
#SBATCH -n 32                      #.Total number of cores (32 per node).
#SBATCH -t 01:00:00                #.Request wall time.

#SBATCH --mail-user=janedoe@gkeyll.pl    #.Mail where to send notifications.
#SBATCH --mail-type=END,FAIL,REQUEUE     #.Types of notifications to send by email.

#SBATCH -o slurm-%j.out                  #.Specify name format of output file.

#.Load modules needed by the program.
module load intel
module load intel-mpi

export gComDir="$HOME/gkylsoft/gkyl/bin/"    #.Full path to the gkyl executable.
export mpiComDir="$I_MPI_ROOT/bin64/"        #.Specify location of mpirun.

#.Launch the MPI job (and print it to screen too).
echo $mpiComDir'/mpirun -n 32 '$gComDir'/gkyl rt-weibel-2x2v-p2.lua'
$mpiComDir/mpirun -n 32 $gComDir/gkyl rt-weibel-2x2v-p2.lua

exit 0
