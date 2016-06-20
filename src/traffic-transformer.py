#!/usr/bin/env python

import sys

with open(sys.argv[1], "r") as data:
    line = data.readline()
    count = 0;
    while line:
        if count == 0:
            print 'INSERT INTO didi.traffic (district_hash, level_1, level_2, level_3, level_4, date, time_slot) VALUES',
        (district_hash, level_1, level_2, level_3, level_4, date, time) = line.split()
        time = time.split(':')
        time_slot = int(time[0]) * 6 + int(time[1]) / 10 + 1
        line = data.readline()
        print '("%s", %s, %s, %s, %s, "%s", %d)' % (district_hash, level_1[2:], level_2[2:], level_3[2:], level_4[2:], date, time_slot),
        count += 1
        if count == 100:
            print ';'
            count = 0
            continue
        if line:
            print ',',
    print ';'
