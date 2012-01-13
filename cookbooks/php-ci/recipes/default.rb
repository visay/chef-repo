#
# Cookbook Name:: php-ci
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "php"

# UPGRADE PEAR
php_pear "PEAR" do
  action :upgrade
end

# REGISTER NEW PEAR CHANNELS
['pear.phpqatools.org', 'pear.symfony-project.com', 'pear.phpunit.de', 'pear.phpmd.org', 'pear.pdepend.org'].each do |channel|
  php_pear_channel channel do
    action [:discover, :update]
  end
end

# NEW PACKAGE
php_pear "phpqatools" do
  channel "pear.phpqatools.org"
  action :install
end

php_pear "PHP_CodeSniffer" do
  channel "pear.php.net"
  options "--alldeps"
  action :install
end

php_pear "PHPUnit" do
  channel "pear.phpunit.de"
  options "--alldeps"
  action :install
end

php_pear "PHP_PMD" do
  channel "pear.phpmd.org"
  options "--alldeps"
  action :install
end
