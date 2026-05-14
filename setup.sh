#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install git+https://github.com/ros-infrastructure/ros_buildfarm.git
pip install git+https://github.com/colcon/colcon-ros-buildfarm.git
pip install git+https://github.com/Blast545/bloom.git@blast545/cargo_debian_template
