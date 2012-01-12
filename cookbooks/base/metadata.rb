maintainer       "Web Essentials"
maintainer_email "fabien@web-essentials.asia"
license          "All rights reserved"
description      "Installs/Configures base"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"


%w{ debian ubuntu }.each do |os|
  supports os
end
