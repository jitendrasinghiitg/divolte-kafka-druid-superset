# A proof of concept for Click Stream Collection Process using Divolte, Kafka, Druid and Superset 

Please refer to the blogpost for more information: https://blog.godatadriven.com/divolte-kafka-druid-superset


### Steps to set up the APP
Module itself is a dockerised container. Docker has been setup for Divolte, Kafka, Druid and Superset. 

Steps to get things working
1. Install Docker on host machine
2. Run : sh start.sh
3. Run curl command to tell druid to listen on the Kafka topic


Make sure when you are doing so both the ports mentioned in docker-compose should be free.

### App Urls
**DEVOLTE_URL :** `http://<your_IP_or_URL>:8290`

**SUPERSET_URL :** `http://<your_IP_or_URL>:8088`

**DRUID_URL :** `http://<your_IP_or_URL>:8081`

**KAFKA_URL:** `http://<your_IP_or_URL>:9092`


**Curl command to tell Druid to listen on the Kafka topic :**<br>
```bash
curl -X POST \
     http://localhost:8081/druid/indexer/v1/supervisor \
     -H 'Content-Type: application/json'  \
     -d @supervisor-spec.json 
```

#### Superset Admin Login credentials
username: <b>admin</b> 

password: <b>admin</b>

these can be updated in docker-compose.yml