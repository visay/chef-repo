#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

packages = [
  'wget',
  'curl',
  'subversion',
  'git-core',
]

case node[:platform]
  when "debian", "ubuntu"
    packages.each do |pkg|
      package pkg do
        action[:install]
    end
  end
end
