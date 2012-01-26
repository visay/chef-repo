How to versione a TYPO3 website
===============================


# Add files from HTDOCS into the repository

svn add -N htdocs htdocs/typo3temp/ htdocs/fileadmin/ htdocs/typo3conf htdocs/t3lib htdocs/typo3 htdocs/index.php htdocs/typo3conf/extTables.php htdocs/typo3conf/icons htdocs/typo3conf/index.html htdocs/typo3conf/realurl-custom.php htdocs/typo3conf/realurl_conf.php
svn add htdocs/INSTALL.txt htdocs/.htaccess_default htdocs/ChangeLog htdocs/NEWS.txt htdocs/clear.gif htdocs/google5dbc66ed109fdb0d.html htdocs/favicon.ico htdocs/LICENSE.txt htdocs/GPL.txt htdocs/RELEASE_NOTES.txt htdocs/index.html htdocs/README.txt

svn add build build.xml

svn commit -m "initial upload process"


# Add files from FILEADMIN into the repository
svn add htdocs/fileadmin/images htdocs/fileadmin/fonts htdocs/fileadmin/javascripts htdocs/fileadmin/stylesheets htdocs/fileadmin/templates

svn add -N htdocs/fileadmin/_temp_ htdocs/fileadmin/user_upload
svn commit -m "initial upload process"

# Add files from UPLOADS into the repository

This folder is not versioned and is keept up to date via rsync commands
svn add -N htdocs/uploads
svn commit -m "initial upload process"


svn propedit svn:ignore .
--------------------------
logs

svn propedit svn:ignore build
----------------------------------
api
code-browser
coverage
logs
pdepend


svn propedit svn:ignore htdocs
-------------------------------
.htaccess
typo3_src*
build.xml
.idea

svn propedit svn:ignore htdocs/typo3temp
-----------------------------------------
*


svn propedit svn:ignore htdocs/typo3conf
-----------------------------------------
temp_CACHED*
localconf.php
l10n
ENABLE_INSTALL_TOOL
*.log
*.sql


svn propedit svn:ignore htdocs/fileadmin/_temp_
-------------------------------------------------
*


svn propedit svn:ignore htdocs/fileadmin/user_upload
----------------------------------------------------
*


svn propedit svn:ignore htdocs/uploads
---------------------------------------
*


svn commit -m "initial upload process"



# INSTALL SERVER

cd /usr/share/php/PHP/CodeSniffer/Standards
svn co http://subversion.assembla.com/svn/pti/libraries/pear/PEAR/PHP/CodeSniffer/Standards/TYPO3 TYPO3
svn co http://subversion.assembla.com/svn/pti/libraries/pear/PEAR/PHP/CodeSniffer/Standards/TYPO3v4 TYPO3v4

ou

svn co https://svn.typo3.org/Teams/forge.typo3.org/hudson-helpers/tools/PHP_CodeSniffer/TYPO3/trunk/ TYPO3
svn co https://svn.typo3.org/Teams/forge.typo3.org/hudson-helpers/tools/PHP_CodeSniffer/TYPO3v4/trunk/ TYPO3v4


-> ADD AUTOMATIC UPGRADE PEAR
http://www.assembla.com/code/pti/subversion/nodes/build/automatic-pear-update/build.xml

-> Add a Cron task or do it in CI
-> create repository to version it=

Example of Build File
http://git.typo3.org/FLOW3/Distributions/Base.git?a=blob;f=build.xml;h=8f9bad37c61586b8a964b53055e95efaafb6ddae








# extTables.php

require_once(t3lib_extMgm::extPath('phpunit') . 'PEAR/PHPUnit/Autoload.php');
PHP_CodeCoverage_Filter::getInstance()->addDirectoryToBlacklist(t3lib_extMgm::extPath('phpunit'));
PHP_CodeCoverage_Filter::getInstance()->addDirectoryToBlacklist(PATH_site . 'typo3_src');


