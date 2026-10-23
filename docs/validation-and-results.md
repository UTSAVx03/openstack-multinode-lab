# Validation and results

This page separates what the captures prove from what remains unfinished. The command files under [`commands/`](../commands/README.md) contain read-only checks that can be adapted in a similar lab.

## 1. Compute and OpenStack services

Commands used during validation included:

```bash
source ~/admin-openrc
openstack compute service list
openstack hypervisor list
openstack network agent list
openstack volume service list
```

The service state changed during troubleshooting and restart cycles. Some saved snapshots show compute services down, while later snapshots show them up. Treat these as point-in-time results, not a claim that every service was continuously healthy.

## 2. Shared NFS

The compute-node checks used commands such as:

```bash
findmnt /srv/nova-shared/instances
df -h /srv/nova-shared/instances
ls -l /srv/nova-shared/instances/migration-test
```

The saved results show the NFS mount sourced from `172.18.84.33:/srv/nova-shared/instances` on both Compute1 and Compute2. The small `migration-test` file was visible through the other node's mount, confirming that the shared path worked at that point in time.

## 3. Cinder and iSCSI

The storage checks included:

```bash
sudo pvs
sudo vgs
sudo lvs -a
sudo systemctl is-active tgt
sudo tgtadm --mode target --op show
```

The `cinder-volumes` volume group and thin pool were present. Compute2 showed an iSCSI session to `172.18.84.33:3260`; the OpenStack volume view listed `test-volume` as `in-use` and attached to a VM on Compute2.

A device name may differ depending on the layer: the OpenStack attachment record listed the requested attachment path as `/dev/vdb`, while host-level iSCSI enumeration showed the disk as `/dev/sdb` in a separate command context. Always check the guest, compute host and API view separately.

## 4. Cold migration

The successful command pattern in the captures was:

```bash
openstack --os-compute-api-version 2.56 server migrate \
  --host compute2 --wait migration-test-vm
```

The command completed and the instance briefly reached `VERIFY_RESIZE`. The resize/migration was then confirmed:

```bash
openstack server migration confirm migration-test-vm
openstack server show migration-test-vm \
  -c name -c status \
  -c OS-EXT-SRV-ATTR:host \
  -c OS-EXT-SRV-ATTR:hypervisor_hostname
```

The resulting captured state showed the VM `ACTIVE` on `compute2` and a confirmed migration history record from `compute1` to `compute2`.

This was a **cold migration**, not live migration. Use the migration notes in [Troubleshooting](troubleshooting.md) for the distinction.

## 5. Monitoring

The monitoring validation checked:

```bash
systemctl is-active prometheus grafana-server prometheus-node-exporter
curl -fsS http://127.0.0.1:9090/-/ready
curl -fsS http://127.0.0.1:3000/api/health
curl -fsS http://127.0.0.1:9100/metrics >/dev/null
```

The saved result reported Prometheus ready, Grafana active/healthy, and successful Node Exporter endpoint checks for controller, Compute1, Compute2 and storage. Grafana's Prometheus data source displayed “Successfully queried the Prometheus API,” and the dashboard rendered the expected panels.

## Summary

- **Verified:** shared NFS mount across both compute nodes.
- **Verified:** Cinder test volume attached to a Compute2 instance.
- **Verified:** cold migration and confirmation from Compute1 to Compute2.
- **Verified:** Prometheus readiness, four Node Exporter endpoints and Grafana visualization.
- **Not verified as complete:** live migration; repeated attempts returned a Nova HTTP 500 migration error.
- **Not fully resolved:** intermittent blank Grafana page in Chrome; the cause was not conclusively determined.
