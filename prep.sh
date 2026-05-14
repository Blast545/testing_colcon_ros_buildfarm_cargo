#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
source venv/bin/activate

rm -rf release_repo
mkdir release_repo
cp -r source_crate/. release_repo/
cd release_repo
bloom-generate debian --os-name ubuntu --os-version resolute --ros-distro rolling
git init -q
git add -A
git -c user.email=jjperez@ekumenlabs.com -c user.name='Jorge Perez' commit -q -m 'ros_tokio_demo 0.1.0-1 for rolling'
git branch -M release/rolling/ros_tokio_demo
git tag release/rolling/ros_tokio_demo/0.1.0-1
git remote add origin git@github.com:Blast545/ros_tokio_demo-release.git
