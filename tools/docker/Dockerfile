# Docfx preview server for the azure-devops-docs repo.
# Builds and serves the /docs site so VS Code (Insiders) can route to it
# through automatic port forwarding or the Simple Browser. A file watcher
# rebuilds the site automatically when Markdown / YAML files change in
# the bind-mounted repo, so you can edit and refresh.
FROM mcr.microsoft.com/dotnet/sdk:8.0

ARG DOCFX_VERSION=2.78.3

# tini gives us a proper init so signals (Ctrl+C / docker stop) propagate
# to the background docfx serve process and the watch loop. inotify-tools
# is kept available even though the watcher uses mtime polling on
# Windows-host bind mounts. jq is used by entrypoint.sh to generate a
# scoped docfx config when PREVIEW_SCOPE is set.
RUN apt-get update \
    && apt-get install -y --no-install-recommends inotify-tools tini jq python3 \
    && rm -rf /var/lib/apt/lists/*

# Install docfx as a global .NET tool.
RUN dotnet tool install --global docfx --version ${DOCFX_VERSION}
ENV PATH="${PATH}:/root/.dotnet/tools"

# /repo is the bind-mounted repository root (read-only is fine).
# /site is where docfx writes generated output (kept inside the container
# so generated files never leak into `git status`).
# /template holds our custom template overlay (Learn-ish polish on top of
# the bundled "modern" template).
WORKDIR /repo/docs
VOLUME ["/site"]

# Copy the template overlay and the entrypoint script.
COPY template /template
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
