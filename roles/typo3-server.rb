name "typo3-server"

description "Roles for a Web Server"

# @doc http://wiki.opscode.com/display/chef/Roles

# List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
run_list "recipe[apache2]",
         "recipe[mysql::server]",
         "recipe[php]",
         "recipe[typo3]"

#env_run_lists "prod" => ["recipe[apache2]"], "staging" => ["recipe[apache2::staging]"]
override_attributes 'mysql' => {
    'bind_address' => 'localhost'
}
