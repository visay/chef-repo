Writing Functional Test
========================

Behat was inspired by Ruby's Cucumber project and especially its syntax part (Gherkin). Gherkin is the language that Cucumber understands. It is a Business Readable, Domain Specific Language that lets you describe software’s behaviour without detailing how that behaviour is implemented. Gherkin serves two purposes – documentation and automated tests.

Initialize the environment
---------------------------

Bootstrapping Environment

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


.. _Selenium2: http://seleniumhq.org/download/
