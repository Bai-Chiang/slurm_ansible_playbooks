#!/usr/bin/bash
#SBATCH --ntasks=4
#SBATCH --hint=nomultithread
#SBATCH --output=stdout

echo -e "\n\nsrun -n1 -l bash -c \"cat /etc/hostname\""
srun -n1 -l bash -c "cat /etc/hostname"

echo -e "\n\ncat /etc/hostname"
cat /etc/hostname

echo -e "\n\nsrun -l cat /etc/hostname"
srun -l cat /etc/hostname

sleep 1
echo -e "\n\n"'$CONDA_PREFIX/bin/mpiexec -n 4 $CONDA_PREFIX/bin/python test.py'
$CONDA_PREFIX/bin/mpiexec -n 4 $CONDA_PREFIX/bin/python test.py 
