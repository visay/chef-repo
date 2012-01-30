Writing Unit Test
========================

Behat was inspired by Ruby's Cucumber project and especially its syntax part (Gherkin). Gherkin is the language that Cucumber understands. It is a Business Readable, Domain Specific Language that lets you describe software’s behaviour without detailing how that behaviour is implemented. Gherkin serves two purposes – documentation and automated tests.


Bootstrapping Environment

::

	# Before running PHPUnit we need to ensure two things
	# * EXT:phpunit is verioned within the website
	# * sure a BE User "_cli_phpunit" is created

	# Launch the Test for the extension
	cd /my/document/public_html
	php typo3/cli_dispatch.phpsh  phpunit typo3conf/ext/EXTENSION/Tests

	# Add a build.xml file into your project and adjust it

	# Download the Ant build file
    curl -O https://raw.github.com/fudriot/typo3-project-testing/master/build.xml
