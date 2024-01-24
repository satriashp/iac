curl -s https://raw.githubusercontent.com/coreos/prometheus-operator/master/bundle.yaml > prometheus-operator-deployment.yaml

sed -E -i '/[[:space:]]_namespace: [a-zA-Z0-9-]_$/s/namespace:[[:space:]]*[a-zA-Z0-9-]*$/namespace: monitoring/' prometheus-operator-deployment.yaml
