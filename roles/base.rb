name "base"
description "base role applied to all nodes."

#, git, svn, curl, wget, openssh
run_list "recipe[apt]",
         "recipe[ntp]",
         "recipe[iptables]",
         "recipe[base]",
         "recipe[base::firewall]",
         "recipe[zsh]",
         "recipe[oh-my-zsh]"

# Attributes applied if the node doesn't have it set already.
default_attributes

# -> should be rather override_attributes
# Attributes applied no matter what the node has set already.
override_attributes "ntp" => {
    "servers" => ["ch.pool.ntp.org", "pool.ntp.org", "ntp.ubuntu.com"]
}, "ohmyzsh" => {
    "theme" => "fletcherm"
}


