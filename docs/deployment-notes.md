# Deployment notes

These notes summarize the design decisions supported by my command captures. They are not a substitute for full, version-specific service configuration files, which were not preserved in a publishable form.

## Lab environment

- Four Ubuntu-based lab nodes were used: controller, Compute1, Compute2 and storage.
- The node addresses belonged to the private `172.18.84.0/24` lab network.
- The wider lab was hosted in VMware ESXi; the OpenStack compute nodes used libvirt and QEMU/KVM for VM instances.
- A private provider network was used for the test instance. A CirrOS image and a small `m1.nano` flavor were used for the migration test.

## Storage decisions

### Cinder block storage

- Storage node: `storage` (`172.18.84.33`).
- Dedicated virtual disk used for Cinder: `/dev/sdb`, 80 GB.
- LVM volume group: `cinder-volumes`.
- LVM thin pool seen in the captured `lvs` output: `cinder-volumes-pool`.
- Cinder LVM driver was configured, with iSCSI/TGT used to present volumes to compute hosts.
- A 5-unit (as displayed by the OpenStack CLI; nominally 5 GiB) test volume called `test-volume` was reported as `in-use` on a VM hosted by Compute2.

Do not recreate the LVM layout on a production disk by copying these names blindly. LVM commands can modify storage; confirm disk identity and take backups before any implementation.

### NFS shared instance directory

- Export path: `/srv/nova-shared/instances` on the storage node.
- Compute1 and Compute2 mounted `172.18.84.33:/srv/nova-shared/instances` at the same local path.
- Captured `df -h` output showed a 47 GB filesystem, approximately 8.6 GB used and 36 GB available at that time.
- A test file was created and verified through the mount from the other compute node.

NFS shared instance storage was part of the migration experiment, not a guarantee of support for every live-migration configuration.

## Networking and names

The captured node mappings were:

```text
172.18.84.22 controller
172.18.84.23 compute1
172.18.84.32 compute2
172.18.84.33 storage
```

The controller's management interface was shown as `172.18.84.22/24`, with a default route via `172.18.84.1`. Compute1, Compute2 and storage used the same subnet. These addresses are private lab values; replace them before applying examples to another environment.

## Configuration safety

The original configuration files contained credentials, so complete `cinder.conf`, `nova.conf`, `admin-openrc`, key material and raw terminal dumps are intentionally not included here. The `examples/prometheus.yml` file is a sanitized monitoring example only.
