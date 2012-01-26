=============
What is Chef?
=============

Chef is a systems integration framework, built to bring the benefits of configuration management to your entire
infrastructure. Originally written by Opscode, Chef is open source under the Apache license and has more than 475
individual contributors and almost 100 corporations making it great.

How Chef Works?
---------------

You write “recipes” that describe how you want a part of your server (such as Apache, MySQL,
or Jenkins) to be configured. These recipes describe a series of resources that should be in a particular state -
packages that should be installed, services that should be running, or files that should be written. Chef makes sure
each resource is properly configured, and gives a safe, flexible, easily-repeatable mechanism for making sure
your servers are always running exactly the way you want them to.

How to install?
---------------

Chef comes in different flavors such as server / client mode, solo mode or possibly a hosted mode. The tutorial
bellow will focus on setting up a server / client infrastructure. The steps can be divided in three:

#. Install a Chef Server
#. Configure your local workstation
#. Install chef-client on your nodes

Installation of a Chef Server
------------------------------

Bellow is a straight walkthrough for Ubuntu based environment without much explanation. To get a more in depth
insight of what is done, a reading from the official Wiki `page <http://wiki.opscode
.com/display/chef/Installing+Chef+Server+on+Debian+or+Ubuntu+using+Packages/>`_ is recommended.


Add the Opscode APT Repository
+++++++++++++++++++++++++++++++

::

	# Configure Source to install Chef version 0.10
	echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list

Add the GPG Key and Update Index
++++++++++++++++++++++++++++++++

::

	# Create a directory for storing new key and import them
	sudo mkdir -p /etc/apt/trusted.gpg.d
	gpg --fetch-key http://apt.opscode.com/packages@opscode.com.gpg.key
	gpg --export packages@opscode.com | sudo tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null

	# Update the package definition.
	sudo apt-get update

Installing the opscode-keyring package will keep the key up-to-date::

	sudo apt-get install opscode-keyring -yu


Install the chef-server package
+++++++++++++++++++++++++++++++

::

	# Upgrade the distribution
	sudo apt-get upgrade -yu

	# Install Chef package
	sudo apt-get install chef chef-server -yu


During the installation process, a few questions are asked such as

+-------------------------------+------------------------------+---------------------------------------+
|Questions                      |Possible Answer               |Target File                            |
+-------------------------------+------------------------------+---------------------------------------+
|Domain for Chef                |http://chef.company.com       |/etc/chef/client.rb                    |
+-------------------------------+------------------------------+---------------------------------------+
|Password for the Chef Server   |password                      |/etc/chef/server.rb                    |
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

::

	# Check if the server is listening by typing command netstat
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

Original tutorial is available with more details in case something goes wrong `online <http://wiki.opscode
.com/display/chef/How+to+Proxy+Chef+Server+with+Apache
/>`_.

::

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


We need to create a certificate to run HTTP traffic over a secure connection which is done in the coming step::


	# Go home first (and don't forget to drink your cup of coffee / tea which is getting cold!!)
	cd

	# Fetch a dummy Chef repository to get the Rake file (-> generate certificate)
	# Rake can be compared as Ant script in the Ruby world.
	git clone git://github.com/opscode/chef-repo.git chef-repo-init
	cd chef-repo-init

	# Generate a certificate and put it into the chef directory
	rake ssl_cert FQDN=`hostname -f`
	sudo mkdir -p /etc/chef/certificates
	sudo cp certificates/`hostname -f`.pem /etc/chef/certificates



Turn up sleeves one more time since some more manual configuration is required to set up a Virtual Host. Copy and
paste example from appendix `Apache Virtual Host Sample <../10-Appendix/ApacheVirtualHostSample.html />`_ and replace
the ``CHANGME`` to the domain of the company. When done run the following commands::

	# Copy Virtual Host Sample into
	nano -w /etc/apache2/sites-available/chef_server.conf

	# Enables Virtual Host
	sudo a2ensite chef_server.conf

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

To make the rules apply at the next reboot, the current status of the firewall must be written into a file::

	# Create a runnable file for next reboot
	echo '#!/bin/sh' > /etc/network/if-pre-up.d/iptables-load
	echo "iptables-restore < /etc/iptables.rules" >> /etc/network/if-pre-up.d/iptables-load
	chmod +x /etc/network/if-pre-up.d/iptables-load


Install workstation
====================

The next step is to configure the Workstation which is the



Install Chef command
--------------------

::

	sudo gem install chef --no-ri --no-rdoc
	sudo gem install --version 0.9.1 spiceweasel


note: version 1.0.0 seems to have problem with ruby 1.8


https://github.com/mattray/spiceweasel/blob/master/examples/php-quick-start.yml





INSTALL - REPOSITORY
---------------------

::

	git clone git://github.com/opscode/chef-repo.git
	cd chef-repo
	mkdir .chef
	rm -rf .git
	git init
	etc...

::

	knife configure
	   Following answers:
	   /Users/fudriot/PhpstormProjects/chef-repo-we/.chef/knife.rb
	   https://chef
	   /Users/fudriot/PhpstormProjects/chef-repo-we/.chef/validation.pem
	   /Users/fudriot/PhpstormProjects/chef-repo

Server: copy validation key from::

	ssh chef
	cat /etc/chef/validation.pem


Web UI: Create Key for User::

	https://chef-www:444/clients/new
	na .chef/fudriot.pem


Server: Create Key for User (alternative)::

	knife client create fudriot -n -a -f /tmp/fudriot.pem -u chef-webui -k /etc/chef/webui.pem


Working station: test connection::


	knife client list




Client Server Installation
---------------------------
http://wiki.opscode.com/display/chef/Installing+Chef+Client+on+Ubuntu+or+Debian


