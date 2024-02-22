#!/usr/bin/env bash

NAMESPACE="default"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

userpassword=$( kubectl -n $NAMESPACE get secrets/accelbyte --template='{{ index .data "password" | base64decode}}' )
truststorepassword=$( kubectl -n $NAMESPACE get secrets/kafka-cluster-ca-cert --template='{{ index .data "ca.password" | base64decode}}' )

tmp_yaml="$(mktemp).yaml"
sed "s|kafkauserpassword|${userpassword}|g" $SCRIPT_DIR/configmap.yaml > $tmp_yaml
tmp2_yaml="$(mktemp).yaml"
sed "s|ssltruststorepassword|${truststorepassword}|g" $tmp_yaml > $tmp2_yaml

# configmap
kubectl apply -n $NAMESPACE -f $tmp2_yaml

# kubectl apply -n $NAMESPACE -f $SCRIPT_DIR/kafka-producer.yaml
# kubectl apply -n $NAMESPACE -f $SCRIPT_DIR/kafka-consumer.yaml

kubectl apply -n $NAMESPACE -f $SCRIPT_DIR/kafka-client.yaml

# kubectl apply -n $NAMESPACE -f $SCRIPT_DIR/kafka-producer-generator-configmap.yaml
# kubectl apply -n $NAMESPACE -f $SCRIPT_DIR/kafka-producer-generator.yaml

kubectl apply -n $NAMESPACE -f $SCRIPT_DIR/kafka-lightweight-configmap.yaml
kubectl apply -n $NAMESPACE -f $SCRIPT_DIR/kafka-lightweight.yaml
