name "base"
description "base role applied to all nodes."

run_list(
  "recipe[apt]",
  "recipe[ntp]",
  "recipe[iptables]",
  "recipe[base]",
  "recipe[base::firewall]",
  "recipe[zsh]",
  "recipe[oh-my-zsh]"
)

override_attributes(
  "ntp" => {
    "servers" => [
      "ch.pool.ntp.org",
      "pool.ntp.org",
      "ntp.ubuntu.com"
    ]
  },
  "ohmyzsh" => {
    "theme" => "fletcherm"
  }
)
