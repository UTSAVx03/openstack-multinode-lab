#!/usr/bin/env bash
# Run on the storage node. Read-only diagnostics; LVM layout is not modified.
set -u

echo "===== STORAGE HOST ====="
hostname
ip -br addr
ip route

echo
echo "===== SERVICES ====="
for svc in cinder-volume tgt nfs-kernel-server prometheus-node-exporter; do
  printf '%-32s' "$svc"
  systemctl is-active "$svc" 2>/dev/null || true
done

echo
echo "===== LVM ====="
sudo pvs
sudo vgs
sudo lvs -a

echo
echo "===== TGT TARGETS ====="
sudo tgtadm --mode target --op show 2>/dev/null || true

echo
echo "===== NFS EXPORTS ====="
sudo exportfs -v

echo
echo "===== NODE EXPORTER ====="
curl -fsS http://127.0.0.1:9100/metrics >/dev/null \
  && echo "Node Exporter endpoint OK" \
  || echo "Node Exporter endpoint not responding"
