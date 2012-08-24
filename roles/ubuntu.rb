name "ubuntu"
description "Role applied to all Ubuntu systems."

run_list(
  "recipe[apt]",
  "role[base]"
)

override_attributes(
  "chef_client" => {
    "init_style" => "runit"
  }
)
