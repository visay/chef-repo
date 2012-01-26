Knife Configuration Sample
===========================

Replace ``CHANGME`` by a username and save the file under :file:`chef-repository/.chef/knife.rb`

::

	current_dir = File.dirname(__FILE__)
    log_level                :info
    log_location             STDOUT
    node_name                'CHANGEME'
    client_key               "#{current_dir}/CHANGEME.pem"
    validation_client_name   'chef-validator'
    validation_key           "#{current_dir}validation.pem"
    chef_server_url          'https://chef'
    cache_type               'BasicFile'
    cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
    cookbook_path            ["#{current_dir}/../cookbooks"]
