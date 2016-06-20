#!/usr/bin/env python

import sys

with open(sys.argv[1], "r") as data:
    line = data.readline()
    count = 0;
    while line:
        if count == 0:
            print 'INSERT INTO didi.weather (date, time_slot, weather, temperature, pm25) VALUES',
        (date, time, weather, temperature, pm25) = line.split()
        time = time.split(':')
        time_slot = int(time[0]) * 6 + int(time[1]) / 10 + 1
        line = data.readline()
        print '("%s", %d, %s, %s, %s)' % (date, time_slot, weather, temperature, pm25),
        count += 1
        if count == 100:
            print ';'
            count = 0
            continue
        if line:
            print ',',
    print ';'
