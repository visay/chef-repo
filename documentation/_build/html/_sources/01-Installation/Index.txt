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

Chef Server Installation
------------------------

Bellow is a straight walkthrough for Ubuntu based environment without much explanation. To get a more in depth
insight of what is done, a reading from the official Wiki `page <http://wiki.opscode
.com/display/chef/Installing+Chef+Server+on+Debian+or+Ubuntu+using+Packages/>`_ is recommended.


Add the Opscode APT Repository
+++++++++++++++++++++++++++++++

::

	echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list

Add the GPG Key and Update Index
++++++++++++++++++++++++++++++++

::

	sudo mkdir -p /etc/apt/trusted.gpg.d
	gpg --fetch-key http://apt.opscode.com/packages@opscode.com.gpg.key
	gpg --export packages@opscode.com | sudo tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null
	sudo apt-get update

Installing the opscode-keyring package will keep the key up-to-date::

	sudo apt-get install opscode-keyring -yu


Install the chef-server package
+++++++++++++++++++++++++++++++

::

	sudo apt-get upgrade -yu
	sudo apt-get install chef chef-server -yu


During the installation process, a few questions will be asked such as

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


Verify That All Components are Running
++++++++++++++++++++++++++++++++++++++

::

	netstat -tapn | grep 4000
	netstat -tapn | grep 4040
	netstat -tapn | grep 5984
	netstat -tapn | grep 5672
	netstat -tapn | grep 8983

How to Proxy Chef Server with Apache
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

(still waiting for SNI (Server Name Indication) in Ubuntu for having https better support)

http://wiki.opscode.com/display/chef/How+to+Proxy+Chef+Server+with+Apache

::

	apt-get install -yu apache2 git-core
	for a2mod in proxy proxy_http proxy_balancer ssl rewrite headers
	do
	  sudo a2enmod $a2mod
	done

A little manual configuration is needed to set up a Virtual Host::

na /etc/apache2/sites-available/chef_server.conf (cf. config at the bottom)
sudo a2ensite chef_server.conf
na /etc/apache2/ports.conf

::

	cd
	git clone git://github.com/opscode/chef-repo.git chef-repo-init
	cd chef-repo-init
	rake ssl_cert FQDN=`hostname -f`
	sudo mkdir -p /etc/chef/certificates
	sudo cp certificates/`hostname -f`.pem /etc/chef/certificates


Set up Firewall
+++++++++++++++

::

	iptables -P INPUT ACCEPT; iptables -F
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -m multiport -p tcp --dport www,ssh,sftp,https -j  ACCEPT
	iptables -A INPUT -p tcp --dport 444 -j ACCEPT
	iptables -A INPUT -p udp -s 0/0 --sport 53 -j ACCEPT
	iptables -A INPUT -i eth0 -p icmp -j ACCEPT
	iptables -A INPUT -j LOG -m limit
	iptables -A INPUT -j REJECT

To make the rules apply at the next reboot::

	echo '#!/bin/sh' > /etc/network/if-pre-up.d/iptables-load
	echo "iptables-restore < /etc/iptables.rules" >> /etc/network/if-pre-up.d/iptables-load
	chmod +x /etc/network/if-pre-up.d/iptables-load


Client Server Installation
---------------------------
http://wiki.opscode.com/display/chef/Installing+Chef+Client+on+Ubuntu+or+Debian