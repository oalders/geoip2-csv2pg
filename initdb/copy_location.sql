BEGIN;
CREATE TEMP TABLE tmp_table
(LIKE geoip2_location INCLUDING DEFAULTS)
ON COMMIT DROP;

copy tmp_table(
  geoname_id, locale_code, continent_code, continent_name, country_iso_code, country_name,
  subdivision_1_iso_code, subdivision_1_name, subdivision_2_iso_code, subdivision_2_name,
  city_name, metro_code, time_zone, is_in_european_union
) from :'file' with (format csv, header);

INSERT INTO geoip2_location
SELECT *
FROM tmp_table
ON CONFLICT DO NOTHING;
COMMIT;
