name "metrics-server"
description "Roles for a Metrics server"

run_list(
  "recipe[mysql::server]",
  "recipe[sonar]",
  "recipe[sonar::database_mysql]",
  "recipe[apache2]",
  "recipe[sonar::proxy_apache]"
)

override_attributes(
  'sonar' => {
    'web_domain' => 'metrics.web-essentials.asia',
    'dir' => '/usr/share',
    'version' => '2.13.1',
    'os_kernel' => 'linux-x86-64',
    'jdbc_username' => "sonar",
    'jdbc_password' => "sonar",
    'jdbc_url' => "jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8",
    'jdbc_driverClassName' => "com.mysql.jdbc.Driver",
    'jdbc_validationQuery' => "select 1"
  },
  'mysql' => {
    'bind_address' => 'localhost'
  }
)
