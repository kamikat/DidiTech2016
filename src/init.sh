#!/bin/sh

DATA_DIR=$1

cat init.sql
cat date.sql

find $DATA_DIR/order_data -type f | xargs -n1 ./order-transformer.py
find $DATA_DIR/traffic_data -type f | xargs -n1 ./traffic-transformer.py
find $DATA_DIR/weather_data -type f | xargs -n1 ./weather-transformer.py

./poi-transformer.py $DATA_DIR/poi_data/poi_data
./district-transformer.py $DATA_DIR/cluster_map/cluster_map

