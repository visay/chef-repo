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

# INSTALL NEW PHP MODULE FROM PACKAGE
#package "php5-mysql" do
#  action :install
#end

#package "php5-sqlite" do
#  action :install
#end

package "php5-mysql"
package "php5-curl"
package "php5-gd"
#package "php5-mbstring"
package "php5-xsl"
package "php5-sqlite"
#package "php5-openssl"
#package "php5-soap"
package "php5-ldap"
#package "php5-posix"
#package "php5-iconv"
#package "php5-sockets"

