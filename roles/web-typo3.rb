name "web-typo3"

  description "Roles for a Web Server hosting TYPO3"

  # List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
  run_list "recipe[typo3]"

  # Attributes applied if the node doesn't have it set already.
  #default_attributes()

  # Attributes applied no matter what the node has set already.
  #override_attributes()
