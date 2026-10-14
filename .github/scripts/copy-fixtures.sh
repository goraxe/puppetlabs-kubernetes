#!/usr/bin/env bash
# Copy the fixture modules (spec/fixtures/modules) and the module under test
# into the production environment of a test container.
set -euo pipefail

container="$1"
dest=/etc/puppetlabs/code/environments/production/modules

docker exec "${container}" mkdir -p "${dest}/kubernetes"

# The kubernetes fixture is a symlink back to the repository, which contains
# spec/fixtures itself, so it is copied separately and without following it.
tar -C spec/fixtures/modules --exclude=.git --exclude=./kubernetes -cf - . | docker exec -i "${container}" tar -C "${dest}" -xf -
tar --exclude=.git --exclude=./spec --exclude=./tooling --exclude=./.github -cf - . | docker exec -i "${container}" tar -C "${dest}/kubernetes" -xf -
docker exec "${container}" ls "${dest}"
