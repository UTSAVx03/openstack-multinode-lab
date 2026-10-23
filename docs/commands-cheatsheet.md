# Command cheat sheet

These commands are references from the lab. Prefer read-only checks first and confirm the host before running any command. See the grouped scripts in [`commands/`](../commands/README.md).

## OpenStack control plane (run on controller after loading local credentials)

```bash
source ~/admin-openrc
openstack service list
openstack compute service list
openstack hypervisor list
openstack resource provider list
openstack network agent list
openstack volume service list
```

## VM and migration

```bash
openstack server list
openstack server show migration-test-vm
openstack server migration list --server migration-test-vm
```

The successful migration record showed source Compute1, destination Compute2 and status `confirmed`. Do not replay migration or state-reset commands blindly on another environment.

## Network

```bash
ip -br addr
ip route
openstack network list
openstack subnet list
openstack port list
openstack network agent list
```

## Cinder / LVM / iSCSI

```bash
openstack volume list
openstack volume show test-volume
sudo pvs
sudo vgs
sudo lvs -a
sudo iscsiadm -m session
sudo tgtadm --mode target --op show
```

## Shared NFS

```bash
findmnt /srv/nova-shared/instances
df -h /srv/nova-shared/instances
ls -l /srv/nova-shared/instances
```

## Prometheus / Grafana / Node Exporter

```bash
systemctl is-active prometheus
test -r /etc/prometheus/prometheus.yml && promtool check config /etc/prometheus/prometheus.yml
curl -fsS http://127.0.0.1:9090/-/ready
curl -fsS http://127.0.0.1:3000/api/health
curl -fsS http://127.0.0.1:9100/metrics >/dev/null
curl -s http://127.0.0.1:9090/api/v1/targets
```

## Linux service logs

```bash
systemctl status <service> --no-pager -l
journalctl -u <service> --since "15 minutes ago" --no-pager
ss -lntp
free -h
df -h
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
```
