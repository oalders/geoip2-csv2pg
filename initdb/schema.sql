create table anonymous_network (
  network cidr not null,
  is_anonymous bool,
  is_anonymous_vpn bool,
  is_hosting_provider bool,
  is_public_proxy bool,
  is_tor_exit_node bool,
  is_residential_proxy bool
);

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
  isp_id int,
  is_legitimate_proxy bool,
  domain text,
  accuracy_radius int,
  country_confidence int,
  subdivision_confidence int,
  city_confidence int,
  postal_confidence int,
  is_anycast bool,
  product_id text NOT NULL
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

create table geoip2_isp (
  isp_id int not null,
  isp text,
  organization text,
  autonomous_system_number int,
  autonomous_system_organization text,
  connection_type text,
  user_type text,
  mobile_country_code text,
  mobile_network_code text,
  primary key(isp_id)
);

create table connection_type_network (
  network cidr not null,
  connection_type text
);
