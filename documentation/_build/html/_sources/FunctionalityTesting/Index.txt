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



Configure the environment
---------------------------

Behat was inspired by Ruby's Cucumber project and especially its syntax part (Gherkin). Gherkin is the language that Cucumber understands. It is a Business Readable, Domain Specific Language that lets you describe software’s behaviour without detailing how that behaviour is implemented. Gherkin serves two purposes – documentation and automated tests.

::

	# Create files into folder "features"
	behat --init


Make sure that :file:`features/boostrap/FeatureContext.php` extends the MinkContext::

	require_once 'mink/autoload.php';

	/**
	 * Features context.
	 */
	class FeatureContext extends Behat\Mink\Behat\Context\MinkContext

If not already done, download Selenium2_ and save it somewhere in your file structure. Then, launch the server with::

	cd path/to/selenium-server
	java -jar selenium-server-standalone-2.xx.jar

Create a file :file:`behat.yml` at the root of the working copy and customize the base_url::

	# Content of "behat.yml"
	default:
		context:
			parameters:
				base_url: http://mywebsite.local/
				browser: chrome
				javascript_session: webdriver
				webdriver:
					host: http://localhost:4444/wd/hub

Write a first test and save it under :file:`signin.feature` for example::

	Feature: User sessions
		In order to access their account
		As a user
		I need to be able to log into the website

		Scenario: Login
			Given I am on "/"
				And I should see "Login"
			When I fill in "email" with "myemail@test.com"
				And I fill in "password" with "mysecurepassword"
				And I press "Login"
			Then I should be on "/dashboard"
				And I should see "Welcome back"

		Scenario: Logout
			Given I am logged in as "myemail@test.com" with password "mysecurepassword"
			When I follow "Logout"
			Then I should be on "/"
				And I should see "Login"



... and run with::

	behat
	> green color means the text succeed, red it fails.

A few useful commands to highlight::

	# Display the list of possible syntax
	behat -df

