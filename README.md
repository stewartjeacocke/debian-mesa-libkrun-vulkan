# Debian Mesa for libkrun Vulkan

Podman's documented [GPU access setup](https://podman-desktop.io/docs/podman/gpu) 
for Apple Silicon Macs only works with Fedora-based images. It uses a patched
[mesa vulkan package](https://copr.fedorainfracloud.org/coprs/slp/mesa-libkrun-vulkan/).

This project rebuilds Debian's `mesa-vulkan-drivers` with the same Venus 16 KiB 
allocation-alignment patch, enabling GPU access from Debian-based images.

## Use the package

[`example/Dockerfile`](example/Dockerfile) shows how to download and install the latest release package in another container image.

```sh
podman build -t mesa-vulkan-example ./example
podman run --device=/dev/dri --rm mesa-vulkan-example vulkaninfo | grep GPU
```

## Build the package

```sh
build.sh
```
