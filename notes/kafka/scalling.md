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
