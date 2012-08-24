name "base"
description "IMPORTANT: Never apply this base role directly to a node. Use the OS specific roles like 'ubuntu'. The run_list of this role is applied to ALL nodes and creates a base for further recipes."

run_list(
  "recipe[zip]",
  "recipe[wget]",
  "recipe[curl]",
  "recipe[subversion]",
  "recipe[ntp]"
)

default_attributes(
  "chef_client" => {
    "server_url" => "https://chef-api.web-essentials.asia"
  },
  "chef_handler" => {
    "handler_path" => "/var/chef/handlers"
  }
)

override_attributes(
  "ntp" => {
    "servers" => [
      "ch.pool.ntp.org",
      "pool.ntp.org",
      "ntp.ubuntu.com"
    ]
  }
)
