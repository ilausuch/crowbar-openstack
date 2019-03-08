# Copyright 2019 SUSE Linux GmbH.
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

list = search(:node, "roles:octavia-health-manager") || []

hm_port = node[:octavia]["health-manager"][:port]
node_list = []
list.each do |e|
  str = e.name + ":" + hm_port.to_s
  node_list << str unless node_list.include?(str)
end

template "/etc/octavia/octavia-health-manager.conf" do
  source "octavia-health-manager.conf.erb"
  owner node[:octavia][:user]
  group node[:octavia][:group]
  mode 0o640
  variables(
    octavia_db_connection: fetch_database_connection_string(node[:octavia][:db]),
    octavia_healthmanager_hosts: node_list.join(",")
  )
end

file node[:octavia][:octavia_log_dir] + "/octavia-health-manager.log" do
  action :touch
  owner node[:octavia][:user]
  group node[:octavia][:group]
  mode 0o640
end

octavia_service "health-manager"
