name "production"
description "The production environment. All cookbooks in this environment are considered STABLE should have FIXED VERSIONS to ensure a certain (stable) state."

cookbook_versions({
  "apache2"             => "= 1.0.2",
})
