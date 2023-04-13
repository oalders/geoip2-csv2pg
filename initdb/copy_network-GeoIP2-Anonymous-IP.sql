copy anonymous_network(
  network,
  is_anonymous,
  is_anonymous_vpn,
  is_hosting_provider,
  is_public_proxy,
  is_tor_exit_node,
  is_residential_proxy
) from :'file' with (format csv, header);
