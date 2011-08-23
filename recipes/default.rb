#!/usr/bin/ruby

node[:applications].each do |app_name,data|
  user = node[:users].first

  case node[:instance_role]
   when "solo", "app", "app_master"
     template "/data/#{app_name}/shared/config/database_cluster.yml" do
       source "database.yml.erb"
       owner user[:username]
       group user[:username]
       mode 0744
       variables({
           :app_name => app_name
       })
     end
  end
end