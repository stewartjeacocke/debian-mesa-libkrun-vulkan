# Debian Mesa for libkrun Vulkan

Rebuilds Debian's `mesa-vulkan-drivers` with the Venus 16 KiB allocation-alignment patch required for Vulkan in libkrun-based Apple Silicon containers.

## Build release artifacts

```sh
mkdir -p dist
podman build --target venus-builder -t localhost/mesa-vulkan-builder:latest .
container_id=$(podman create localhost/mesa-vulkan-builder:latest)
podman cp "${container_id}:/dist/." ./dist/
podman rm "${container_id}"
(cd dist && sha256sum -c SHA256SUMS)
```