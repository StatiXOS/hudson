#!/usr/bin/env python
from datetime import datetime

import random
import sys
import uuid

import yaml

def main():
    targets = sys.stdin.read()
    pipeline = {"steps": []}
    today = datetime.today()

    for line in targets.split("\n"):
        if not line or line.startswith("#"):
            continue
        device, build_type, variant = line.split()

        pipeline['steps'].append({
            'label': '{} {}'.format(device, today.strftime("%Y%m%d")),
            'trigger': 'build',
            'build': {
                'env': {
                    'DEVICE': device,
                    'STATIX_BUILD_TYPE': variant,
                    'BUILDTYPE': build_type,
                },
            },
        })
    print(yaml.dump(pipeline))

if __name__ == '__main__':
    main()
