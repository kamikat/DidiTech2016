#!/bin/sh

cat init.sql
cat date.sql

find ../datasheet/season_2/training_data/order_data -type f | xargs -n1 ./order-transformer.py
find ../datasheet/season_2/training_data/traffic_data -type f | xargs -n1 ./traffic-transformer.py
find ../datasheet/season_2/training_data/weather_data -type f | xargs -n1 ./weather-transformer.py

./poi-transformer.py ../datasheet/season_2/training_data/poi_data/poi_data
./district-transformer.py ../datasheet/season_2/training_data/cluster_map/cluster_map

