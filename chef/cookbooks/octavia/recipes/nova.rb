require "chef/mixin/shell_out"

Chef::Log.info "YYYY *************************************** Nova *******************************"
octavia_keystone_settings = KeystoneHelper.keystone_settings(node, "octavia")


Chef::Log.info "YYYY #{octavia_keystone_settings.inspect}"

package "openstack-octavia-amphora-image-x86_64"

template "/tmp/create_security_group.sh" do
  source "create_security_group.sh.erb"
  owner "root"
  group "root"
  mode 00700
  variables(
    net_name: node[:octavia][:amphora][:manage_net],
    sec_group: node[:octavia][:amphora][:sec_group]
  )
end

template "/tmp/create_image.sh" do
  source "create_image.sh.erb"
  owner "root"
  group "root"
  mode 00700
  variables(
    flavor: node[:octavia][:amphora][:flavor],
    project_name: octavia_keystone_settings["service_tenant"],
    image_tag: node[:octavia][:amphora][:image_tag]
  )
end

bash "Create a octavia security_group" do
  code "/tmp/create_security_group.sh"
  environment({
                "OS_USERNAME" => octavia_keystone_settings["admin_user"],
                "OS_PASSWORD" => octavia_keystone_settings["admin_password"],
                "NOVACLIENT_INSECURE" => "true",
                "OS_AUTH_URL" => octavia_keystone_settings["internal_auth_url"],
                "OS_IDENTITY_API_VERSION" => octavia_keystone_settings["api_version"],
                "OS_USER_DOMAIN_NAME" => "Default",
                "OS_PROJECT_DOMAIN_NAME" => "Default",
                "OS_PROJECT_NAME" => octavia_keystone_settings["service_tenant"]
              })
end

bash "Create a octavia image" do
  code "/tmp/create_image.sh"
  environment ({
    "OS_USERNAME" => octavia_keystone_settings["service_user"],
    "OS_PASSWORD" => octavia_keystone_settings["service_password"],
     #"OS_TENANT_NAME" => tempest_comp_tenant,
    "NOVACLIENT_INSECURE" => "true",
    "OS_AUTH_URL" => octavia_keystone_settings["internal_auth_url"],
    "OS_IDENTITY_API_VERSION" => octavia_keystone_settings["api_version"],
    "OS_USER_DOMAIN_NAME" => octavia_keystone_settings["api_version"] != "2.0" ? "Default" : "",
    "OS_PROJECT_DOMAIN_NAME" => octavia_keystone_settings["api_version"] != "2.0" ? "Default" : "",
    "OS_PROJECT_NAME" => octavia_keystone_settings["service_tenant"]
  })
end
