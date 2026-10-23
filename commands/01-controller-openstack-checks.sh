#!/usr/bin/env bash
# Read-only diagnostics for the OpenStack controller.
# Source your own ~/admin-openrc in this shell before running OpenStack CLI checks.
set -u

echo "===== CONTROLLER ====="
hostname
ip -br addr
ip route

echo
echo "===== OPENSTACK SERVICES ====="
openstack compute service list
openstack hypervisor list
openstack network agent list
openstack volume service list

echo
echo "===== TEST VM ====="
openstack server show migration-test-vm \
  -c name -c status \
  -c OS-EXT-SRV-ATTR:host \
  -c OS-EXT-SRV-ATTR:hypervisor_hostname
