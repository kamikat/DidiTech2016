#!/usr/bin/env python

import sys

with open(sys.argv[1], "r") as data:
    line = data.readline()
    while line:
        print 'INSERT INTO didi.`poi` (district_hash, type, subtype, count) VALUES',
        record = line.split()
        tu = []
        for d in record[1:]:
            poi, c = d.strip().split(':')
            if poi.find('#') >= 0:
                t, sub = poi.split('#', 1)
            else:
                t, sub = (poi, '')
            tu.append('("%s", "%s", "%s", %s)' % (record[0], t, sub, c))
        print ','.join(tu) + ';'
        line = data.readline()
