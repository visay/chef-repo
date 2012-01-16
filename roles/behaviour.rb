name "behaviour"

  description "Roles for a setting up a Behaviour Testing Server"
  
  # List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
  run_list "recipe[cucumber::default]"

