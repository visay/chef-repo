name "ci"

    description "Roles for a Continuous Integration server"
    
	# @doc http://wiki.opscode.com/display/chef/Roles
	
    # List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
    ## run_list "recipe[apache2]", "recipe[apache2::mod_ssl]", "role[monitor]"

	## env_run_lists "prod" => ["recipe[apache2]"], "staging" => ["recipe[apache2::staging]"]
	
    # Attributes applied if the node doesn't have it set already.
    # default_attributes "apache2" => { "listen_ports" => [ "80", "443" ] }

    # Attributes applied no matter what the node has set already.
    # override_attributes "apache2" => { "max_children" => "50" }
