#!/usr/bin/env bash
# Copy spec/fixtures/modules (symlinks followed, so the module under test is
# included) into the production environment of a test container.
set -euo pipefail

container="$1"
dest=/etc/puppetlabs/code/environments/production/modules

docker exec "${container}" mkdir -p "${dest}"
tar -h -C spec/fixtures/modules --exclude=.git -cf - . | docker exec -i "${container}" tar -C "${dest}" -xf -
docker exec "${container}" ls "${dest}"
