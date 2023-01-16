#!/usr/bin/bash
#SBATCH --ntasks=4
#SBATCH --output=stdout

#srun -n1 -l bash -c "cat /etc/hostname"

cat /etc/hostname

srun -l cat /etc/hostname

sleep 1

$HOME/miniforge3/bin/mpiexec -n 4 $HOME/miniforge3/bin/python test.py 
