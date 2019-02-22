#
# Copyright 2019, SUSE LINUX GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if CrowbarRoleRecipe.node_state_valid_for_role?(node, "octavia", "octavia-api")
  include_recipe "#{@cookbook_name}::common"
  include_recipe "#{@cookbook_name}::certs"
  include_recipe "#{@cookbook_name}::database"
  include_recipe "#{@cookbook_name}::keystone"
  include_recipe "#{@cookbook_name}::nova"
  include_recipe "#{@cookbook_name}::api"
end
