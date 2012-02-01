#
# Cookbook Name:: typo3
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
['pear.symfony-project.com', 'pear.phpunit.de', 'components.ez.no', 'pear.behat.org'].each do |channel|
  php_pear_channel channel do
    #action [:discover, :update]
    action :discover
  end
end

# INSTALL PACKAGE
php_pear "behat-beta" do
  channel "pear.behat.org"
  options "--alldeps"
  action :install
end

php_pear "mink" do
  channel "pear.behat.org"
  options "--alldeps"
  action :install
end

php_pear "PHPUnit" do
  channel "pear.phpunit.de"
  options "--alldeps"
  action :install
end

# pear install --alldeps behat/behat-beta
# pear install --alldeps behat/mink
# pear install --alldeps phpunit/PHPUnit
#pear install --alldeps --force phpunit/phpunit
