Updating Documentation
========================

The documentation is written using Sphinx_ as documentation generator that converts reStructuredText (reST) syntax into HTML.

Installing Sphinx
---------------------------

Installing Sphinx::

	# On Ubuntu system
	apt-get install python-pip

	# Other system
	easy_install pip

	# Install Sphinx
    pip install sphinx

Getting the documentation from the Git repository::

	git clone --recusrive git@github.com:visay/chef-repo.git

Generating documentation::

	cd path/chef-repo/documentation

	# Chef all possible commands
	make

	# Before regenerating the documentation, clean the build folder first as security measure
	make clean; make html

	# Add an push to Git
	git add -A
	git ci -m "Update documentation"
	git push

.. _Sphinx: http://sphinx.pocoo.org/rest.html
