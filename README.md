# Debian Mesa for libkrun Vulkan

Rebuilds Debian's `mesa-vulkan-drivers` with the Venus 16 KiB allocation-alignment patch required for Vulkan in libkrun-based Apple Silicon containers.

## Use the package

[`example/Dockerfile`](example/Dockerfile) shows how to download and install the latest release package in another container image.

```sh
podman build -t mesa-vulkan-example ./example
podman run --rm mesa-vulkan-example vulkaninfo
```

## Build the package

```sh
build.sh
```
