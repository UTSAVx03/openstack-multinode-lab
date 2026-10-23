#!/usr/bin/env bash
# Run on compute1 or compute2. Diagnostics only; no configuration is changed.
set -u

echo "===== HOST / NETWORK ====="
hostname
ip -br addr
ip route

echo
echo "===== SERVICES ====="
for svc in nova-compute libvirtd prometheus-node-exporter; do
  printf '%-32s' "$svc"
  systemctl is-active "$svc" 2>/dev/null || true
done

echo
echo "===== LIBVIRT INSTANCES ====="
sudo virsh list --all

echo
echo "===== SHARED NFS ====="
findmnt /srv/nova-shared/instances || true
df -h /srv/nova-shared/instances 2>/dev/null || true

echo
echo "===== NODE EXPORTER ====="
curl -fsS http://127.0.0.1:9100/metrics >/dev/null \
  && echo "Node Exporter endpoint OK" \
  || echo "Node Exporter endpoint not responding"
