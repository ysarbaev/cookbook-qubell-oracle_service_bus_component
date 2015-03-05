template "#{node[:osb][:oracle_home]}/common/bin/config.expect" do
  source "config.expect.erb"
  owner "oracle"
  group "root"
  variables(node[:osb])
  mode 00755
end

execute "config" do
  command "./config.expect #{node[:osb][:password]} > config.log"
  cwd "#{node[:osb][:oracle_home]}/common/bin"
  action :run
  user "root"
end