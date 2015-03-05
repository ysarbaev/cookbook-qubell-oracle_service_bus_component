
execute 'startWebLogic' do
  command "./startWebLogic.sh &"
  action :run
  user "root"
end

cookbook_file "#{node[:osb][:domain_home]}/bin/startManagedWebLogic.expect" do
  source "startManagedWebLogic.expect"
  owner "oracle"
  group "root"
  mode 00755
end

execute 'startManagedWebLogic' do
  command "./startManagedWebLogic.expect #{node[:osb][:server_name]} #{node[:osb][:username]} #{node[:osb][:password]} &"
  cwd "#{node[:osb][:domain_home]}/bin"
  action :run
  user "root"
end