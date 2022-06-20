#!/bin/bash

set -e


# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

TEST=($(for i in $(/usr/local/bin/kubectl get deploy -o wide -n $NAMESPACE | grep $IMAGE | awk {'print $1'}); do echo $i; done))
RN=($(for i in ${TEST[@]}; do /usr/local/bin/kubectl describe deployment $i -n  $NAMESPACE|grep NewReplicaSet:|awk '{print $2}'; done))
ARR=($(for i in ${RN[@]}; do /usr/local/bin/kubectl get pods -n $NAMESPACE | grep $i | awk {'print $1'}; done))
for i in ${ARR[@]}; do /usr/local/bin/kubectl delete pod $i -n $NAMESPACE; done
