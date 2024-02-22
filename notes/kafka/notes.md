bin/kafka-topics.sh \
 --topic poc \
 --create \
 --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
 --command-config /tmp/client-scram.properties

bin/kafka-console-producer.sh \
 --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
 --topic poc \
 --producer.config /tmp/client-scram.properties

bin/kafka-console-consumer.sh \
 --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
 --topic poc \
 --from-beginning \
 --consumer.config /tmp/client-scram.properties

[2024-01-23 08:41:24,015] WARN [Producer clientId=console-producer] Got error produce response with correlation id 135 on topic-partition poc-0, retrying (2 attempts left). Error: NOT_LEADER_OR_FOLLOWER (org.apache.kafka.clients.producer.internals.Sender)
[2024-01-23 08:41:24,017] WARN [Producer clientId=console-producer] Received invalid metadata error in produce request on partition poc-0 due to org.apache.kafka.common.errors.NotLeaderOrFollowerException: For requests intended only for the leader, this error indicates that the broker is not the current leader. For requests intended for any replica, this error indicates that the broker is not a replica of the topic partition.. Going to request metadata update now (org.apache.kafka.clients.producer.internals.Sender)
[2024-01-23 08:41:24,131] WARN [Producer clientId=console-producer] Got error produce response with correlation id 137 on topic-partition poc-0, retrying (1 attempts left). Error: NOT_LEADER_OR_FOLLOWER (org.apache.kafka.clients.producer.internals.Sender)
[2024-01-23 08:41:24,133] WARN [Producer clientId=console-producer] Received invalid metadata error in produce request on partition poc-0 due to org.apache.kafka.common.errors.NotLeaderOrFollowerException: For requests intended only for the leader, this error indicates that the broker is not the current leader. For requests intended for any replica, this error indicates that the broker is not a replica of the topic partition.. Going to request metadata update now (org.apache.kafka.clients.producer.internals.Sender)
[2024-01-23 08:41:24,237] WARN [Producer clientId=console-producer] Got error produce response with correlation id 139 on topic-partition poc-0, retrying (0 attempts left). Error: NOT_LEADER_OR_FOLLOWER (org.apache.kafka.clients.producer.internals.Sender)
[2024-01-23 08:41:24,237] WARN [Producer clientId=console-producer] Received invalid metadata error in produce request on partition poc-0 due to org.apache.kafka.common.errors.NotLeaderOrFollowerException: For requests intended only for the leader, this error indicates that the broker is not the current leader. For requests intended for any replica, this error indicates that the broker is not a replica of the topic partition.. Going to request metadata update now (org.apache.kafka.clients.producer.internals.Sender)

# after change min insync replicas.

[2024-01-23 08:42:46,199] WARN [Producer clientId=console-producer] Got error produce response with correlation id 275 on topic-partition poc-0, retrying (2 attempts left). Error: NOT_ENOUGH_REPLICAS (org.apache.kafka.clients.producer.internals.Sender)
[2024-01-23 08:42:46,302] WARN [Producer clientId=console-producer] Got error produce response with correlation id 276 on topic-partition poc-0, retrying (1 attempts left). Error: NOT_ENOUGH_REPLICAS (org.apache.kafka.clients.producer.internals.Sender)
[2024-01-23 08:42:46,405] WARN [Producer clientId=console-producer] Got error produce response with correlation id 277 on topic-partition poc-0, retrying (0 attempts left). Error: NOT_ENOUGH_REPLICAS (org.apache.kafka.clients.producer.internals.Sender)
[2024-01-23 08:42:46,508] ERROR Error when sending message to topic poc with key: null, value: 1 bytes with error: (org.apache.kafka.clients.producer.internals.ErrorLoggingCallback)
org.apache.kafka.common.errors.NotEnoughReplicasException: Messages are rejected since there are fewer in-sync replicas than required.

bin/kafka-topics.sh \
 --topic experiment \
 --create \
 --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
 --command-config /tmp/client-scram.properties

bin/kafka-topics.sh \
 --topic experiment-2 \
 --create \
 --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
 --command-config /tmp/client-scram.properties

bin/kafka-topics.sh \
 --topic experiment \
 --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
 --command-config /tmp/client-scram.properties \
 --describe

bin/kafka-console-producer.sh \
 --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
 --topic experiment \
 --producer.config /tmp/client-scram.properties

bin/kafka-console-producer.sh \
 --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
 --topic experiment-2 \
 --producer.config /tmp/client-scram.properties

bin/kafka-console-consumer.sh \
 --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
 --topic experiment \
 --group group-01 \
 --from-beginning \
 --consumer.config /tmp/client-scram.properties

kubectl annotate pod -n kafka-operator kafka-kafka-0 strimzi.io/manual-rolling-update=true
kubectl annotate pod -n kafka-operator kafka-kafka-1 strimzi.io/manual-rolling-update=true
kubectl annotate pod -n kafka-operator kafka-kafka-2 strimzi.io/manual-rolling-update=true

docker pull quay.io/strimzi/kafka:0.39.0-kafka-3.5.0
docker pull quay.io/strimzi/kafka:0.39.0-kafka-3.5.1
docker pull quay.io/strimzi/kafka:0.39.0-kafka-3.5.2
docker pull quay.io/strimzi/kafka:0.39.0-kafka-3.6.0
docker pull quay.io/strimzi/kafka:0.39.0-kafka-3.6.1
docker pull quay.io/strimzi/operator:0.39.0
docker pull quay.io/strimzi/kafka-bridge:0.27.0
docker pull quay.io/strimzi/drain-cleaner:1.0.1

docker tag quay.io/strimzi/kafka:0.39.0-kafka-3.5.0 localhost:5000/kafka:0.39.0-kafka-3.5.0
docker push localhost:5000/kafka:0.39.0-kafka-3.5.0
docker tag quay.io/strimzi/kafka:0.39.0-kafka-3.5.1 localhost:5000/kafka:0.39.0-kafka-3.5.1
docker push localhost:5000/kafka:0.39.0-kafka-3.5.1
docker tag quay.io/strimzi/kafka:0.39.0-kafka-3.5.2 localhost:5000/kafka:0.39.0-kafka-3.5.2
docker push localhost:5000/kafka:0.39.0-kafka-3.5.2
docker tag quay.io/strimzi/kafka:0.39.0-kafka-3.6.0 localhost:5000/kafka:0.39.0-kafka-3.6.0
docker push localhost:5000/kafka:0.39.0-kafka-3.6.0
docker tag quay.io/strimzi/kafka:0.39.0-kafka-3.6.1 localhost:5000/kafka:0.39.0-kafka-3.6.1
docker push localhost:5000/kafka:0.39.0-kafka-3.6.1
docker tag quay.io/strimzi/operator:0.39.0 localhost:5000/operator:0.39.0
docker push localhost:5000/operator:0.39.0
docker tag quay.io/strimzi/kafka-bridge:0.27.0 localhost:5000/kafka-bridge:0.27.0
docker push localhost:5000/kafka-bridge:0.27.0
docker tag quay.io/strimzi/drain-cleaner:1.0.1 localhost:5000/drain-cleaner:1.0.1
docker push localhost:5000/drain-cleaner:1.0.1
