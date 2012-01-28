#
# Cookbook Name:: unit-test
# Recipe:: default
#
# Copyright 2012, Fabien Udriot <fabien@omic.ch>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "php"

# UPGRADE PEAR
php_pear "PEAR" do
  action :upgrade
end

# REGISTER NEW PEAR CHANNELS
['pear.phpqatools.org', 'pear.symfony-project.com', 'pear.phpunit.de', 'pear.phpmd.org', 'pear.pdepend.org', 'components.ez.no'].each do |channel|
  php_pear_channel channel do
    #action [:discover, :update]
    action :discover
  end
end

# INSTALL PACKAGE
php_pear "phpqatools" do
  channel "pear.phpqatools.org"
  options "--alldeps"
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

# INSTALL JENKINS PLUGIN

require_recipe "jenkins"

jenkins_cli "install-plugin checkstyle"
jenkins_cli "install-plugin cloverphp"
jenkins_cli "install-plugin dry"
jenkins_cli "install-plugin htmlpublisher"
jenkins_cli "install-plugin jdepend"
jenkins_cli "install-plugin plot"
jenkins_cli "install-plugin pmd"
jenkins_cli "install-plugin violations"
jenkins_cli "install-plugin xunit"


# INSTALL PHP TEMPLATE
directory "#{node[:jenkins][:server][:home]}/jobs/php-template" do
  recursive true
  owner node[:jenkins][:server][:user]
  group node[:jenkins][:server][:group]
end

template "#{node[:jenkins][:server][:home]}/jobs/php-template/config.xml" do
  source "php-template/config.xml"
  owner node[:jenkins][:server][:user]
  group node[:jenkins][:server][:group]
  not_if { File.exists?("#{node[:jenkins][:server][:home]}/jobs/php-template/config.xml") }
end

jenkins_cli "safe-restart"
#jenkins_cli "reload-configuration"
