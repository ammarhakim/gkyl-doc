#!/bin/bash

#SBATCH -A pppl                          #.Allocaton.
#SBATCH -J em-lz8-1n                     #.Name of the job.
#SBATCH -t 12:00:00                      #.Wall clock time requested.
#SBATCH -N 4                             #.Number of nodes to request. (Eddy has 16 cores/node)
#SBATCH -n 64                            #.Number of total MPI tasks.
#SBATCH --mail-user=johndoes@gkeyll.pl   #.Email where to send notifications.
#SBATCH --mail-type=ALL                  #.Types of notifications desired.

#.Launch MPI code.
#.Note that aliases may not work in compute nodes. One must
#.provide the full path to the gkyl executable.

srun /home/tbernard/gkylsoft/gkyl/bin/gkyl nstix-em-lz8-1n.lua
