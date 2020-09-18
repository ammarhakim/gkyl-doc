#!/bin/bash -l

#.Submit a job in MIT's Engaging cluster.

#SBATCH -J gkyl-bot               #.Name of the job (recommended 16 characters or less).

#SBATCH -p sched_mit_psfc         #.Request the PSFC queue.
#SBATCH --qos psfc_24h            #.Use this for >12h runs (PSFC queue). Remove for <12h runs.
#SBATCH -N 2                      #.Number of nodes to request.
#SBATCH -n 64                     #.Total number of cores (32 per node).
#SBATCH -t 06:00:00               #.Request wall time.

#SBATCH -o slurm-%j.out           #.Specify name format of output file.

#.Load modules (may not be needed).
module use /home/software/psfc/modulefiles
module add psfc/config
module load intel/2017-01
module load impi/2017-01
module load psfc/adios/1.13.1

export gComDir="$HOME/gkylsoft/gkyl/bin"      #.Full path to the gkyl executable.
export mpiComDir="$I_MPI_ROOT/intel64/bin"    #.Specify location of mpirun.

#.Cori printed workings about DVS strip width being 32.
#.Set it to 28 for now but some testing is needed (this may not be needed).
export MPICH_MPIIO_DVS_MAXNODES=28

#.Launch the MPI job (and print it to screen too).
echo $mpiComDir'/mpirun -n 64 '$gComDir'/gkyl input_file.lua'
$mpiComDir/mpirun -n 64 $gComDir/gkyl input_file.lua

exit 0
