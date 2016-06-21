-- aggregate demand answer table on each time slot
CREATE TABLE order_stat (
  SELECT
  start_district_hash        AS district_hash,
  COUNT(start_district_hash) AS demand,
  COUNT(driver_id)           AS answer,
  date,
  time_slot
  FROM didi.`order`
  GROUP BY start_district_hash, date, time_slot
  ORDER BY date ASC, time_slot ASC
);

-- process poi features
DROP TABLE IF EXISTS poi_index, poi_feature;

CREATE TABLE poi_index (
  SELECT DISTINCT type
  FROM poi
);

CREATE TABLE poi_feature (
  SELECT
  district.district_hash,
  poi_index.type,
  COALESCE(SUM(poi.count), 0) AS count
  FROM district
  CROSS JOIN poi_index
  LEFT JOIN poi ON poi.district_hash = district.district_hash AND poi.type = poi_index.type
  GROUP BY district_hash, type
);

CREATE INDEX poi_feature_district_hash_index ON didi.poi_feature (district_hash, type);

-- create intermediate training set (without poi data)
DROP TABLE IF EXISTS intermediate;

CREATE TABLE intermediate (
  SELECT
  order_stat.demand - order_stat.answer AS gap,
  order_stat.district_hash              AS district,
  order_stat.date                       AS date,
  calendar.is_holiday                   AS is_holiday,
  order_stat.time_slot                  AS time_slot,
  weather.weather                       AS weather,
  weather.pm25                          AS pm25,
  weather.temperature                   AS temperature,
  traffic.level_1                       AS level_1,
  traffic.level_2                       AS level_2,
  traffic.level_3                       AS level_3,
  traffic.level_4                       AS level_4
  FROM order_stat
  JOIN calendar ON calendar.date = order_stat.date
  JOIN weather ON weather.date = order_stat.date AND weather.time_slot = order_stat.time_slot
  JOIN traffic
  ON traffic.district_hash = order_stat.district_hash
  AND traffic.date = order_stat.date
  AND traffic.time_slot = order_stat.time_slot
);

