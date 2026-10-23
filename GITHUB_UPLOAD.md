# Upload this project to GitHub (Mac-friendly steps)

The ZIP is already arranged as a repository folder. **Upload the files and folders inside it, not the ZIP file itself.** The simplest option is GitHub's web upload page; GitHub's official docs support dragging files or folders into the upload page: <https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository>.

## Method A — GitHub website (no terminal required)

1. Download `openstack-multinode-lab-github.zip` and double-click it on your Mac to extract the `openstack-multinode-lab` folder.
2. Open <https://github.com/new> and sign in.
3. Repository name: `openstack-multinode-lab`.
4. Description: `Four-node OpenStack lab with Cinder LVM/iSCSI, shared NFS storage, cold migration, Prometheus and Grafana monitoring.`
5. Choose **Public** only after you are comfortable exposing the screenshots and private lab IPs; otherwise begin as **Private**. For easiest first upload, leave “Add a README”, `.gitignore`, and license unchecked because the project already has those files.
6. Click **Create repository**.
7. On the empty repository page, choose **Add file → Upload files**.
8. In Finder, open the extracted `openstack-multinode-lab` folder. Select everything *inside* the folder (including `.gitignore`, `README.md`, `docs`, `commands`, `outputs`, `examples`, and `evidence`) and drag the selection onto the GitHub upload page. If the browser will not accept folders in one drop, use the fallback below or upload each subfolder's contents while preserving the folder names.
9. Wait for the upload list to finish. Review it: the root should show `README.md`, and the subfolders should be present. Do not upload the original unredacted terminal markdown files from elsewhere on your computer.
10. Commit message: `Add OpenStack multinode lab documentation and evidence`.
11. Click **Commit changes**.
12. Open the repository front page and check that README image embeds and links work. Click the evidence images to ensure they are viewable.

## Method B — GitHub Desktop (best fallback for retaining the folder tree)

Official guide: <https://docs.github.com/en/desktop/adding-and-cloning-repositories/adding-an-existing-project-to-github-using-github-desktop>.

1. Install GitHub Desktop from <https://desktop.github.com/> and sign in to your GitHub account.
2. In GitHub Desktop, use **File → Add Local Repository** and select the extracted `openstack-multinode-lab` folder. If it says the folder is not a Git repository, follow its **create a repository** link and create the repository at that same folder path; keep the existing files and do not replace the README.
3. Review the changed-files list. Make sure it contains this project's documentation, command files and evidence screenshots, and no credentials or raw logs.
4. Summary: `Add OpenStack multinode lab documentation and evidence`.
5. Click **Commit to main**.
6. Click **Publish repository**. Enter `openstack-multinode-lab`, choose Public or Private, and publish.
7. Use **Repository → View on GitHub** to open the published page.

## Final public-repository check

- `README.md` displays on the repository landing page.
- All eight screenshots under `evidence/` are visible.
- `docs/`, `commands/`, `outputs/`, and `examples/` are present.
- No `admin-openrc`, `clouds.yaml`, private key, password, raw config or unredacted terminal dump was uploaded.
- The result table clearly states that cold migration succeeded and live migration remains unresolved.
