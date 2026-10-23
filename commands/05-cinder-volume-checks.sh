#!/usr/bin/env bash
# Run on the controller after sourcing a local OpenStack RC file.
# This script only reads Cinder state. LVM checks belong on the storage node.
set -u

echo "===== CINDER VOLUME ====="
openstack volume show test-volume \
  -c id -c name -c size -c status -c attachments

echo
echo "===== CINDER SERVICES ====="
openstack volume service list

echo
echo "===== NEXT CHECKS ON STORAGE NODE ====="
echo "sudo pvs"
echo "sudo vgs"
echo "sudo lvs -a"
echo "sudo tgtadm --mode target --op show"

echo
echo "===== NEXT CHECK ON COMPUTE NODE ====="
echo "sudo iscsiadm -m session"
echo "lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS"
