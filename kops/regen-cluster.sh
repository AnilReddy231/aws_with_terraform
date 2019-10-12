#!/usr/bin/env bash

set -e -o pipefail

TF_OUTPUT=$(cd ../ && terraform output -json)
CLUSTER_NAME="$(echo ${TF_OUTPUT} | jq -r .kubernetes_cluster_name.value)"
STATE="s3://$(echo ${TF_OUTPUT} | jq -r .tfstate_bucket.value)"

kops toolbox template --name ${CLUSTER_NAME} --values <( echo ${TF_OUTPUT}) --template cluster-template.yml --format-yaml > cluster.yaml

kops replace -f cluster.yaml --state ${STATE} --name ${CLUSTER_NAME} --force

kops update cluster --target terraform --state ${STATE} --name ${CLUSTER_NAME} --out .

#kops create cluster --name=k8s-qa.anilens.com --state=s3://terraform-state-20190721003000325900000001  --node-count=2 --node-size=t2.micro --master-size=t2.micro --zones eu-west-2a,eu-west-2b --dns-zone=anilens.com --out=. --target=terraform