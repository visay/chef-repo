name "functional-test"

  description "Roles for a setting up a functional testing environment"
  
  # List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
  run_list "recipe[functional-test]"

