.PHONY: plan-apply-gke init plan-gke apply-gke plan-apply-namespaces plan-namespaces apply-namespaces
GCP_ENV:=nonprod

plan-apply-gke: plan-gke apply-gke

plan-apply-namespaces: plan-namespaces apply-namespaces

plan-gke:
	cd gke && terraform init -reconfigure && terraform plan -lock-timeout=60s -var-file ../../$(GCP_ENV).tfvars -input=false -out planout ./

apply-gke: init
	cd gke && terraform init -reconfigure && terraform apply -lock-timeout=60s -input=false ./planout && rm ./planout

plan-namespaces: init
	cd namespaces && terraform init -reconfigure && terraform plan -lock-timeout=60s -var-file ../../$(GCP_ENV).tfvars -input=false -out planout ./

apply-namespaces: init
	cd namespaces && terraform init -reconfigure && terraform apply -lock-timeout=60s -input=false ./planout && rm ./planout
