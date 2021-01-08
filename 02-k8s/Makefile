.PHONY: build-and-deploy-images deploy-app-manifests delete-app-manifests deploy-monitoring-manifests delete-all-manifests build-nonprod build-prod delete-nonprod delete-prod

export project_id := $(shell gcloud config get-value project)

build-nonprod: namespace_env := test
build-nonprod:	deploy-app-manifests

build-prod: namespace_env := prod
build-prod:	deploy-app-manifests

delete-prod: namespace_env := prod
delete-prod: delete-app-manifests

delete-nonprod: namespace_env := test
delete-nonprod: delete-app-manifests

build-and-deploy-images:
	docker build -t gcr.io/${project_id}/app-images/sample-war:0.1.0 -f Dockerfile-war .
	docker build -t gcr.io/${project_id}/app-images/sample-static-site:0.1.0 -f Dockerfile-static-site .
	docker build -t gcr.io/${project_id}/grafana:0.1.0 -f Dockerfile-grafana .
	docker push gcr.io/${project_id}/app-images/sample-war:0.1.0
	docker push gcr.io/${project_id}/app-images/sample-static-site:0.1.0
	docker push gcr.io/${project_id}/grafana:0.1.0

deploy-app-manifests:
	kubectl apply -f manifests/app/storage-${namespace_env}.yaml -n ${namespace_env}
	envsubst < manifests/app/manifests.yaml | kubectl apply -f - -n ${namespace_env}

delete-app-manifests:
	kubectl delete -f manifests/app/manifests.yaml -n ${namespace_env}
	kubectl delete -f manifests/app/storage-${namespace_env}.yaml -n ${namespace_env}

deploy-monitoring-manifests:
	envsubst < manifests/monitoring/grafana.yaml | kubectl apply -f - -n monitoring
	kubectl apply -f manifests/monitoring/prometheus.yaml -n monitoring

delete-monitoring-manifests:
	kubectl delete -f manifests/monitoring/grafana.yaml -n monitoring
	kubectl delete -f manifests/monitoring/prometheus.yaml -n monitoring

delete-all-manifests: delete-app-manifests delete-monitoring-manifests
