do $$
declare
    file_found BOOLEAN;
begin
    SELECT exists (select size from pg_stat_file('/share/dbs/GeoLite2-City/GeoLite2-City-Blocks-IPv4.csv', true) ) INTO file_found;
    if file_found then
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

        create index on geoip2_network using gist (network inet_ops);

        create table geoip2_location (
          geoname_id int not null,
          locale_code text not null,
          continent_code text not null,
          continent_name text not null,
          country_iso_code text,
          country_name text,
          subdivision_1_iso_code text,
          subdivision_1_name text,
          subdivision_2_iso_code text,
          subdivision_2_name text,
          city_name text,
          metro_code int,
          time_zone text,
          is_in_european_union bool not null,
          primary key (geoname_id, locale_code)
        );

        copy geoip2_network(
          network, geoname_id, registered_country_geoname_id, represented_country_geoname_id,
          is_anonymous_proxy, is_satellite_provider, postal_code, latitude, longitude, accuracy_radius
        ) from '/share/dbs/GeoLite2-City/GeoLite2-City-Blocks-IPv4.csv' with (format csv, header);

        copy geoip2_network(
          network, geoname_id, registered_country_geoname_id, represented_country_geoname_id,
          is_anonymous_proxy, is_satellite_provider, postal_code, latitude, longitude, accuracy_radius
        ) from '/share/dbs/GeoLite2-City/GeoLite2-City-Blocks-IPv6.csv' with (format csv, header);

        copy geoip2_location(
          geoname_id, locale_code, continent_code, continent_name, country_iso_code, country_name,
          subdivision_1_iso_code, subdivision_1_name, subdivision_2_iso_code, subdivision_2_name,
          city_name, metro_code, time_zone, is_in_european_union
        ) from '/share/dbs/GeoLite2-City/GeoLite2-City-Locations-en.csv' with (format csv, header);

    end if;
end $$
