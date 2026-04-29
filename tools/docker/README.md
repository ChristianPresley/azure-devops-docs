# Docfx preview in Docker

Runs the `/docs` docfx preview site inside a container and exposes it on
`http://localhost:8080`, with a file watcher that auto-rebuilds and a
livereload script that auto-refreshes the browser when content changes.
Use this instead of `tools/scripts/start-docs.ps1` when you don't want
to install docfx / .NET locally.

## Prerequisites

- Docker Desktop (or any Docker engine) running on the host.
- VS Code Insiders open at the repo root (for automatic port forwarding
  and the Simple Browser).

## Start

From the repo root:

```powershell
docker compose -f tools/docker/docker-compose.yml up --build -d
```

First run builds the image and runs the initial `docfx build`
(~1–3 minutes for the full site); later runs reuse the cached image and
the persisted `docfx-site` volume.

The landing URL `http://localhost:8080/` redirects to a real article so
you don't see the bare TOC frame.

## View in VS Code Insiders

- VS Code Insiders auto-detects port `8080` and lists it in the **Ports**
  panel (Terminal -> Ports). Click the globe icon, or
- Open the command palette and run **Simple Browser: Show**, then enter
  `http://localhost:8080/`.

## How refresh works

You do **not** need to run `docfx build` manually.

The container's entrypoint runs three things in parallel:

1. `docfx serve` — serves the static site from `/site` on port 8080.
2. A polling watcher fingerprints `/repo/docs` (mtime + size) every
   `PREVIEW_POLL_INTERVAL` seconds. When the fingerprint changes, it
   waits `PREVIEW_DEBOUNCE_INTERVAL` seconds (so a flurry of saves
   coalesces) and then runs `docfx build` again.
3. After every build, `/site/__build-id.txt` is updated with a fresh
   nanosecond timestamp. A small `<script>` injected into every built
   HTML page polls that file every 1.2 seconds and calls
   `location.reload()` when it changes — so any open browser tab
   auto-refreshes once the rebuild finishes.

Polling is used instead of inotify because Docker Desktop bind mounts
from a Windows host do not deliver inotify events reliably.

### Refresh tuning knobs

All knobs are environment variables on the compose service. Set them in
your shell **before** `docker compose up`:

| Variable                    | Default | Effect                                                                              |
| --------------------------- | ------- | ----------------------------------------------------------------------------------- |
| `PREVIEW_POLL_INTERVAL`     | `1`     | Seconds between fingerprint checks. Lower = faster save→build-start.                |
| `PREVIEW_DEBOUNCE_INTERVAL` | `1`     | Seconds to wait after a change before kicking off the rebuild.                      |
| `PREVIEW_SCOPE`             | (empty) | Experimental. Build only one top-level subtree. See **Scoped builds** below.        |

Example (PowerShell):

```powershell
$env:PREVIEW_POLL_INTERVAL = '2'
$env:PREVIEW_DEBOUNCE_INTERVAL = '2'
docker compose -f tools/docker/docker-compose.yml up -d
```

### Expected timings

On a Docker Desktop / Windows host with the repo bind-mounted into the
container, the dominant cost is `find`-stating ~7000+ files across the
bind mount (~15-20 seconds). Realistic numbers measured against this
repo:

| Phase                                    | Time              |
| ---------------------------------------- | ----------------- |
| Watcher detects change after save        | ~14 seconds       |
| `docfx build` itself                     | ~150-200 seconds  |
| **Total save → updated HTML served**     | **~3-4 minutes**  |
| Browser notices and reloads (after that) | <2 seconds        |

The watcher runs `find` to fingerprint the docs tree, and that walk is
the dominant cost on Windows hosts. On native Linux or macOS hosts the
detection step is much faster (sub-second). Lowering
`PREVIEW_POLL_INTERVAL` further has diminishing returns until the
fingerprint cost itself is reduced.

If you want faster turnaround on Windows, see **Scoped builds** below.

### Scoped builds (experimental)

Setting `PREVIEW_SCOPE` to a top-level docs subtree (for example
`user-guide`, `pipelines`, `boards`) generates a restricted docfx config
and watches only that subtree. The **initial** scoped build is much
faster than the full repo (~5 seconds for `user-guide` vs ~90 seconds
for everything).

Known limitation in this setup: scoped *rebuilds* with docfx 2.78.3 do
not always rewrite the article HTML files even though the build reports
success and updates the build-id. Treat `PREVIEW_SCOPE` as experimental
and verify the rendered HTML actually changed (not just the build-id)
before relying on it. Leave `PREVIEW_SCOPE` unset for the known-good
full-fidelity build.

## Performance on Windows hosts

The slow part on Windows isn't Docker per se — it's the bind mount path
from `C:\...` into the container. With the WSL2 backend (the default
for modern Docker Desktop), Docker Desktop reaches Windows-side files
via WSL2's 9p / drvfs translation layer. Every file stat crosses that
boundary, so the watcher's `find` walk over ~7000+ files takes 15-20
seconds and docfx's read phase pays a similar tax. You can confirm the
mount type with:

```powershell
docker exec azure-devops-docs-preview mount | Select-String /repo
```

On Windows you'll see `type 9p ... aname=drvfs;path=C:\...`.

Note that Docker Desktop's "VirtioFS for file sharing" toggle is
**Mac-only** and the "Synchronized file shares" feature explicitly
doesn't work with the WSL2 backend, so neither option helps here.

The one fast path that keeps this exact setup working is to move the
repo onto the WSL2 ext4 filesystem so the bind mount becomes
WSL-ext4 → container with no Windows boundary in the way:

1. From a WSL prompt (`wsl` in a terminal), `git clone` the repo into
   `~/azure-devops-docs` (or anywhere under `/home/<you>/`).
2. Open that path in VS Code (use the **WSL: Open Folder in WSL**
   command, or open `\\wsl$\<distro>\home\<you>\azure-devops-docs`
   from Windows).
3. Run `docker compose -f tools/docker/docker-compose.yml up -d` from
   inside that WSL session. Same image, same compose file, no code
   changes.

In that configuration the watcher's `find` walk drops from ~15-20 s to
sub-second, and the docfx build's read phase speeds up too. Native
Linux or macOS hosts have neither cost and run the preview
substantially faster without any tweaks.

## Force a clean rebuild

Restart the container:

```powershell
docker compose -f tools/docker/docker-compose.yml restart
```

Or wipe the cached site and rebuild from scratch:

```powershell
docker compose -f tools/docker/docker-compose.yml down -v
docker compose -f tools/docker/docker-compose.yml up -d
```

(The `-v` flag also deletes the `docfx-site` volume.)

## Stop

```powershell
docker compose -f tools/docker/docker-compose.yml down
```
