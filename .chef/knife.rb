current_dir = File.dirname(__FILE__)

log_level                :info
log_location             STDOUT

client_key               "#{current_dir}/../certificates/client.pem"
validation_key           "#{current_dir}/../certificates/validation.pem"
chef_server_url          "https://chef.web-essentials.asia"
chef_server_url          "http://chef.web-essentials.asia:4040"

cache_type               'BasicFile'
cache_options(
  :path => "#{ENV['HOME']}/.chef/checksums"
)

cookbook_path [
  "#{current_dir}/../cookbooks",
  "#{current_dir}/../site-cookbooks"
]

cookbook_copyright       "Web Essentials"
cookbook_license         "mit"



# Include per-user settings

# Put at least these lines into .chef/knife.local.rb:
#   node_name           "<your_username>"
#   cookbook_email      "<your_email>"
#   knife[:ssh_user] = "<your_ssh_username_on_clients>"
#
# The username must be unique on the chef server!
# Please check upfront if the node_name is unique.

eval(File.read(File.expand_path("#{current_dir}/knife.local.rb")))
