name "ci-server"
description "Roles for a Continuous Integration server"

run_list(
  "recipe[jenkins]",
  "recipe[jenkins::proxy_apache2]",
  "recipe[ant]",
  "recipe[testing::unit]",
  "recipe[testing::functional]"
)

override_attributes(
  "jenkins" => {
    "server" => {
      "url" => "http://ci.web-essentials.asia",
      "host" => "ci.web-essentials.asia",
      "port" => "8080"
    },
    "http_proxy" => {
      "variant" => "apache2",
      "host_name" => "ci.web-essentials.asia"
    }
  }
)
