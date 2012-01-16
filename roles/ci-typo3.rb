name "ci-typo3"

  description "Roles for a Continuous Integration server running TYPO3"
  
  # List of recipes and roles to apply.
  run_list "recipe[php-ci::default]", "recipe[bluepill::default]"
