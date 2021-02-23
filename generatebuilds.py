#!/usr/bin/env python
from datetime import datetime

import random
import sys
import uuid

import json
import yaml

def main():
    targets = sys.stdin.read()
    pipeline = {"steps": []}
    today = datetime.today()

    for line in targets.split("\n"):
        if not line or line.startswith("#"):
            continue
        device, build_type, variant = line.split()
        fastbootimages, recovery = device_info(device)

        pipeline['steps'].append({
            'label': '{} {} {}'.format(device, variant, today.strftime("%Y%m%d")),
            'trigger': 'build',
            'build': {
                'env': {
                    'DEVICE': device,
                    'STATIX_BUILD_TYPE': variant,
                    'BUILDTYPE': build_type,
                    'FASTBOOTIMAGES': fastbootimages,
                    'RECOVERY': recovery,
                },
                'branch': "${BUILDKITE_BRANCH}"
            },
        })
    print(yaml.dump(pipeline))

def device_info(device):
    open_devices = open('devices.json')
    devices = json.load(open_devices)
    for line in devices['official_devices']:
        if line['codename'] == device:
            fastbootimages = line['fastbootimages']
            recovery = line['lineage_recovery']
            return fastbootimages, recovery

if __name__ == '__main__':
    main()
