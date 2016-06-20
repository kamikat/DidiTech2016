#!/bin/sh

cat init.sql
cat date.sql

find ../datasheet/season_2/training_data/order_data -type f | xargs -n1 ./order-transformer.py

