
default[:osb][:middleware_home] = "/opt/middleware"
default[:osb][:tmp_dir] = "/tmp/oracle"
default[:osb][:swap_dir] = "/mnt"
default[:osb][:url] = "https://s3.amazonaws.com/ab-atg/ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip"
default[:osb][:jre_loc] = "#{node[:osb][:middleware_home]}/jrockit"
default[:osb][:oracle_home] = "#{node[:osb][:middleware_home]}/service_bus"
default[:osb][:weblogic_home] = "#{node[:osb][:middleware_home]}/weblogic"
default[:osb][:inventory_dir] = "#{node[:osb][:middleware_home]}/service_bus_inventory"
default[:osb][:instalation_group] = "service_bus"

default[:osb][:log_file] = "/var/log/osb_install.log"