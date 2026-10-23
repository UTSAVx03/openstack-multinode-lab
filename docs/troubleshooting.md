# Troubleshooting notes and lessons learned

This page records what went wrong as well as what worked. A useful lab report should keep successful outcomes separate from unfinished investigations.

## Live migration returned a Nova HTTP 500

### Symptom

Repeated commands using `--live-migration` and `--shared-migration` returned a remote Nova `MigrationError_Remote` HTTP 500. The instance could move into `ERROR` until its state was reset, and migration history recorded failed attempts.

### What I checked

- OpenStack compute-service and hypervisor state.
- Neutron agent state.
- `nova-compute` and `libvirtd` service status.
- Shared instance-storage mount on both compute nodes.
- SSH access between compute nodes for libvirt operations.
- Nova migration history and VM placement.

### What did work

The standard migration workflow, using Compute API microversion 2.56 without the live-migration flag, completed from Compute1 to Compute2. After confirming the operation, `migration-test-vm` was `ACTIVE` on `compute2` and the migration record was `confirmed`.

### Current conclusion

- **Cold migration: succeeded.**
- **Live migration: not completed.**

I did not conclusively isolate the live-migration root cause. Likely areas to investigate in a future session are the exact Nova version/microversion behavior, shared-storage mode, libvirt/QEMU compatibility, migration URI/transport configuration, SSH identity and permissions, firewall/routing, and the source/destination `nova-compute` and libvirt logs for the same request ID. These are diagnostic avenues, not confirmed causes.

## Compute services showed `down` in some snapshots

During repeated troubleshooting and service restarts, captures showed `nova-compute` or hypervisor state as `down` at certain points. Later captures showed compute services `up`. That is why this repository labels service state as time-specific and does not claim continuous availability. A real investigation should correlate timestamps and check both the service manager and OpenStack service heartbeat.

Useful read-only checks:

```bash
openstack compute service list
openstack hypervisor list
sudo systemctl is-active nova-compute
sudo systemctl is-active libvirtd
sudo journalctl -u nova-compute --since "15 minutes ago" --no-pager
sudo journalctl -u libvirtd --since "15 minutes ago" --no-pager
```

## Prometheus could reach only the controller at first

The first check showed `connection refused` on remote TCP port `9100`. The issue was that Node Exporter was not listening on the other nodes yet. I installed/enabled the package on Compute1, Compute2 and storage, then re-tested each endpoint. The later validation capture shows all four exporter checks as OK.

Useful checks:

```bash
systemctl is-active prometheus-node-exporter
ss -lntp | grep ':9100'
curl -fsS http://127.0.0.1:9100/metrics >/dev/null
```

From the controller, test each remote node with its own address:

```bash
curl -fsS http://172.18.84.23:9100/metrics >/dev/null && echo "compute1 OK"
curl -fsS http://172.18.84.32:9100/metrics >/dev/null && echo "compute2 OK"
curl -fsS http://172.18.84.33:9100/metrics >/dev/null && echo "storage OK"
```

## Grafana repository DNS and plugin discovery

The controller could use configured Ubuntu package repositories but initially could not resolve `apt.grafana.com` directly. Later, Grafana was installed and its HTTP health endpoint responded, and Prometheus was added as a data source successfully. This was a DNS/repository-access issue at install time; it was not evidence of a Prometheus scraping problem.

Never hardcode proxy credentials into repository files. If using a proxy, keep it in local host configuration outside this public repository.

## Grafana occasionally showed a blank page

The dashboard was visible and populated at other times, but Chrome also showed a blank page after it had been open for a while. The precise cause was not established. The dashboard time range and refresh interval were reduced, and the saved dashboard screenshot confirms one successful render. A future investigation should separately inspect browser console errors, `/api/health`, and Grafana service logs at the time of failure instead of resetting the dashboard or reinstalling services blindly.

## What I learned

1. Check the exact failing layer before changing configuration.
2. Correlate service state, API output and logs using timestamps/request IDs.
3. Shared storage helps with some migration modes but does not guarantee live migration.
4. `ACTIVE` after a confirmed cold migration is evidence of cold migration, not live migration.
5. Save sanitized commands and screenshots as you work; they are invaluable when server access is later unavailable.
