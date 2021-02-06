#!/bin/bash

# This fetches the data that was filled out in the previous step

device=$(buildkite-agent meta-data get build-device)
build_type=$(buildkite-agent meta-data get build-type)
stx_build_type=$(buildkite-agent meta-data get stx-build-type)
recovery=$(buildkite-agent meta-data get recovery)
fastbootimage=$(buildkite-agent meta-data get fastboot-images)
DEVICE=$device BUILDTYPE=$build_type STATIX_BUILD_TYPE=$stx_build_type RECOVERY=$recovery FASTBOOTIMAGES=$fastbootimage ./build.sh
