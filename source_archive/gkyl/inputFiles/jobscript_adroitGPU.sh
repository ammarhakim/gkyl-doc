#!/bin/bash -l

#.Submit a GPU node in Princeton's Adroit cluster.

#SBATCH -J gkyl                    #.Job name (recommended 16 characters or less).

#SBATCH -p all                     #.Specify which queue to run on.
#SBATCH -N 1                       #.Number of nodes to request (CPU nodes have 32 cores/node).
#SBATCH -n 32                      #.Total number of cores (32 per node).
#SBATCH --gres=gpu:tesla_v100:1    #.Use this to request a Tesla V100 GPU node.
#SBATCH -t 01:00:00                #.Request wall time.

#SBATCH --mail-user=janedoe@gkeyll.pl    #.Mail where to send notifications.
#SBATCH --mail-type=END,FAIL,REQUEUE     #.Types of notifications to send by email.

#SBATCH -o slurm-%j.out                  #.Specify name format of output file.

#.Load modules needed by the program.
module load intel
module load intel-mpi
module load cudatoolkit/10.1

export gComDir="$HOME/gkylsoft/gkyl/bin/"    #.Full path to the gkyl executable.

#.Launch the CUDA job (and print it to screen too).
echo $gComDir'/gkyl cudaInputFile.lua'
$gComDir/gkyl cudaInputFile.lua

exit 0
