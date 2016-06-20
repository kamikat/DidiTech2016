#!/usr/bin/env python

import sys

with open(sys.argv[1], "r") as data:
    line = data.readline()
    count = 0;
    while line:
        if count == 0:
            print 'INSERT INTO didi.`district` (district_hash, district_id) VALUES',
        record = line.split()
        line = data.readline()
        print '("%s", %s)' % (record[0], record[1]),
        count += 1
        if count == 10:
            print 'ON DUPLICATE KEY UPDATE district_hash = district_hash;'
            count = 0
            continue
        if line:
            print ',',
    print 'ON DUPLICATE KEY UPDATE district_hash = district_hash;'
