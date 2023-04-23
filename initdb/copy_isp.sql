copy geoip2_isp(
  isp_id, isp, organization, autonomous_system_number, autonomous_system_organization,
  connection_type, user_type, mobile_country_code, mobile_network_code
) from :'file' with (format csv, header);
