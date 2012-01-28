Unit Testing
===============================

What is a Unit Test?
--------------------


In computer programming, unit testing is a method by which individual units of source code are tested to determine if they are fit for use. A unit is the smallest testable part of an application.


The PHP Quality Assurance Toolchain
------------------------------------

Here is an overview of what tools we need to install:

* PHPUnit_ is a unit testing software framework for the programming language PHP. PHPUnit was created with the view that the sooner you detect your code mistakes, the quicker you can fix them. Itself, PHPUnit is the de-facto standard for the unit testing of PHP code.
* PHP_CodeSniffer_ is the most commonly used tool for static analysis of PHP code. It is typically used to detect violations of code formatting standards but also sup- ports software metrics as well as the detection of potential defects.
* phpcpd_ (PHP Copy/Paste Detector) searches for duplicated code in a PHP project.
* PHP_Depend_ is a tool for static code analysis of PHP code that is inspired by JDe- pend.
* phpmd_ (PHP Mess Detector) allows the definition of rules that operate on the raw data collected by PHP_Depend.
* phploc_ measures the scope of a PHP project by, among other metrics, means of different forms of the Lines of Code (LOC) software metric.
* PHP_CodeBrowser_ is a report generator that takes the XML output of the afore- mentioned tools as well as the sourcecode of the project as its input.
* Although it is currently being replaced by more modern tools such as phpdox_, we will use PHPDocumentor_ for automated API documentation generation for PHP code in this book.


.. _PHPUnit: https://github.com/sebastianbergmann/phpunit/
.. _PHP_CodeSniffer: http://pear.php.net/package/PHP_CodeSniffer/
.. _phpcpd: https://github.com/sebastianbergmann/phpcpd
.. _PHP_Depend: http://pdepend.org/
.. _phpmd: http://phpmd.org/
.. _phploc: https://github.com/sebastianbergmann/phploc
.. _PHP_CodeBrowser: http://blog.mayflower.de/archives/626-PHP_CodeBrowser-goes-stable.html
.. _phpdox: https://github.com/theseer/phpdox
.. _PHPDocumentor: http://pear.php.net/package/PHPDocumentor/

Unit Test with TYPO3
--------------------------------

In order to be able to run Unit Tests in the frame of a TYPO3 website, the server must be configured to run TYPO3 properly. To achieve it, a Chef recipe can be used to configure the server (cf. next chapter).

Installing
--------------------------------

Installing a PHP Unit Test environment using Chef is about setting the appropriate roles.

::

	# Edit role to the HOSTNAME (e.g ci.company.com) .
	knife node edit HOSTNAME

	# Verify the HOSTNAME has the recipes in the right order:
	 "run_list": [
	   "role[base]",
	   "role[web]",
	   "role[web-typo3]",
	   "role[ci]",
	   "role[unit-test]"
	 ]

	# Login into the client and run chef-client to execute the recipes
	ssh HOSTNAME
	sudo chef-client

	# Alternatively, chef-client can be launched from the workstation
	knife ssh name:ci* -x USERNAM "sudo chef-client"

At the end of the installation, a new Job has been created within |CI|. This job contains default configuration and is set as disabled because it will never be used as such but will be copied as template for new real jobs.

