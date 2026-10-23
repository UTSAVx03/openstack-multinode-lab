#!/usr/bin/env bash
# Read-only migration validation. Does not start or retry a migration.
# Run on the controller after sourcing your own ~/admin-openrc.
set -u

echo "===== VM PLACEMENT ====="
openstack server show migration-test-vm \
  -c name -c status \
  -c OS-EXT-SRV-ATTR:host \
  -c OS-EXT-SRV-ATTR:hypervisor_hostname

echo
echo "===== MIGRATION HISTORY ====="
openstack server migration list --server migration-test-vm

echo
echo "===== COMPUTE HEALTH ====="
openstack compute service list
openstack hypervisor list

echo
echo "No migration or state-reset action was run by this script."
