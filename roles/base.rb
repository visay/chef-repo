name "base"
  description "base role applied to all nodes."
  
  #, git, svn, curl, wget, openssh
  run_list "recipe[apt::default]", "recipe[ntp::default]", "recipe[iptables::default]", "recipe[base::default]", "recipe[base::firewall]"
  
  # Attributes applied if the node doesn't have it set already.
  
  # Attributes applied no matter what the node has set already.
  # -> should be rather override_attributes
  default_attributes "ntp" => {
    "servers" => ["ch.pool.ntp.org", "pool.ntp.org", "ntp.ubuntu.com"]
  }
  