name "base"
    description "base role applied to all nodes."
    
    run_list "recipe[apt]"
    
    #ntp, git, svn, curl, wget, openssh
    
    # Attributes applied if the node doesn't have it set already.
    #default_attributes()
    # Attributes applied no matter what the node has set already.
    #override_attributes()
