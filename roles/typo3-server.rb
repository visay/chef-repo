name "typo3-server"
description "Roles for a Web Server"
# @doc http://wiki.opscode.com/display/chef/Roles

run_list(
  "recipe[apache2]",
  "recipe[mysql::server]",
  "recipe[php]",
  "recipe[php::module_mysql]",
  "recipe[php::module_curl]",
  "recipe[php::module_gd]",
  "recipe[php::module_xsl]",
  "recipe[php::module_sqlite3]",
  "recipe[php::module_ldap]"
)

override_attributes(
  'mysql' => {
    'bind_address' => 'localhost'
  }
)
