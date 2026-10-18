FROM buildpack-deps:stable

# Get the deb for the latest release
RUN curl -fsSL https://api.github.com/repos/stewartjeacocke/debian-mesa-libkrun-vulkan/releases/latest \
  | sed -nE 's/^[[:space:]]*"browser_download_url":[[:space:]]*"([^"]*mesa-vulkan-drivers_[^"]*_arm64\.deb)",?$/\1/p' \
  | wget -q -i - -P /tmp

RUN apt-get update && apt-get install -y --no-install-recommends \
  /tmp/mesa-vulkan-drivers_*.deb \
  vulkan-tools \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/mesa-vulkan-drivers_*.deb
