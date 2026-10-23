# OpenStack lab — interview preparation

## 45–60 second project explanation

> I built a four-node OpenStack lab with one controller, two compute nodes and a dedicated storage node. I worked with the core OpenStack services, including Keystone, Glance, Nova, Neutron, Placement and Cinder. The compute nodes used Nova Compute with libvirt and QEMU/KVM, while Neutron used Open vSwitch agents for virtual networking. On the storage node I configured an LVM-backed Cinder volume path using iSCSI/TGT, and I shared the Nova instance directory over NFS between both compute nodes. I validated a Cinder volume attachment, tested shared NFS visibility, and successfully completed and confirmed a cold migration from Compute1 to Compute2. I then installed Node Exporter across all four nodes, connected Prometheus to Grafana, and built a dashboard for node health, CPU, memory, disk and network metrics. Live migration remains an area I investigated but did not complete; I documented the failed attempts and the checks I performed rather than claiming success.

## Core questions and answers

### 1. What is OpenStack?

OpenStack is an open-source IaaS platform made of services that expose APIs for compute, networking, identity, images, storage and other cloud functions.

### 2. What is the difference between Nova and libvirt?

Nova manages the cloud instance lifecycle and coordinates the compute workflow. Libvirt is a virtualization management interface that Nova uses to control supported hypervisors and QEMU/KVM instances.

### 3. What does Keystone do?

Keystone authenticates users and services, issues tokens, manages identity/role information, and provides a service catalog.

### 4. What is Glance?

Glance provides image metadata and image data used to launch instances. An image is a template; a VM instance is a created deployment from that template.

### 5. What is Neutron?

Neutron provides virtual networking: networks, subnets, ports, routers, security groups and related connectivity. In this lab I used Neutron with Open vSwitch agents.

### 6. What is Placement?

Placement tracks resource-provider inventories and allocations, such as CPU and memory, used when Nova makes scheduling decisions.

### 7. What does Cinder provide?

Cinder provides persistent block volumes. In my lab, Cinder used an LVM backend on the storage node and presented volumes to compute hosts over iSCSI/TGT.

### 8. What is the difference between Cinder and NFS?

Cinder presents block devices; NFS presents files through a shared filesystem. My Cinder test volume was attached to an instance, while NFS shared `/srv/nova-shared/instances` between Compute1 and Compute2.

### 9. What are an iSCSI target and initiator?

The target exports block storage. The initiator connects to that target. In my setup, the storage node provided the TGT target and a compute host used the iSCSI initiator to connect to it.

### 10. What is the difference between cold and live migration?

Cold migration moves an instance to another compute host with downtime during the migration process. Live migration is intended to move a running instance with limited interruption and has additional requirements for the virtualization/migration path. I verified cold migration; live migration did not complete successfully in my lab.

### 11. Why does shared storage not automatically make live migration work?

The destination must also be able to access the instance files, but live migration has additional requirements: the source and destination hypervisor setup, migration transport/URI, authentication/permissions, CPU compatibility, networking and Nova/libvirt configuration must all work.

### 12. How would you troubleshoot a VM stuck in `BUILD`?

Check the instance status and fault first, then scheduler, Placement, compute-service health, available resources, image retrieval, Neutron port/networking, and relevant service logs. Avoid changing many components simultaneously because it becomes harder to isolate the cause.

### 13. How would you troubleshoot a Cinder volume attach failure?

Check the volume state and attachment details, Cinder service health, backend LVM state, target configuration, iSCSI sessions and device discovery on the compute host. Compare the OpenStack attachment path with actual guest/host device names.

### 14. What is RabbitMQ used for?

RabbitMQ is a message broker used by OpenStack service processes for RPC and internal coordination. It is not where VM disk data is stored.

### 15. What is the monitoring flow in your project?

Node Exporter exposes Linux host metrics on port 9100; Prometheus scrapes and stores those metrics on port 9090; Grafana queries Prometheus and presents dashboards on port 3000.

## Project-specific troubleshooting story: live migration

Use a transparent answer:

> My initial live-migration attempts returned Nova `MigrationError_Remote` HTTP 500, and the instance stayed on Compute1. I compared compute-service state, shared NFS mounts, libvirt/SSH connectivity and migration records. I then changed approach and successfully completed the standard cold-migration workflow to Compute2, confirmed the migration, and verified that the VM was active on the destination. I left the live-migration issue documented as unresolved because I did not isolate a single confirmed root cause.

## Commands worth knowing

```bash
openstack server show <instance>
openstack compute service list
openstack hypervisor list
openstack network agent list
openstack volume service list
openstack server migration list --server <instance>
sudo systemctl is-active nova-compute
sudo systemctl is-active libvirtd
sudo journalctl -u nova-compute --since "15 minutes ago" --no-pager
sudo pvs && sudo vgs && sudo lvs
sudo iscsiadm -m session
findmnt /srv/nova-shared/instances
curl -fsS http://127.0.0.1:9100/metrics >/dev/null
```
