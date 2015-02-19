
swap_file "#{node[:osb][:swap_dir]}/1GB.swap" do
  size '1gb'
  action :enable
end

package 'unzip' do
  action :install
end

yum_package 'glibc' do
  action :install
  arch 'i686'
end

user 'oracle' do
  supports :manage_home => true
  comment 'Oracle user'
  uid 1234
  gid 'users'
  home '/home/oracle'
  shell '/bin/bash'
end

group "root" do
  action :modify
  members "oracle"
  append true
end

directory "#{node[:osb][:tmp_dir]}" do
  owner "oracle"
  group "root"
  mode 00755
  recursive true
  not_if { File.exists?("#{node[:osb][:tmp_dir]}") }
end

directory "#{node[:osb][:inventory_dir]}" do 
  owner "oracle"
  group "root"
  mode 00755
end

directory "#{node[:osb][:oracle_home]}" do
  owner "oracle"
  group "root"
  mode 00755
end

directory "#{node[:osb][:middleware_home]}/oracle_common" do
  owner "oracle"
  group "root"
  mode 00755
end

file "#{node[:osb][:log_file]}" do
  action [:delete, :create]
  owner "oracle"
  group "root"
  mode 0755
end

remote_file "#{node[:osb][:tmp_dir]}/oracle-service-bus.zip" do
  action :create_if_missing
  owner "oracle"
  group "root"
  mode 00755
  source "#{node[:osb][:url]}"
end

execute "unzip oracle-service-bus" do
  command "unzip -o #{node[:osb][:tmp_dir]}/oracle-service-bus.zip >> #{node[:osb][:log_file]}"
  cwd "#{node[:osb][:tmp_dir]}"
  not_if { File.exists?("#{node[:osb][:tmp_dir]}/Disk1") }
  action :run
end

template "#{node[:osb][:tmp_dir]}/custom_installtype.rsp" do
  source "custom_installtype.rsp.erb"
  owner "oracle"
  group "root"
  variables(node[:osb])
  mode 00755
end

template "#{node[:osb][:tmp_dir]}/oraInst.loc" do
  source "oraInst.loc.erb"
  owner "oracle"
  group "root"
  variables(node[:osb])
  mode 00755
end

execute "runInstaller" do
  environment 'TEMP' => "#{node[:osb][:tmp_dir]}"
  command "./runInstaller -jreLoc #{node[:osb][:jre_loc]}" +
          " -silent -ResponseFile #{node[:osb][:tmp_dir]}/custom_installtype.rsp" +
          " -invPtrLoc #{node[:osb][:tmp_dir]}/oraInst.loc"
  cwd "#{node[:osb][:tmp_dir]}/Disk1"
  action :run
  user "oracle"
end