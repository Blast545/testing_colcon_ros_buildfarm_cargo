#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
source venv/bin/activate

ros_buildfarm release \
    --config-url "file://$PWD/configs/buildfarm_config/index.yaml" \
    --ros-distro rolling \
    --target-platform ubuntu:resolute:amd64 \
    --package-import local \
    --packages-select ros_tokio_demo
