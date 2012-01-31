Functional Testing
===============================

In engineering and its various subdisciplines, functional or acceptance testing is a test conducted to determine if the requirements of a specification or contract are met.

The PHP Quality Assurance Toolchain
------------------------------------

Here is an overview of what tools we need to install:

* Behat_: Behat was inspired by Ruby's Cucumber project and especially its syntax part (Gherkin). It tries to be like Cucumber with input (Feature files) and output (console formatters), but in core, it has been built from the ground on pure php with Symfony2 components.
* Mink_: Mink is an open source acceptance test framework for web applications, written in PHP 5.3.
* Goutte_: Goutte is a headless browser emulators.
* Selenium2_: Selenium2 or WebDriver is the successor to Selenium RC (Remote Control). Selenium WebDriver sends commands to a browser and retrieves results. Unlike in Selenium 1, where the Selenium RC server was necessary to run tests, Selenium WebDriver does not need a special server to execute tests. Instead, the WebDriver directly starts a browser instance and controls it.
* Zombie_: Zombie.js is a headless browser emulator, written on node.js. It supports all JS interactions that Selenium does and works almost as fast as Goutte does. It’s best of both worlds, actually, but still limited to only one browser type (Chromium), also it’s still slower than Goutte and requires node.js and npm to be installed on the system.

.. _Behat: http://behat.org/
.. _Mink: http://mink.behat.org/
.. _Goutte: http://mink.behat.org/#gouttedriver
.. _Selenium2: http://seleniumhq.org/
.. _Zombie: http://zombie.labnotes.org/


Installing
--------------------------------

PHP Functional Test environment is already included in role "ci-server" previously installed::

	# Edit role to the HOSTNAME (e.g ci.company.com) .
	knife node show HOSTNAME

	> Should display something like bellow

	Node Name:   HOSTNAME
	Run List:    role[ci-server]
	Recipes:     (..) testing::functional

At the end of the installation, ``behat`` command should be available in the terminal. Refer to `Writing Functional Testing`_ for more information.

.. _Writing Functional Testing: ../05-Tutorials/WritingFunctionalTest.html

