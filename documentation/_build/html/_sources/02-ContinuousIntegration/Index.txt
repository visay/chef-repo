Continuous Integration
===============================

In software engineering, continuous integration (CI) implements continuous processes of applying quality control — small pieces of effort, applied frequently. Continuous integration aims to improve the quality of software, and to reduce the time taken to deliver it, by replacing the traditional practice of applying quality control after completing all development [Wikipedia_].


.. _Wikipedia: http://en.wikipedia.org/wiki/Continuous_integration


Jenkins
--------

Jenkins, previously known as Hudson, is an open source continuous integration tool written in Java.  Jenkins provides continuous integration services for software development, primarily in the Java programming language. It is a server-based system running in a servlet container such as Apache Tomcat. It supports SCM tools including CVS, Subversion, Git, and can execute Apache Ant and Apache Maven based projects as well as arbitrary shell scripts. The primary developer of Jenkins released under the MIT License, Jenkins is free software.

Installing Jenkins
-------------------

Jenkins is installed through Chef. Before launching the chef-client, consider updating the info inside :file:`roles/ci.rb` to suit the domain of the company. Then, run the command bellow::

	# Add new role to the HOSTNAME (e.g ci.company.com) .
	knife node run_list add HOSTNAME 'role[base]'
	knife node run_list add HOSTNAME 'role[web]'
	knife node run_list add HOSTNAME 'role[ci]'

	#Login into the client and run chef-client to execute the recipes
	ssh HOSTNAME
	sudo chef-client

At the end of the installation, a Jenkins instance should run at http://ci.company.com