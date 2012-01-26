=====================
Apache Virtual Host
=====================

Replace ``CHANGME`` by the domain name of your company and put this file under
:file:`/etc/apache2/sites-available/chef_server.conf` for instance. Aditionaly pay attention the
:file:`/etc/chef/certificates/chef.CHANGEME.pem` exists and corresponds to a valide certificate.

::

	#######################
	# CHEF API
	#######################

	# REDIRECT HTTP -> HTTPS
	<VirtualHost *:80>

	        # CHANGEME
	        ServerName chef.CHANGEME

	        <IfModule mod_rewrite.c>
	                Options +FollowSymLinks
	                Options +Indexes
	                RewriteEngine On
	                RewriteCond %{SERVER_PORT} !^443$
	                # CHANGEME
	                RewriteRule ^(.*)$ https://chef.CHANGEME/$1 [R,L]
	        </IfModule>
	</VirtualHost>

	# HTTPS CONFIGURATION
	<VirtualHost *:443>
	        # CHANGEME
	        ServerName chef.CHANGEME
	        DocumentRoot /usr/share/chef-server-api/public

	        <Proxy balancer://chef_server>
	                BalancerMember http://127.0.0.1:4000
	                Order deny,allow
	                Allow from all
	        </Proxy>

	        LogLevel info
	        ErrorLog /var/log/apache2/chef_server-error.log
	        CustomLog /var/log/apache2/chef_server-access.log combined

	        SSLEngine On
	    # CHANGEME
	        SSLCertificateFile /etc/chef/certificates/chef.CHANGEME.pem
	        SSLCertificateKeyFile /etc/chef/certificates/chef.CHANGEME.pem

	        RequestHeader set X_FORWARDED_PROTO 'https'

	        RewriteEngine On
	        RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
	        RewriteRule ^/(.*)$ balancer://chef_server%{REQUEST_URI} [P,QSA,L]

	</VirtualHost>


	#######################
	# CHEF WEB UI
	#######################

	# REDIRECT HTTP -> HTTPS
	<VirtualHost *:80>

	        # CHANGEME
	        ServerName chef-www.CHANGEME

	        <IfModule mod_rewrite.c>
	                Options +FollowSymLinks
	                Options +Indexes
	                RewriteEngine On
	                RewriteCond %{SERVER_PORT} !^444$
	                # CHANGEME
	                RewriteRule ^(.*)$ https://chef-www.CHANGEME:444 [R,L]
	        </IfModule>
	</VirtualHost>


	# HTTPS CONFIGURATION

	<VirtualHost *:444>
	        # CHANGEME
	        ServerName chef-www.CHANGEME

	        DocumentRoot /usr/share/chef-server-webui/public

	        <Proxy balancer://chef_server_webui>
	                BalancerMember http://127.0.0.1:4040
	                Order deny,allow
	                Allow from all
	        </Proxy>

	        LogLevel info
	        ErrorLog /var/log/apache2/chef_server-error.log
	        CustomLog /var/log/apache2/chef_server-access.log combined

	        SSLEngine On
	        # CHANGEME
	        SSLCertificateFile /etc/chef/certificates/chef.CHANGEME.pem
	        SSLCertificateKeyFile /etc/chef/certificates/chef.CHANGEME.pem

	        RequestHeader set X_FORWARDED_PROTO 'https'

	        RewriteEngine On
	        RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
	        RewriteRule ^/(.*)$ balancer://chef_server_webui%{REQUEST_URI} [P,QSA,L]
	</VirtualHost>