create table geoip2_network (
  network cidr not null,
  geoname_id int,
  registered_country_geoname_id int,
  represented_country_geoname_id int,
  is_anonymous_proxy bool,
  is_satellite_provider bool,
  postal_code text,
  latitude numeric,
  longitude numeric,
  accuracy_radius int
);

copy geoip2_network(
  network, geoname_id, registered_country_geoname_id, represented_country_geoname_id,
  is_anonymous_proxy, is_satellite_provider, postal_code, latitude, longitude, accuracy_radius
) from '/share/dbs/GeoLite2-City-Blocks-IPv4.csv' with (format csv, header);

copy geoip2_network(
  network, geoname_id, registered_country_geoname_id, represented_country_geoname_id,
  is_anonymous_proxy, is_satellite_provider, postal_code, latitude, longitude, accuracy_radius
) from '/share/dbs/GeoLite2-City-Blocks-IPv6.csv' with (format csv, header);
