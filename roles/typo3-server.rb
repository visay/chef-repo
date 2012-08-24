name "typo3-server"
description "Roles for a Web Server"
# @doc http://wiki.opscode.com/display/chef/Roles

run_list(
  "recipe[apache2]",
  "recipe[mysql::server]",
  "recipe[php]",
  "recipe[typo3]"
)

override_attributes(
  'mysql' => {
    'bind_address' => 'localhost'
  }
)
