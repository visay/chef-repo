#
# Cookbook Name:: typo3
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "php"

# INSTALL NEW PHP MODULE FROM PACKAGE
package "php5-mysql" do
  action :install
end

package "php5-sqlite" do
  action :install
end
