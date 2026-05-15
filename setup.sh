#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install git+https://github.com/ros-infrastructure/ros_buildfarm.git
pip install git+https://github.com/colcon/colcon-ros-buildfarm.git
pip install git+https://github.com/Blast545/bloom.git@blast545/cargo_debian_template

# Spike-only patches against the venv install. These should eventually move
# upstream (PR against ros_buildfarm + a bloom PR #774 follow-up).
RBF=venv/lib/python3.14/site-packages/ros_buildfarm
BLOOM_CARGO=venv/lib/python3.14/site-packages/bloom/generators/debian/templates/cargo

# 1) ros_buildfarm clones itself fresh inside the build container, so patch the
# template that emits the clone block to also sed `dh-cargo` into the cloned
# sourcedeb Dockerfile template (PR #774's rules.em uses --buildsystem=cargo).
sed -i "/rm -fr ros_buildfarm\/doc/a\\        \"sed -i 's/python3-yaml\$/dh-cargo python3-yaml/' ros_buildfarm/ros_buildfarm/templates/release/deb/sourcepkg_task.Dockerfile.em\"," \
    $RBF/templates/snippet/builder_shell_clone-ros-buildfarm.xml.em

# 2) PR #774's cargo template depends on `pallet-patcher`, which isn't in any
# apt repo. Drop it from BuildDepends + the rules.em invocation so the
# binarydeb container can resolve build deps.
sed -i "s/, 'pallet-patcher'//" $BLOOM_CARGO/control.em
sed -i '/pallet-patcher --output-format/,/^$/d; /Generate a pallet-patcher/d; /vendoring solution/d; s/ pallet-patcher.toml//' $BLOOM_CARGO/rules.em
