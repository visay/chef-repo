name "base"
description "base role applied to all nodes."

run_list(
  "recipe[zip]",
  "recipe[wget]",
  "recipe[curl]",
  "recipe[subversion]",
  "recipe[ntp]"
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
