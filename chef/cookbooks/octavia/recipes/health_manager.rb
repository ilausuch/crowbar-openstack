# Copyright 2019 SUSE Linux, GmbH.
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
Chef::Log.info "YYYY *************************************** HEALTH MANAGER *******************************"

#package "openstack-octavia-health-manager"

template "/etc/octavia/octavia-health-manager.conf" do
  source "octavia-health-manager.conf.erb"
  owner node[:octavia][:user]
  group node[:octavia][:group]
  mode 00640
  variables(
    octavia_db_connection: OctaviaHelper.db_connection(fetch_database_settings, node),
    octavia_bind_host: "0.0.0.0", #TODO: Change if change in api
    octavia_healthmanager_bind_host: "0.0.0.0", #TODO: It is good
    octavia_healthmanager_hosts: ["0.0.0.0"] #TODO: add all hosts
  )
end

file node[:octavia][:octavia_log_dir] + "/octavia-health-manager.log" do
  action :touch
  owner node[:octavia][:user]
  group node[:octavia][:group]
  mode 00640
end


octavia_service "health-manager"