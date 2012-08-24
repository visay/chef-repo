name "base"
description "base role applied to all nodes."

run_list(
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
