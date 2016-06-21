SELECT
CONCAT("\"", district_hash, "\",\"", date, "\",", time_slot, ",", is_holiday, ",", weather, ",", temperature, ",", pm25, ",", level_1, ",", level_2, ",", level_3, ",", level_4, poi.poi_feature, gap)
FROM intermediate
JOIN (
  SELECT
  district_hash,
  GROUP_CONCAT(count ORDER BY type SEPARATOR ",") AS poi_feature
  FROM poi_feature
  GROUP BY district_hash
) poi ON poi.district_hash = intermediate.district;
