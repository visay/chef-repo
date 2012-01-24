name "ci"

  description "Roles for a Continuous Integration server"
  
  # List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
  run_list "recipe[jenkins]", "recipe[jenkins::proxy_apache2]"

  # Attributes applied no matter what the node has set already.
  override_attributes "jenkins" => {
    "server" => {
    	"url" => "http://ci.local", #overwrite computed default value based on fqdn
    	"host" => "ci",
    	"port" => "8080"
    },
    "http_proxy" =>  {
      "variant" => "apache2",
      "host_name" => "ci.local",
      "host_aliases" => ['ci']
    } 
  }