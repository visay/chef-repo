name "chef-server"
description "Role for the chef-server"

run_list(
  "recipe[apache2]",
  "recipe[chef-server]"
)

default_attributes(
  "chef_client" => {
    "root_user" => "chef"
  },
  "chef_server" => {
    "url"                    => "https://chef.web-essentials.asia",
    "webui_enabled"          => true,
    "solr_heap_size"         => "512M",
    "validation_client_name" => "validator",
    "expander_nodes"         => 2
  }
)
