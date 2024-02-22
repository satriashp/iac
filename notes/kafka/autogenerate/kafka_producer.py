import os
from confluent_kafka import Producer
from essential_generators import DocumentGenerator
import json
import random
import time

# Kafka configuration
bootstrap_servers = os.environ.get('KAFKA_BOOTSTRAP_SERVERS', 'kafka-kafka-bootstrap.kafka-operator:9092')  # Replace with your Kafka bootstrap servers
topic = os.environ.get('KAFKA_TOPIC', 'experiment')  # Replace with your Kafka topic
security_protocol = 'SASL_SSL'
sasl_mechanism = 'SCRAM-SHA-512'
sasl_username = os.environ.get('KAFKA_USERNAME', 'accelbyte')
sasl_password = os.environ.get('KAFKA_PASSWORD', 'password')
truststore_location = os.environ.get('KAFKA_TRUSTSTORE_LOCATION', 'path/to/truststore.jks')
truststore_password = os.environ.get('KAFKA_TRUSTSTORE_PASSWORD', 'your_default_truststore_password')
ssl_ca_location = os.environ.get('KAFKA_CA_LOCATION', 'path/to/ca-cert.pem') # Replace with the path to your CA certificate file

# Create Kafka producer
conf = {
    'bootstrap.servers': bootstrap_servers,
    'security.protocol': security_protocol,
    'sasl.mechanism': sasl_mechanism,
    'sasl.username': sasl_username,
    'sasl.password': sasl_password,
    # 'ssl.truststore.location': truststore_location,
    # 'ssl.truststore.password': truststore_password,
    'ssl.ca.location': ssl_ca_location,
}
producer = Producer(conf)

def delivery_report(err, msg):
    if err is not None:
        print('Message delivery failed: {}'.format(err))
    else:
        print('Message delivered to {} [{}]'.format(msg.topic(), msg.partition()))

def send_random_message():
    # Generate a random message
    gen = DocumentGenerator()
    message = gen.sentence()

    # Convert message to JSON format
    message_json = json.dumps(message)

    # Produce the message to the Kafka topic
    # producer.produce(topic, key='random_key', value=message_json, callback=delivery_report)
    producer.produce(topic, value=message_json, callback=delivery_report)

    # Wait for any outstanding messages to be delivered and delivery reports to be received
    producer.poll(0)

if __name__ == '__main__':
    try:
        while True:
            send_random_message()
            time.sleep(1)  # Wait for 1 second before sending the next message

    except KeyboardInterrupt:
        pass
    finally:
        # Close the Kafka producer
        producer.flush()
