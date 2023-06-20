
# Deploying [slurm](https://slurm.schedmd.com/documentation.html)  on high performance computing (HPC) cluster with [ansible](https://www.ansible.com/) playbooks.

The playbooks are tested with following distributions:

- Rocky Linux 9
- Debian 12 (WIP)
- Arch Linux (why not)


These playbooks does not handle networking and firewall.

Network structure:

    Internet  ---  Login node ---  Control node/Compute nodes/Ansible controller/...

The login node has two interfaces (`enp1s0` and `enp7s0` in the examples).
`enp7s0` connected to internet and belongs to `external` zone.
`enp1s0` connect to all other slurm nodes with `trusted` zone.
Other slurm nodes has only one interface `enp1s0` in the `trusted` zone.
The login node is a gateway.
The internal nodes can only access internet through the login node, and are not accessible from outside.

There is only one slurm control node (no backup control nodes), and it is also act as a NFS server that share the `/home` directory over the internal network.

Users can only ssh into the login node.


This playbook does not set up MPI or environment mode.
User should install their own packages (like gcc, mpich, etc) with specified version through [conda](https://docs.conda.io/en/latest/) package manager.
This way user environment is separated from system environment, and system update or upgrade won't break their programs.
