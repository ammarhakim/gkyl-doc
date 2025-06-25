#!/bin/bash

#.Submit a job in NERSC's Cori.

#SBATCH -J em-lz8-1n                   #.Name of the job.

#SBATCH --qos=regular                  #.Which queue to run on.
#SBATCH --time=24:0:0                  #.Wall clock time requested.
#SBATCH --nodes=8                      #.Number of nodes to request.
#SBATCH --tasks-per-node=32            #.Number of MPI tasks per node (Cori has 32 cores/node).
#SBATCH --constraint=haswell           #.Type of node to use.

#SBATCH --mail-user=johndoe@gkeyll.pl  #.Email where to send notifications.
#SBATCH --mail-type=ALL                #.Types of notifications desired.

#.Launch MPI code.
#.Note that aliases may not work in compute nodes. One must
#.provide the full path to the gkyl executable.

srun -n 256 ~/codes/gkylsoft/gkyl/bin/gkyl nstx-em-lz8-1n.lua
