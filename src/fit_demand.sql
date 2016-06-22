-- generate training data on demand
SELECT
  CONCAT_WS(',', district, date, is_holiday, time_slot,
            weather, temperature, pm25, level_1, level_2, level_3, level_4,
            poi_feature, demand) AS features
FROM intermediate
  JOIN poi_csv AS poi ON poi.district_hash = intermediate.district;