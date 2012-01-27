Tutorials
===============================

How to set up a new project?
---------------------------------------

Version a TYPO3 website
+++++++++++++++++++++++++

When versioning a TYPO3 website, it is recommended to include the Document Root. In the snippet bellow we assume we have the following file structure::

	├── mywebsite.local
    │   ├── build
    │   ├── build.xml # contains a Ant script
    │   ├── htdocs
    │   │   ├── fileadmin
    │   │   ├── t3lib -> typo3_src/t3lib
    │   │   ├── typo3 -> typo3_src/typo3
    │   │   ├── typo3conf
    │   │   ├── typo3temp
    │   │   └── uploads

Run the following commands::

	# Add files from HTDOCS into the repository

	svn add -N htdocs htdocs/typo3temp/ htdocs/fileadmin/ htdocs/typo3conf htdocs/t3lib htdocs/typo3 htdocs/index.php htdocs/typo3conf/extTables.php htdocs/typo3conf/icons htdocs/typo3conf/index.html htdocs/typo3conf/realurl-custom.php htdocs/typo3conf/realurl_conf.php

	svn add htdocs/INSTALL.txt htdocs/.htaccess_default htdocs/ChangeLog htdocs/NEWS.txt htdocs/clear.gif htdocs/google5dbc66ed109fdb0d.html htdocs/favicon.ico htdocs/LICENSE.txt htdocs/GPL.txt htdocs/RELEASE_NOTES.txt htdocs/index.html htdocs/README.txt

	# build.xml
	mkdir build
	curl -O https://raw.github.com/fudriot/typo3-project-testing/master/build.xml
	svn add build build.xml

	svn commit -m "initial upload process"

	# Add files from FILEADMIN into the repository
	svn add htdocs/fileadmin/images htdocs/fileadmin/fonts htdocs/fileadmin/javascripts htdocs/fileadmin/stylesheets htdocs/fileadmin/templates

	svn add -N htdocs/fileadmin/_temp_ htdocs/fileadmin/user_upload
	svn commit -m "initial upload process"

	# Add files from UPLOADS into the repository
	# The content of the folder is not versioned as it sync via rsync commands
	svn add -N htdocs/uploads
	svn commit -m "initial upload process"

	------------------------------------------
	# Ignore some files
	svn propedit svn:ignore .
	logs

	svn propedit svn:ignore build
	api
	code-browser
	coverage
	logs
	pdepend


	svn propedit svn:ignore htdocs
	.htaccess
	typo3_src*
	build.xml
	.idea

	svn propedit svn:ignore htdocs/typo3temp
	*


	svn propedit svn:ignore htdocs/typo3conf
	temp_CACHED*
	localconf.php
	l10n
	ENABLE_INSTALL_TOOL
	*.log
	*.sql


	svn propedit svn:ignore htdocs/fileadmin/_temp_
	*


	svn propedit svn:ignore htdocs/fileadmin/user_upload
	*


	svn propedit svn:ignore htdocs/uploads
	*


	svn commit -m "initial upload process"


Finishing set up
++++++++++++++++++++++++

On |CI| create a new :file:`Jenkins/Projects/myproject.local/` where you can put.

* :file:`dump.sql` (mandatory): the dump of the database
* :file:`localconf.php` (mandatory) contains credentials of the database
* :file:`extTables.php` (recommended): adds some configuration for EXT:phpunit. Included content::

	# extTables.php

	require_once(t3lib_extMgm::extPath('phpunit') . 'PEAR/PHPUnit/Autoload.php');
	PHP_CodeCoverage_Filter::getInstance()->addDirectoryToBlacklist(t3lib_extMgm::extPath('phpunit'));
	PHP_CodeCoverage_Filter::getInstance()->addDirectoryToBlacklist(PATH_site . 'typo3_src');

