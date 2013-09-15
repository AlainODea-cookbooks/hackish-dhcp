#
# Cookbook Name:: hackish-dhcp
# Recipe:: default
#
# Copyright 2013, Alain O'Dea
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
template "/opt/local/etc/dhcp/dhcpd.conf" do
  source "dhcpd.conf.erb"
  user "root"
  group "root"
  mode 0644
end

manifest = "/opt/local/share/smf/isc-dhcpd/manifest.xml"

template manifest do
  source "manifest.xml.erb"
  user "root"
  group "root"
  mode 0644
  notifies :run, "execute[dhcpd_manifest]"
end

execute "dhcpd_manifest" do
  command "svccfg import #{manifest}"
  action :nothing
  notifies :restart, "service[dhcpd]"
end

service "dhcpd" do
  service_name "dhcpd"
  supports :restart => true, :reload => false, :status => true
  action [:enable, :start]
end
