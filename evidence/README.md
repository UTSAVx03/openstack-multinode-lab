# Evidence index

All eight images included in this folder are the reviewed evidence assets referenced from the main README. They were prepared from screenshots and terminal outputs shared during the project. They are not synthetic dashboard mockups.

| File | Category | What it supports | Notes |
|---|---|---|---|
| [`grafana-dashboard.jpg`](grafana-dashboard.jpg) | Monitoring | Grafana dashboard with four node-health indicators and CPU, memory, disk, RX and TX panels | Legend formatting remains imperfect in a few panels; this is the actual captured dashboard view. |
| [`horizon-overview.jpg`](horizon-overview.jpg) | OpenStack UI | Horizon project overview with resource quota/usage summary | Demonstrates the UI was available in the captured session. |
| [`cold-migration-evidence.png`](cold-migration-evidence.png) | Compute / migration | VM active on Compute2 and the confirmed migration record | Earlier live-migration errors remain visible in the history and are documented as unresolved. |
| [`cinder-volume-attachment.png`](cinder-volume-attachment.png) | Block storage | `test-volume` shown as `in-use` and attached on Compute2 | Short captured output extract. |
| [`compute1-validation.png`](compute1-validation.png) | Compute | Compute1 address, service checks, shared NFS mount, instance list and Node Exporter check | Point-in-time validation. |
| [`compute2-validation.png`](compute2-validation.png) | Compute | Compute2 validation, shared NFS mount, instance list and Node Exporter check | Point-in-time validation. |
| [`storage-node-validation-redacted.png`](storage-node-validation-redacted.png) | Storage | LVM/iSCSI/TGT-related output, NFS exports to both computes and Node Exporter | Account/ACL detail from the original output was omitted from this prepared image. |
| [`prometheus-exporter-checks.png`](prometheus-exporter-checks.png) | Monitoring | Prometheus readiness, four exporter checks and Grafana service check | These are captured checks, not a real-time health endpoint. |

The selected screenshots do not include the raw pasted `.md` terminal dumps, because those files may contain credentials, sensitive configuration values, or irrelevant troubleshooting output. The `outputs/` folder contains brief, sanitized extracts instead.
