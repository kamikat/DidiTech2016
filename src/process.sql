-- aggregate demand answer table on each time slot
CREATE INDEX order_start_district_hash_date_time_slot_index ON `order` (start_district_hash, date, time_slot);

DROP TABLE IF EXISTS order_stat;

CREATE TABLE IF NOT EXISTS order_stat (
  SELECT
    start_district_hash        AS district,
    date                       AS date,
    time_slot                  AS time_slot,
    COUNT(start_district_hash) AS demand,
    COUNT(driver_id)           AS answer
  FROM `order`
  GROUP BY start_district_hash, date, time_slot
  ORDER BY date ASC, time_slot ASC
);

CREATE INDEX order_stat_district_date_time_slot_index ON order_stat (district, date, time_slot)

CREATE TABLE IF NOT EXISTS clock (
  SELECT DISTINCT time_slot
  FROM order_stat
);

-- create feature set
DROP TABLE IF EXISTS features;

SELECT *
FROM district
  CROSS JOIN calendar
  CROSS JOIN clock
ORDER BY district_hash, date, time_slot;

CREATE TABLE features (
  SELECT
    calendar.date                        AS date,
    district.district_hash               AS district,
    clock.time_slot                      AS time_slot,
    COALESCE(calendar.is_holiday, FALSE) AS is_holiday,
    COALESCE(weather.weather, 0)         AS weather,
    COALESCE(weather.temperature, 0)     AS temperature,
    COALESCE(weather.pm25, 0)            AS pm25,
    COALESCE(traffic.level_1, 0)         AS level_1,
    COALESCE(traffic.level_2, 0)         AS level_2,
    COALESCE(traffic.level_3, 0)         AS level_3,
    COALESCE(traffic.level_4, 0)         AS level_4
  FROM district
    CROSS JOIN clock
    CROSS JOIN calendar
    LEFT JOIN weather ON weather.date = calendar.date AND weather.time_slot = clock.time_slot
    LEFT JOIN traffic
      ON traffic.district_hash = district.district_hash
         AND traffic.date = calendar.date
         AND traffic.time_slot = clock.time_slot
);

CREATE INDEX features_date_time_slot_district_index ON didi.features (date, time_slot, district);
