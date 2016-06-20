#!/usr/bin/env python

import sys

def nullable_string(data):
    if data == 'NULL':
        return data;
    else:
        return '"%s"' % data

with open(sys.argv[1], "r") as data:
    line = data.readline()
    count = 0;
    while line:
        if count == 0:
            print 'INSERT INTO didi.`order` (order_id, driver_id, passenger_id, start_district_hash, dest_district_hash, price, date, time_slot) VALUES',
        (order_id, driver_id, passenger_id, start_district_hash, dest_district_hash, price, datetime) = line.split('\t')
        datetime = datetime.split(" ")
        time_slot = datetime[1].split(":")
        time_slot = int(time_slot[0]) * 6 + int(time_slot[1]) / 10 + 1
        line = data.readline()
        print '(%s, %s, %s, %s, %s, %s, %s, %d)' % (
                nullable_string(order_id),
                nullable_string(driver_id),
                nullable_string(passenger_id),
                nullable_string(start_district_hash),
                nullable_string(dest_district_hash),
                price,
                nullable_string(datetime[0]),
                time_slot),
        count += 1
        if count == 100:
            print 'ON DUPLICATE KEY UPDATE driver_id = driver_id;'
            count = 0
            continue
        if line:
            print ',',
    print ' ON DUPLICATE KEY UPDATE driver_id = driver_id;'
