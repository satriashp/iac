import os
import random
import string
from kafka import KafkaProducer
from kafka.errors import KafkaError
import ssl

# Kafka broker configurations
bootstrap_servers = os.environ.get('KAFKA_BOOTSTRAP_SERVERS', 'kafka-kafka-bootstrap.kafka-operator:9092')  # Replace with your Kafka bootstrap servers
topic = os.environ.get('KAFKA_TOPIC', 'experiment')  # Replace with your Kafka topic
username = os.environ.get('KAFKA_USERNAME', 'accelbyte')
password = os.environ.get('KAFKA_PASSWORD', 'password')

ssl_ca_location = os.environ.get('KAFKA_CA_LOCATION', 'path/to/ca-cert.pem') # Replace with the path to your CA certificate file

# Function to generate a random string
def generate_random_string(length=10):
    letters = string.ascii_letters
    return ''.join(random.choice(letters) for _ in range(length))

# Function to send message to Kafka
def send_message(producer, topic, message):
    try:
        producer.send(topic, message.encode('utf-8'))
        producer.flush()  # Ensure the message is sent immediately
        print("Sent message:", message)
    except KafkaError as e:
        print("Failed to send message:", e)

# Main function
def main():
    # Kafka producer configuration
    producer_config = {
        'bootstrap_servers': bootstrap_servers,
        'security_protocol': 'SASL_SSL',
        'sasl_mechanism': 'SCRAM-SHA-512',
        'ssl_context': ssl.create_default_context(cafile=ssl_ca_location),
        'sasl_plain_username': username,
        'sasl_plain_password': password
    }

    # Create Kafka producer
    producer = KafkaProducer(**producer_config)

    try:
        # Send messages in a loop
        while True:
            # Generate a random message
            message = generate_random_string()

            # Send the message to Kafka
            send_message(producer, topic, message)

    except KeyboardInterrupt:
        # Close the Kafka producer when the program is interrupted
        producer.close()

if __name__ == "__main__":
    main()
