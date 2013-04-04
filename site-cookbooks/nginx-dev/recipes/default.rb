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

%w{make libpcre++-dev}.each do |pkg|
  package pkg do
    action :install
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
            (cd nginx-#{node[:nginx][:version]}/ && ./configure && make && make install)
          EOH
  action :nothing
end
