name "ci-server"

description "Roles for a Continuous Integration server"

# List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
run_list "role[base]",
         "role[typo3-server]",
         "recipe[jenkins]",
         "recipe[jenkins::proxy_apache2]",
         "recipe[ant]",
         "recipe[testing::unit]",
         "recipe[testing::functional]"

# Attributes applied no matter what the node has set already.
override_attributes "jenkins" => {
    "server" => {
        "url" => "http://ci.web-essentials.asia", #overwrite computed default value based on fqdn
        "host" => "ci.web-essentials.asia",
        "port" => "8080"
    },
    "http_proxy" => {
        "variant" => "apache2",
        "host_name" => "ci.web-essentials.asia",
        #"host_aliases" => ['ci']
    }
}
