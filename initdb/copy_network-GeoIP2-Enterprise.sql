copy geoip2_network(
  network,
  geoname_id,
  registered_country_geoname_id,
  represented_country_geoname_id,
  is_anonymous_proxy,
  is_satellite_provider,
  postal_code,
  latitude,
  longitude,
  isp_id,
  is_legitimate_proxy,
  domain,
  accuracy_radius,
  country_confidence,
  subdivision_confidence,
  city_confidence,
  postal_confidence
) from :'file' with (format csv, header);
