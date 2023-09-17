from mpi4py import MPI
import numpy as np
import subprocess

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

sendbuf = np.zeros(100, dtype='i') + rank
recvbuf = None
if rank == 0:
    recvbuf = np.empty([size, 100], dtype='i')
comm.Gather(sendbuf, recvbuf, root=0)
if rank == 0:
    for i in range(size):
        assert np.allclose(recvbuf[i,:], i)

HOSTNAME = subprocess.check_output("echo $HOSTNAME", shell=True, text=True)
hostname = subprocess.check_output("cat /etc/hostname", shell=True, text=True)
print('rank={:d}\n\t$HOSTNAME={}\t/etc/hostname {}'.format(rank, HOSTNAME, hostname))
