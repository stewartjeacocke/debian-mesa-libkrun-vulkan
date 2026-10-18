# Rebuild Debian's Mesa package with Venus allocation alignment.
# Required for GPU access on containers running with libkrun
# on Mac silicon.
FROM buildpack-deps:stable AS venus-builder

# Enable source repositories
# Install build dependencies
RUN set -eux; \
  sed -i -E '/^[[:space:]]*Types:/ { /(^|[[:space:]])deb-src([[:space:]]|$)/! s/$/ deb-src/; }' \
    /etc/apt/sources.list.d/debian.sources; \
  apt-get update; \
  apt-get build-dep -y --no-install-recommends mesa; \
  apt-get install -y --no-install-recommends \
  devscripts \
  ;

# Build with patch
COPY venus-16k-align.patch /build/
RUN set -eux; \
  mkdir /build/src; \
  cd /build/src; \
  apt-get source mesa; \
  cd mesa-*; \
  cp /build/venus-16k-align.patch \
    debian/patches/venus-16k-align.patch; \
  printf '%s\n' venus-16k-align.patch >> debian/patches/series; \
  export DEBFULLNAME='Stewart Jeacocke' DEBEMAIL='public@jeacocke.org.uk'; \
  dch --local '+venus16k' --distribution UNRELEASED \
    'Build Venus with 16 KiB allocation alignment.'; \
  dpkg-buildpackage -us -uc -b; \
  package=$(find .. -maxdepth 1 -name "mesa-vulkan-drivers_*_$(dpkg --print-architecture).deb" -print -quit); \
  test -n "${package}"; \
  install -D -m 0644 "${package}" /out/mesa-vulkan-drivers.deb

# Install the locally built Mesa package into the final runtime image.
FROM buildpack-deps:stable

COPY --from=venus-builder /out/mesa-vulkan-drivers.deb /tmp/
RUN set -eux; \
  apt-get install -y --no-install-recommends /tmp/mesa-vulkan-drivers.deb; \
  rm -rf /var/lib/apt/lists/* /tmp/mesa-vulkan-drivers.deb
