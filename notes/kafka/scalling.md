Single broker
prep:

- create topic
- produce message
- consume message

Scenario

1. Change replicas to 3
   a. produce message to existing topic
   b. consume message to existing topic
   c. add another consumer to existing topic
   d. create new topic

e. change konfig setting (replica, ISR, etc)
f. redo step a-d.

2. Change replicas to 3 along with kafka setting (replica, ISR, etc)
   a. produce message to existing topic
   b. consume message to existing topic
   c. add another consumer to existing topic
   d. create new topic


# finding
scalling from single broker consider as downtime
need to increase replication factor for all topic

bin/kafka-topics.sh \
  --alter \
  --topic experiment \
  --partitions 5 \
  --replication-factor 3 \
  --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
  --command-config /tmp/client-scram.properties

#  generate reassignment file

bin/kafka-reassign-partitions.sh \
  --topics-to-move-json-file /opt/kafka/topics.json \
  --broker-list "0,1,2" \
  --command-config /tmp/client-scram.properties \
  --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
  --generate

bin/kafka-reassign-partitions.sh \
  --topics-to-move-json-file /opt/kafka/topic_consumer_offset.json \
  --broker-list "0,1,2" \
  --command-config /tmp/client-scram.properties \
  --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
  --generate

# backup
```
Current partition replica assignment
{"version":1,"partitions":[{"topic":"experiment","partition":0,"replicas":[2],"log_dirs":["any"]},{"topic":"experiment","partition":1,"replicas":[2],"log_dirs":["any"]},{"topic":"experiment","partition":2,"replicas":[1],"log_dirs":["any"]},{"topic":"experiment","partition":3,"replicas":[1],"log_dirs":["any"]},{"topic":"experiment","partition":4,"replicas":[1],"log_dirs":["any"]},{"topic":"experiment-2","partition":0,"replicas":[2],"log_dirs":["any"]},{"topic":"experiment-2","partition":1,"replicas":[2],"log_dirs":["any"]},{"topic":"experiment-2","partition":2,"replicas":[2],"log_dirs":["any"]},{"topic":"experiment-2","partition":3,"replicas":[2],"log_dirs":["any"]},{"topic":"experiment-2","partition":4,"replicas":[2],"log_dirs":["any"]}]}

Proposed partition reassignment configuration
{"version":1,"partitions":[{"topic":"experiment","partition":0,"replicas":[1],"log_dirs":["any"]},{"topic":"experiment","partition":1,"replicas":[2],"log_dirs":["any"]},{"topic":"experiment","partition":2,"replicas":[0],"log_dirs":["any"]},{"topic":"experiment","partition":3,"replicas":[1],"log_dirs":["any"]},{"topic":"experiment","partition":4,"replicas":[2],"log_dirs":["any"]},{"topic":"experiment-2","partition":0,"replicas":[0],"log_dirs":["any"]},{"topic":"experiment-2","partition":1,"replicas":[1],"log_dirs":["any"]},{"topic":"experiment-2","partition":2,"replicas":[2],"log_dirs":["any"]},{"topic":"experiment-2","partition":3,"replicas":[0],"log_dirs":["any"]},{"topic":"experiment-2","partition":4,"replicas":[1],"log_dirs":["any"]}]}
```


# execute reassignment file

bin/kafka-reassign-partitions.sh \
--reassignment-json-file /opt/kafka/reassignment.json \
  --command-config /tmp/client-scram.properties \
  --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
  --execute

bin/kafka-reassign-partitions.sh \
--reassignment-json-file /opt/kafka/reassignment_consumer_offset.json \
  --command-config /tmp/client-scram.properties \
  --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
  --execute

# verify

bin/kafka-reassign-partitions.sh \
  --reassignment-json-file /opt/kafka/reassignment.json\
  --command-config /tmp/client-scram.properties \
  --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
  --verify

bin/kafka-reassign-partitions.sh \
  --reassignment-json-file /opt/kafka/reassignment_consumer_offset.json\
  --command-config /tmp/client-scram.properties \
  --bootstrap-server kafka-kafka-bootstrap.kafka-operator:9092 \
  --verify