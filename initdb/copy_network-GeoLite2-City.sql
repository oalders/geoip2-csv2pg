copy geoip2_network(
  network, geoname_id, registered_country_geoname_id, represented_country_geoname_id,
  is_anonymous_proxy, is_satellite_provider, postal_code, latitude, longitude, accuracy_radius
) from :'file' with (format csv, header);
