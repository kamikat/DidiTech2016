-- generate training data over gap
SELECT
  prediction.district                     AS district,
  prediction.date                         AS date,
  features.is_holiday                   AS is_holiday,
  features.weather                      AS weather,
  features.temperature                  AS temperature,
  features.pm25                         AS pm25,
  features.level_1                      AS level_1,
  features.level_2                      AS level_2,
  features.level_3                      AS level_3,
  features.level_4                      AS level_4,
  previous.time_slot                    AS time_slot_0,
  previous.demand - previous.answer     AS gap_0,
  prediction.time_slot                  AS time_slot_1,
  prediction.demand - prediction.answer AS gap_1
FROM order_stat AS prediction
  JOIN features ON features.district = prediction.district AND features.date = prediction.date AND
                   features.time_slot = prediction.time_slot - 1
  JOIN order_stat AS previous ON previous.district = prediction.district AND previous.date = prediction.date AND
                                 previous.time_slot = prediction.time_slot - 1;