Chef
==========================

What is Chef?
--------------

Chef is a systems integration framework, built to bring the benefits of configuration management to your entire infrastructure. Originally written by Opscode, Chef is open source under the Apache license and has more than 475 individual contributors and almost 100 corporations making it great.

How Chef Works?
---------------

You write “recipes” that describe how you want a part of your server (such as Apache, MySQL, or Jenkins) to be configured. These recipes describe a series of resources that should be in a particular state - packages that should be installed, services that should be running, or files that should be written. Chef makes sure each resource is properly configured, and gives a safe, flexible, easily-repeatable mechanism for making sure your servers are always running exactly the way you want them

How to install?
----------------

Chef comes in different flavors such as server / client mode, solo mode or possibly a hosted mode. The tutorial bellow will focus on setting up a server / client infrastructure. The steps can be divided in three:

#. Install a Chef Server
#. Configure your local workstation
#. Install chef-client on your nodes

Part I - Chef Server Installation
---------------------------------------

Bellow is a straight walkthrough for Ubuntu based environment without much explanation to get things done. To get a more in depth insight of what is done, a more careful reading from the official Wiki page_ is recommended.


Add the Opscode APT Repository
+++++++++++++++++++++++++++++++

::

	# Configure Source to install Chef version 0.10
	sudo su
	echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list

Add the GPG Key and Update Index
++++++++++++++++++++++++++++++++

::

	# Create a directory for storing new key and import them
	sudo su
	mkdir -p /etc/apt/trusted.gpg.d
	gpg --fetch-key http://apt.opscode.com/packages@opscode.com.gpg.key
	gpg --export packages@opscode.com | tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null

	# Update the package definition.
	apt-get update

Installing the opscode-keyring package will keep the key up-to-date::

	sudo su
	apt-get install opscode-keyring -yu

	-> Answer Yes when asking for the maintenace version


Install the chef-server package
+++++++++++++++++++++++++++++++

Using the default packet manager of Ubuntu, install Chef Server::

	# Upgrade the distribution
	sudo apt-get upgrade -yu

	# Install Chef package
	sudo apt-get install chef chef-server -yu


During the installation process, a few questions are asked and can be replied as follows:


+-------------------------------+------------------------------+---------------------------------------+
|Questions                      |Possible Answer               |Target File                            |
+-------------------------------+------------------------------+---------------------------------------+
|Domain for Chef                |http://chef.company.com       |/etc/chef/client.rb                    |
+-------------------------------+------------------------------+---------------------------------------+
|Password for AMQP              |password                      |/etc/chef/server.rb                    |
+-------------------------------+------------------------------+---------------------------------------+
|Password for the Web UI        |admin:password                |/etc/chef/webui.rb with key            |
|                               |                              |'web_ui_admin_default_password'        |
+-------------------------------+------------------------------+---------------------------------------+


This will:

* Install all the dependencies for Chef Server, including Merb, CouchDB, RabbitMQ, etc.
* Starts CouchDB (via the couchdb package).
* Starts RabbitMQ (via the rabbitmq-server package).
* Start chef-server-api via /etc/init.d/chef-server, running a merb worker on port 4000
* Start chef-server-webui via /etc/init.d/chef-server-webui, running a merb worker on port 4040
* Start chef-solr-indexer via /etc/init.d/chef-solr-indexer, connecting to the rabbitmq-server
* Start chef-solr via /etc/init.d/chef-solr, using the distro package for solr-jetty
* Start chef-client via /etc/init.d/chef-client
* Add configuration files in /etc/chef for the client, server, solr/solr-indexer and solo
* Create all the correct directory paths per the configuration files


Verify that all components are running
++++++++++++++++++++++++++++++++++++++

Check if the server is listening by typing command netstat::

	# Chef CLI using Knife
	netstat -tapn | grep 4000

	# Chef Web UI
	netstat -tapn | grep 4040

	# CouchDB database server
	netstat -tapn | grep 5984

	# AMQP - Advanced Message Queueing Protocol, see http://www.amqp.org
	netstat -tapn | grep 5672

	# Apache Solr
	netstat -tapn | grep 8983

How to Proxy Chef Server with Apache
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

What if we could use a default port to communicate with Chef and use Apache as a proxy. `Original tutorial`_ is available with more details.

::

	sudo su

	# Install Apache and Git
	apt-get install -yu apache2 git-core

	# Enable new module
	for a2mod in proxy proxy_http proxy_balancer ssl rewrite headers
	do
		sudo a2enmod $a2mod
	done

	# Add a new port to listen to
	nano /etc/apache2/ports.conf

	# mod_ssl directive should contain something like:
	<IfModule mod_ssl.c>
		Listen 443
		Listen 444
	</IfModule>

We need to create a certificate to run HTTP traffic over a secure connection. To issue a new certificate, we are going to use a Rake_ task. Rake is a simple ruby build program with capabilities similar to Make or Ant from the Java world or alternatively Phing in PHP::


	# Go home first (and don't forget to drink your cup of coffee / tea which is getting cold!!)
	sudo su
	cd

	# Fetch a dummy Chef repository to get the Rake file (-> generate certificate)
	git clone git://github.com/opscode/chef-repo.git chef-repo-init
	cd chef-repo-init

	# Generate a certificate and put it into the chef directory
	rake ssl_cert FQDN=`hostname -f`
	mkdir -p /etc/chef/certificates
	cp certificates/`hostname -f`.pem /etc/chef/certificates

Time to turn up sleeves one more time since some manual configuration is required to set up a Virtual Host. Copy and paste example Apache Virtual Host `sample`_ into :file:`/etc/apache2/sites-available/chef_server.conf` and replace the ``CHANGME`` with the domain of the company::

	# Copy Virtual Host Sample into
	sudo su
	nano -w /etc/apache2/sites-available/chef_server.conf

	# Enables Virtual Host
	a2ensite chef_server.conf
	a2dissite default

	# Restart Apache
	service apache2 restart

Set up Firewall
+++++++++++++++

As a good practice, we configure the Firewall to only accept connection coming from 443 and 444::

	# Open port www,ssh,sftp,https,444
	iptables -P INPUT ACCEPT; iptables -F
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -m multiport -p tcp --dport www,ssh,sftp,https -j  ACCEPT
	iptables -A INPUT -p tcp --dport 444 -j ACCEPT
	iptables -A INPUT -p udp -s 0/0 --sport 53 -j ACCEPT
	iptables -A INPUT -i eth0 -p icmp -j ACCEPT
	iptables -A INPUT -j LOG -m limit
	iptables -A INPUT -j REJECT

To make the rules apply at the next reboot, the current state of the firewall must be written back into a file::

	# Create a runnable file for next reboot
	echo '#!/bin/sh' > /etc/network/if-pre-up.d/iptables-load
	echo "iptables-restore < /etc/iptables.rules" >> /etc/network/if-pre-up.d/iptables-load
	chmod +x /etc/network/if-pre-up.d/iptables-load


Part II - Workstation installation
-----------------------------------

A Chef workstation is where you develop cookbooks, interact with your chef-server, and interact with nodes.

Install Chef
++++++++++++++++++++

To install Chef and its dependencies, run the following code using Gem_ ::

	sudo su
	gem install chef --no-ri --no-rdoc

	# Here we install version 0.9.1 since value 1.0.0 seems to have a problem with ruby 1.8
	ruby -v
	gem install --version 0.9.1 spiceweasel


Download the Chef Repository
++++++++++++++++++++++++++++++

::

	# Read & Write access
	git clone --recursive git@github.com:visay/chef-repo.git
	cd chef-repo
	mkdir .chef

Configure Knife
++++++++++++++++

Knife is a powerful command-line interface (CLI) that comes with Chef enabling to communicate with the Chef Server from the work station. To configure it copy / paste the `Knife sample`_ into :file:`.chef/knife.rb` and tailor the content to include your username in it. Along to :file:`knife.rb`, one needs to create two additional files enabling a authentication against the server. To do so, fetch the content of :file:`validation.pem` from the Chef server and paste it in the work station::

	# On the working station, copy the key within the chef repository
	ssh chef
	cat /etc/chef/validation.pem
	cd chef-repo
	nano .chef/validation.pem


Time to create a new user and a private key using the web UI of Chef::

	https://chef.company.com:444/clients/new
	cd chef-repo
	nano .chef/USERNAME.pem

The connection with the Chef server can be established and tested using knife::

	# Should display a list of client
	knife client list

To read more about the capability of Knife, refer to the documentation_

Part III - Client Server Installation
----------------------------------------

Chef client is the command that will fetch the recipe from the Chef server, configure according to local variables (e.g. IP address, host name) and execute them eventually. This command requires root privileges are run with sudo. One of the easiest way of installing a Chef client is to run the knife bootstrap command::

	knife bootstrap HOSTNAME -x USERNAME --sudo

.. note::

	To find HOSTNAME run command ``hostname -f`` on the target.

To ensure the Chef client has been correctly initialized, test with::

	knife node list
	knife node show HOSTNAME

	knife cookbook list
	> should be empty since no cookbook has been uploaded to the Chef server yet

Part IV - Finishing installation
----------------------------------------

Now that we have completed the installation, this is the time to customize values within the roles and upload data to the Chef server such as cookbook, roles and so forth... For doing that, we could ask ``spiceweasel`` to give us a hand for generating Chef commands to initialize our infrastructure::

	# Open roles and customize values
	cd chef-repo
	nano roles/*.rb

	# Add more possible user in data bag
	data_bags/users/USERNAME.json

	# Add this users into infrastructure.yml

	spiceweasel infrastructure.yml
	> should display a list of command among them cookbooks and roles. Copy / paste these commands in the console

	# Alternatively, if command 'parallel' is installed, one can tell parallel to execute these command for us.
	spiceweasel infrastructure.yml | parallel -k -j 1'


.. ..........................
.. Link glossary
.. ..........................

.. _page: http://wiki.opscode.com/display/chef/Installing+Chef+Server+on+Debian+or+Ubuntu+using+Packages
.. _Rake: http://rake.rubyforge.org/
.. _Gem: http://docs.rubygems.org/
.. _sample: ../10-Appendix/ApacheVirtualHostSample.html
.. _Knife sample: ../10-Appendix/KnifeSample.html
.. _documentation: http://wiki.opscode.com/display/chef/Knife+Built+In+Subcommands
.. _Original tutorial: http://wiki.opscode.com/display/chef/How+to+Proxy+Chef+Server+with+Apache
