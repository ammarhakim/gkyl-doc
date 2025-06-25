#!/bin/bash

#.Submit a job in TACC's Stampede2.

#SBATCH -J job-name                    #.Job name.
#SBATCH -o job-name.o%j                #.Name of stdout output file.
#SBATCH -e job-name.e%j                #.Name of stderr error file.

#SBATCH -p skx-normal                  #.Queue (partition) name.
                                       #.Possible queues: skx-dev, skx-normal, skx-large.
                                       #.Max # of nodes: 4, 128, 868.

#SBATCH -t 48:00:00                    #.Run time (hh:mm:ss).
                                       #.Max time in each queue: 2 hours, 48 hours, 48 hours.

#SBATCH -N 64                          #.Total # of nodes.
#SBATCH -n 3072                        #.Total # of mpi tasks (Stampede2 has 48 cores/node).

#SBATCH --mail-user=janedoe@gkeyll.pl
#SBATCH --mail-type=all                #.Send email at begin and end of job.
#SBATCH -A GKYL007                     #.Allocation name (required if you have more than 1).

#.Other commands must follow all #SBATCH directives.
pwd
date

#.Launch MPI code.
#.Note that aliases may not work in compute nodes. One must
#.provide the full path to the gkyl executable.

ibrun /location/of/gkyl/executable/gkyl name-of-input-file.lua
