# Overview
This repo contains scripts for:
- provisionining a Google Kubernetes Engine cluster for non-prod and prod
- deploying our sample site to the cluster
- deploying a monitoring dashboard to scrape metrics from the cluster

Setup instructions are found [here](https://github.com/stanzusstanzus/sample-gke-service-infra/blob/master/setup.md)
## Design
The solution consists of the following components:
- Google Kubernetes Engine Cluster in a VPC - allows segregation of environments and fine grained network control if required
- Google Load Balancer with Ingress to cluster
- Static Site and WAR microservices deployed on cluster as container images
- Cloud CDN enabled for caching static content and global distribution at low latency
- A monitoring stack using Prometheus and Grafana where we can view kubernetes and application specific metrics

![Diagram](https://github.com/stanzusstanzus/sample-gke-service-infra/blob/master/assets/diagram.png)


### Decisions
An overarching principle was to keep this environment simple, with flexibility in enhancing each aspect as required and requiring the least amount of 3rd party tools.

Kubernetes in the Cloud was selected as it provides great scaling capabilities and redundancy as well as low risk deployments, being able to easily utilise canary or blue-green deployment methodologies enabling high availability. It also provides ease of creating prod-like environments with infra-as-code.

Containerisation also allows developers to develop and test in prod-like environments easily, avoiding situations where code works 'locally' but not in prod.

Cloud CDN was used to ease traffic to cluster and enable distribution of content at low latencies around the world.

Terraform was selected as it is a common and multi-platform tool for infra-as-code and simplifies creation of infra as well as allowing all to see how infra is configured, in situations where there maybe firewalls or rbac that can result in development or product issues.

Kubernetes resource configuration was done in this way as to require the least amount of tools and to keep it simple however as more microservices are created, it may be useful to create helm charts to template groups of resources or kustomize to patch config values into manifests.

Prometheus and Grafana were selected as the monitoring stack due to the ease of ingesting metrics from 3rd party apps and easy to use dashboarding and alert policy creation. Cloud native monitoring can also be used but not as many 3rd party integrations available and the cost can quickly increase.

A regional SSD persistent disk was selected for the Prevayler store to allow high speed and high reliability utilising multiple regions.

12 Factor was mainly followed except for repo structure for the sake of this demo.

### Production and Non Production
- The non production cluster nodepool is smaller, with nodepools in only one availability zone, as we won't be needing the extra resilience.
- We also have defined several namespaces which we can expand upon, and have namespaces for each developer to be able to deploy their branch into a prod-like environment rather than only test locally.
- Local testing can also be done by building and running the container images in docker locally
- The Production cluster makes use of multiple availability zones in the australia region and having additional nodes for extra headway in scaling.
- In the real world we will also add TLS to the ingress


## Improvements, End State and things that weren't implemented here
### Security
- We'd set up TLS on our ingress points
- set up kubernetes network policies to restrict traffic
- set up a firewall and master auth networks on our VPC to only allow authorised subnets to access the kubernetes API
- More fine grained rbac on kubernetes and gcloud
- Container vulnerability scanning at registry
- CI/CD (touched below)


### CI/CD
Abstracted out of this solution, but ideally the static site and war will have their own git repos, to allow branching and tagging of versions for each app, with CI/CD triggered on merge to master/trunk which will build and test the artifacts (images) and then deploy them to the registry.

Deployment to production would be as follows through the CI/CD tool (e.g. cloud native tools or hosted jenkins/bamboo):
 1. once all non-prod testing has passed, generate the latest deployment manifests with the correct version of the artifact to be deployed and store this in artifact storage, e.g. jfrog artifactory, s3, google storage, etc.
 2. human triggered deploy to the production cluster / alternatively, if automated testing provides very high confidence automatically trigger deployment
 3. As we are using kubernetes, we are able to use a canary deployment method to allow progressive roll-out to users and allow us to minimise any disruptions by isolating to a smaller group of users
 3. Rollbacks are as simple as redeploying the previous version's manifest and deleting the new manifest/service

Deployment of terraform/kubernetes would also be through specific pipelines running the relevant make targets, setting the correct environment variables.

### Monitoring
For the sake of this demo we port forward to access the clusterIP but we'd set up ingress to Grafana/Prometheus in the real world.
Other improvements:
- incorporating custom metrics exported out of our java app into prometheus
- logging of our application into a log aggregator
- alert policies and notification based on SLIs/SLOs/SLAs


### Scaling and End State
There are multiple options for scaling from here:
- horizontal pod autoscaling for ramping up number of replicas based on pod cpu/memory metrics
- horizontal scaling of nodepools if we require more resources or are expanding the number of services on the kubernetes cluster
- addition of clusters in more locations to support faster latency for the dynamic aspects of the site
- moving from Prevayler to Cloud managed RDBMS solutions such as Google CloudSQL, AWS RDS or in memory data stores such as Google Memorystore or AWS Elasticache
- completely serve static content from CDN and only keep ingress for dynamic paths
