How to version a new project?
---------------------------------------

Version a TYPO3 website
+++++++++++++++++++++++++

For versioning a TYPO3 website, it is recommended to include the Document Root, for example::

	├── mywebsite.local
	│   ├── htdocs
	│   │   ├── fileadmin
	│   │   ├── t3lib -> typo3_src/t3lib
	│   │   ├── typo3 -> typo3_src/typo3
	│   │   ├── typo3conf
	│   │   ├── typo3temp
	│   │   └── uploads


The commands bellow initialize files for unit and functional testing::

	# build.xml
	mkdir build

	# Initialize functional tests
	behat --init

	# Download the Ant build file
	curl -O https://raw.github.com/fudriot/typo3-project-testing/master/build.xml

	# Customize the build file by customizing path
	nano build.xml


The next step is about versioning the website using Subversion::

	# Add files from HTDOCS into the repository

	svn add -N htdocs htdocs/typo3temp/ htdocs/fileadmin/ htdocs/typo3conf htdocs/t3lib htdocs/typo3 htdocs/index.php htdocs/typo3conf/extTables.php htdocs/typo3conf/icons htdocs/typo3conf/index.html htdocs/typo3conf/realurl-custom.php htdocs/typo3conf/realurl_conf.php

	svn add htdocs/INSTALL.txt htdocs/.htaccess_default htdocs/ChangeLog htdocs/NEWS.txt htdocs/clear.gif htdocs/google5dbc66ed109fdb0d.html htdocs/favicon.ico htdocs/LICENSE.txt htdocs/GPL.txt htdocs/RELEASE_NOTES.txt htdocs/index.html htdocs/README.txt

	svn add build features build.xml

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
