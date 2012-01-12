name "base"
    description "base role applied to all nodes."
    
    #, git, svn, curl, wget, openssh
    run_list "recipe[apt]", "recipe[ntp]", "recipe[base]"
    
    # Attributes applied if the node doesn't have it set already.
    default_attributes "ntp" => {
        "servers" => ["ch.pool.ntp.org", "pool.ntp.org", "ntp.ubuntu.com"]
    }
    
    # Attributes applied no matter what the node has set already.
    #override_attributes()
