copy geoip2_location(
  geoname_id, locale_code, continent_code, continent_name, country_iso_code, country_name,
  subdivision_1_iso_code, subdivision_1_name, subdivision_2_iso_code, subdivision_2_name,
  city_name, metro_code, time_zone, is_in_european_union
) from :'file' with (format csv, header);

