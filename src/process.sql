-- aggregate demand answer table on each time slot
CREATE TABLE IF NOT EXISTS order_stat (
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

DROP TABLE IF EXISTS poi_csv;

CREATE TABLE poi_csv (
  SELECT
    district_hash,
    GROUP_CONCAT(count ORDER BY type SEPARATOR ",") AS poi_feature
  FROM poi_feature
  GROUP BY district_hash);

CREATE INDEX poi_feature_district_hash_index ON poi_feature (district_hash, type);
CREATE INDEX poi_csv_district_hash_index ON poi_csv (district_hash);

-- create intermediate training set (without poi data)
DROP TABLE IF EXISTS intermediate;

CREATE TABLE intermediate (
  SELECT
    order_stat.district_hash              AS district,
    order_stat.date                       AS date,
    calendar.is_holiday                   AS is_holiday,
    order_stat.time_slot                  AS time_slot,
    COALESCE(weather.weather, 0)          AS weather,
    COALESCE(weather.temperature, 0)      AS temperature,
    COALESCE(weather.pm25, 0)             AS pm25,
    COALESCE(traffic.level_1, 0)          AS level_1,
    COALESCE(traffic.level_2, 0)          AS level_2,
    COALESCE(traffic.level_3, 0)          AS level_3,
    COALESCE(traffic.level_4, 0)          AS level_4,
    order_stat.demand                     AS demand,
    order_stat.answer                     AS answer,
    order_stat.demand - order_stat.answer AS gap
  FROM order_stat
    LEFT JOIN calendar ON calendar.date = order_stat.date
    LEFT JOIN weather ON weather.date = order_stat.date AND weather.time_slot = order_stat.time_slot
    LEFT JOIN traffic
      ON traffic.district_hash = order_stat.district_hash
         AND traffic.date = order_stat.date
         AND traffic.time_slot = order_stat.time_slot
);