ARG VARIANT
FROM mcr.microsoft.com/devcontainers/${VARIANT} AS base

# Install OpenTofu
COPY .github/scripts/opentofu-install.sh /tmp/opentofu-install.sh
RUN bash /tmp/opentofu-install.sh && rm /tmp/opentofu-install.sh
