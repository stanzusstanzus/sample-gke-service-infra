### 0. Pre Reqs
We require Linux/Mac OSX with below installed:
- Gcloud SDK
- Kubectl through cloud sdk ```gcloud components install kubectl```
- Terraform 12+
- Docker
- envsubst command line tool - if on mac install with brew as part of `gettext`, e.g. ```brew install gettext```

We require the following resources:
- Google Cloud Platform Account
- 2 Google Cloud Platform projects - 1 for prod and 1 for non prod.

### 1. Set Up Environment
1. Please modify the variable 'project_id' in the terraform vars files with the project_ids of the projects mentioned above: [non-prod](https://github.com/stanzusstanzus/sample-gke-service-infra/blob/master/01-terraform/nonprod.tfvars#L1), [prod](https://github.com/stanzusstanzus/sample-gke-service-infra/blob/master/01-terraform/prod.tfvars#L1)
3. Login to gcloud - ```gcloud auth login```
4. Set gcloud project to your non prod project ```gcloud config set project <project_id>```
5. authorise gcloud app credentials ```gcloud auth application-default login```
6. ```gcloud auth configure-docker``` once terraform is run to allow docker to use gcloud credentials


### 2. Deploy Non-Prod Terraform Module
1. In the 01-terraform/nonprod directory, run ```make plan-apply-gke```
- Note the name of the GKE cluster that was created


### 3. Deploy Kubernetes Resources
1. Run the following command ```gcloud container clusters get-credentials <cluster-name> --region australia-southeast1-a``` where `<cluster-name>` is the name of the GKE cluster that was created by terraform in the previous step e.g. ```gcloud container clusters get-credentials non-prod-301100-gke --region australia-southeast1-a```
2. In the 01-terraform/nonprod directory, run ```make plan-apply-namespaces```
2. In the `02-k8s` directory, run ```make build-and-deploy-images``` to build the static site, war container and grafana images and push to project registry
3. In the `02-k8s` directory, run ```make deploy-monitoring-manifests``` to deploy prometheus and grafana to the cluster
4. In the `02-k8s` directory, run ```make build-dev``` to deploy the site into the `dev` namespace
5. In the `02-k8s` directory, run ```make build-test``` to deploy the site into the `test` namespace
6. The ingress and Cloud CDN set up will take up to 10 minutes from deployment of manifests. The progress of this can be viewed in the Google Cloud Console.
7. Have a coffee break and stretch


### 4. Access the site
- Once ingress and Cloud CDN setup is complete...
- Run this command to get the URL to the site in the test namespace - ```kubectl describe ingress static-site-ingress -ntest | grep "Address" |  awk '{print $2}'````
- To view the war click on the `Sample WAR` hyperlink on the page.


### Optional - Deploy Prod Terraform and Manifests
1. Change your gcloud project to your prod project ```gcloud config set project <project_id>```
2. In the 01-terraform/prod directory, run ```make plan-apply```
3. Run the following command ```gcloud container clusters get-credentials <cluster-name> --region australia-southeast1``` where `<cluster-name>` is the name of the GKE cluster that was created by terraform in the previous step e.g. ```gcloud container clusters get-credentials crucial-context-301100-gke --region australia-southeast1```
4. In the 01-terraform/prod directory, run ```make plan-apply-namespaces```
5. In the `02-k8s` directory, run ```make build-and-deploy-images``` to build the static site, war container and grafana images and push to project registry
6. In the `02-k8s` directory, run ```make deploy-monitoring-manifests``` to deploy prometheus and grafana to the cluster
7. In the `02-k8s` directory, run ```make build-prod``` to deploy the site into the `prod` namespace
8. Once ingress and Cloud CDN setup is complete...
9. Run this command to get the URL to the site in the test namespace - ```kubectl describe ingress static-site-ingress -nprod | grep "Address" |  awk '{print $2}'```

### 5. Access grafana dashboard
- Get the pod name of the grafana pod - ```kubectl get pods -n monitoring```
- Forward port 3000 of the pod to a local port e.g. ```kubectl port-forward grafana-deployment-5947db9974-npgdk -n monitoring 11111:3000``` replacing the pod name with the one deployed
- Go to browser and access localhost:3000 and sign in with username 'admin' and password 'admin'
- View the available dashboards
