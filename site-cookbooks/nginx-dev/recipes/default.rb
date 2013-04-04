#
# Cookbook Name:: nginx-dev
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
end

%w{make git-core build-essential zlib1g-dev libpcre3 libpcre3-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

if node[:nginx][:with_pagespeed]
  git "/tmp/ngx_pagespeed" do
    repository "git://github.com/pagespeed/ngx_pagespeed.git"
    reference "master"
    action :sync
  end
end

remote_file "/tmp/nginx-#{node[:nginx][:version]}.tar.gz" do
  source "http://nginx.org/download/nginx-#{node[:nginx][:version]}.tar.gz"
  notifies :run, "bash[install_nginx]", :immediately
end

bash "install_nginx" do
  user "root"
  cwd "/tmp"
  code <<-EOH
            tar -zxf nginx-#{node[:nginx][:version]}.tar.gz
            (cd nginx-#{node[:nginx][:version]}/ && ./configure #{(node[:nginx][:with_pagespeed]) ? "--add-module=/tmp/ngx_pagespeed" : ""} && make && make install)
          EOH
  action :nothing
end

group "nginx" do
  action :create
end

user "nginx" do
  gid "nginx"
  system true
  shell "/bin/false"
  action :create
end

directory "/var/ngx_pagespeed_cache" do
  mode "0755"
  owner "nginx"
  group "nginx"
  action :create
end

cookbook_file "/etc/init.d/nginx" do
  source "nginx_initscript.sh"
  mode "0755"
end

template "/usr/local/nginx/conf/nginx.conf" do
  source "nginx.conf.erb"
end

service "nginx" do
  supports :restart => true, :reload => true, :status => true
  action [:enable, :start]
end
