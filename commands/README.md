# Read-only command files

These files group diagnostic commands used in, or adapted from, the lab. They are provided so a reader can understand the validation workflow; they are **not** installation or repair scripts. They may need minor adjustment for the OpenStack release and Linux distribution in a different lab.

All included shell files avoid hard-coded passwords and do not change service configuration. A few checks use `sudo`, which may prompt for the local account password.

| File | Run on | Purpose |
|---|---|---|
| [`01-controller-openstack-checks.sh`](01-controller-openstack-checks.sh) | Controller | OpenStack service, hypervisor, Neutron and VM state checks |
| [`02-compute-node-checks.sh`](02-compute-node-checks.sh) | Either compute node | Nova/libvirt state, NFS mount, instance list and exporter |
| [`03-storage-node-checks.sh`](03-storage-node-checks.sh) | Storage | LVM, TGT/iSCSI, NFS exports and exporter |
| [`04-monitoring-checks.sh`](04-monitoring-checks.sh) | Controller | Prometheus, Grafana, exporter endpoints and scrape target status |
| [`05-cinder-volume-checks.sh`](05-cinder-volume-checks.sh) | Controller (CLI) plus storage (LVM checks) | Cinder volume and backend validation |
| [`06-migration-validation.sh`](06-migration-validation.sh) | Controller | Read-only view of VM placement and migration history |

The local `~/admin-openrc` file is not included. Source your own OpenStack credentials in a private lab session before using OpenStack CLI commands.
