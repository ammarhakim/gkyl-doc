#!/bin/bash

#.Submit a GPU job to PPPL's Portal cluster.

#SBATCH --gres=gpu:V100:1     #.Number of V100 GPUs requested (max: 2).
#SBATCH -t 48:00:00           #.Time of simulation (max 48 hours).
#SBATCH -n 1                  #.Number of nodes (only 1 GPU node, so should be 1).
#SBATCH -J job-name           #.Job name.
#SBATCH -o job-name-%j.out    #.Name of stdout output file.
#SBATCH -e job-name-%j.err    #.Name of stderr error file.
#SBATCH -p centos7            #.Operating system (MUST BE centos7).
#SBATCH --mem-per-cpu=16000   #.Memory per core (Portal V100 GPU has max 16 GBs).

#.Launch MPI code.
#.Note that aliases may not work in compute nodes. One must
#.provide the full path to the gkyl executable.

/location/of/gkyl/executable/gkyl name-of-input-file.lua
