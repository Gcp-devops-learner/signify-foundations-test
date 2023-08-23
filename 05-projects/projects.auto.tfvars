org_id          = "664894405813"
billing_account = "01EC42-60DAEA-EF98C0"


service_projects_map = {
  "prj-triange-dev" = { host = "prj-wns-triange-dev", parent = "1052332599765" },

  "prj-triange-prod" = { host = "prj-wns-triange-prod", parent = "864925398591" },

  "prj-triange-stage" = { host = "prj-wns-triange-stage", parent = "864925398592"},
    
  "prj-triange-common-a" = { host = "prj-wns-common-triange-poc", parent = "864925398596" },

  "prj-triange-common-b" = { host = "prj-wns-common-triange-logging", parent = "864925398596"},
      
  "prj-triange-common-c" = { host = "prj-wns-common-host-dev", parent = "864925398596"},
  
  "prj-triange-common-d" = { host = "prj-wns-common-host-prod", parent = "864925398596"},
  
  "prj-triange-common-e" = { host = "prj-wns-common-host-stage", parent = "864925398596"},




}

standalone_projects_map = { 
#"prj-sgnfy-com-ops" = {parent = "update_folder_id", apis = ["storage-api.googleapis.com","monitoring.googleapis.com","logging.googleapis.com","artifactregistry.googleapis.com"]}
} 
