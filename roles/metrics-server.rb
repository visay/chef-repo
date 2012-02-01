name "ci-server"

description "Roles for a Metrics server"

# List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
run_list "recipe[sonar]"

# Attributes applied no matter what the node has set already.
override_attributes "sonar" => {
    "web_domain" => 'metrics.web-essentials.asia
}
