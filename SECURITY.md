# Security and publication notes

This repository documents a learning lab. It is not a production hardening guide.

Before publishing or updating the repository:

- Do not commit OpenStack RC files, passwords, tokens, private SSH keys, cloud credentials, unredacted logs or full service configuration files containing secrets.
- Review screenshot evidence before publishing. The storage-node screenshot in this repository was prepared with the account/ACL section omitted.
- These IPs are private lab addresses. Replace them with placeholders if you do not want to publish the lab's internal addressing scheme.
- If any password or token from the original lab transcript was real and still active, rotate it. Removing a value from a later commit does not remove it from Git history.
- Keep management interfaces such as Horizon, Grafana, SSH, and OpenStack APIs on trusted networks unless they have been deliberately secured for external access.
- The shell files in `commands/` are intended for validation and diagnostics; they do not configure a new cloud or repair a service automatically.
