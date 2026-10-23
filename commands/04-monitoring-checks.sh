#!/usr/bin/env bash
# Run on the controller. Checks the local Prometheus/Grafana services and all exporters.
set -u

echo "===== SERVICE STATUS ====="
for svc in prometheus grafana-server prometheus-node-exporter; do
  printf '%-32s' "$svc"
  systemctl is-active "$svc" 2>/dev/null || true
done

echo
echo "===== PROMETHEUS READY ====="
curl -fsS http://127.0.0.1:9090/-/ready || true

echo
echo "===== GRAFANA HEALTH ====="
curl -fsS http://127.0.0.1:3000/api/health || true

echo
echo "===== NODE EXPORTERS ====="
for item in controller:172.18.84.22 compute1:172.18.84.23 compute2:172.18.84.32 storage:172.18.84.33; do
  name=${item%%:*}
  ip=${item#*:}
  curl -fsS --max-time 5 "http://${ip}:9100/metrics" >/dev/null \
    && echo "$name OK" \
    || echo "$name FAILED"
done

echo
echo "===== PROMETHEUS TARGET API ====="
curl -fsS http://127.0.0.1:9090/api/v1/targets || true
