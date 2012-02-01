name "metrics-server"

description "Roles for a Metrics server"

# List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
run_list "recipe[sonar]",
         "recipe[sonar::database_mysql]"

# Attributes applied no matter what the node has set already.
override_attributes 'sonar' => {
    'web_domain' => 'metrics.web-essentials.asia',
    'dir' => '/usr/share',
    'version' => '2.13.1',
    'jdbc_url' => "jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8",
    'driverClassName' => "com.mysql.jdbc.Driver",
    'validationQuery' => "select 1"
}
