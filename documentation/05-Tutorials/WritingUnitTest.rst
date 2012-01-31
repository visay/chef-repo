Writing Unit Test
========================

Behat was inspired by Ruby's Cucumber project and especially its syntax part (Gherkin). Gherkin is the language that Cucumber understands. It is a Business Readable, Domain Specific Language that lets you describe software’s behaviour without detailing how that behaviour is implemented. Gherkin serves two purposes – documentation and automated tests.


Before running PHPUnit we need to ensure

* EXT:phpunit is verioned within the website
* Make sure a BE User "_cli_phpunit" is created
* :file:`build.xml` is added and personalized along with :file:`build/phpcs.xml` and :file:`build/phpmd.xml`
* :file:`extTables.php` has the following::

	# typo3conf/extTables.php
	require_once(t3lib_extMgm::extPath('phpunit') . 'PEAR/PHPUnit/Autoload.php');
	PHP_CodeCoverage_Filter::getInstance()->addDirectoryToBlacklist(t3lib_extMgm::extPath('phpunit'));
	PHP_CodeCoverage_Filter::getInstance()->addDirectoryToBlacklist(PATH_site . 'typo3_src');

* A core is defined::

	mkdir /t3core/typo3_src-4.5.11 (without git)
	cd /t3core/typo3_src.git
	git fetch --tags
	git checkout TYPO3_4-5-11; git submodule update
	./git-archive-all.sh  ; tar -xf  typo3_src.git.tar -C /t3core/typo3_src-4.5.11
