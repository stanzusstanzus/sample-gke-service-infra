project_id     = "prod2-301211"
region         = "australia-southeast1"
gke_location   = "australia-southeast1"
gke_num_nodes  = "2" # due to default quota of ip addresses of 8 and we are using 3AZs. This normally would be adjusted at the organisation admin level
app_namespaces = ["prod", "monitoring"]
