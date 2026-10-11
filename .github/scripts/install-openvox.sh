#!/usr/bin/env bash
# Install the OpenVox agent into a running Debian test container.
#
# usage: install-openvox.sh <container> <collection>   (collection: openvox8)
#
# puppet_agent::install (used by litmus:install_agent) has no OpenVox support,
# and Puppet's own apt repo has no puppet8 release package for Debian 13.
set -euo pipefail

container="$1"
collection="$2"

docker exec -i "${container}" bash -s -- "${collection}" <<'INNER'
set -euo pipefail
collection="$1"
. /etc/os-release
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq curl ca-certificates gnupg
curl -fsSL -o /tmp/release.deb "https://apt.voxpupuli.org/${collection}-release-debian${VERSION_ID}.deb"
dpkg -i /tmp/release.deb
apt-get update -qq
apt-get install -y -qq openvox-agent
for tool in puppet facter hiera; do
  ln -sf "/opt/puppetlabs/bin/${tool}" "/usr/local/bin/${tool}"
done
puppet --version
INNER
