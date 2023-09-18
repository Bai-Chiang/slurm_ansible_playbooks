#!/usr/bin/bash
#SBATCH --ntasks=4
#SBATCH --hint=nomultithread
#SBATCH --output=stdout

#srun -n1 -l bash -c "cat /etc/hostname"

cat /etc/hostname

srun -l cat /etc/hostname

sleep 1

$CONDA_PREFIX/bin/mpiexec -n 4 $CONDA_PREFIX/bin/python test.py 
