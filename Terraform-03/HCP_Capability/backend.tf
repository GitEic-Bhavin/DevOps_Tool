terraform { 
  cloud { 
    
    organization = "Demo_HCP_Bhavin" 

    workspaces { 
      name = "Cli_Driven_WF_WS" 
    } 
  } 
}