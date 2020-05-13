#!/bin/bash

ROOT_PATH=$(dirname "$0")

echo "$(date) initializing swarm mode"
docker swarm init 2>/dev/null

echo "$(date) creating overlay network sky"
docker network create --driver=overlay --attachable sky && sleep 3

echo "$(date) pulling portainer 1.23.2 image"
docker pull portainer/portainer:1.23.2

echo "$(date) deploying portainer v1.23.2 [admin:qwe12345]"
docker stack deploy -c $ROOT_PATH/portainer/docker-compose.yml sky

echo "$(date) pulling elasticsearch v7.7.0 image"
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.7.0

echo "$(date) deploying elasticsearch v7.7.0"
docker stack deploy -c $ROOT_PATH/es7/docker-compose.yml sky
while true; do curl -XGET http://localhost:9200 2>/dev/null; if [ $? -eq 0 ]; then echo -e "\n$(date) elasticsearch v7.7.0 is READY!"; break; fi; printf  "."; sleep 1; done

echo "$(date) pulling oap-server v7.0.0-es7 image"
docker pull apache/skywalking-oap-server:7.0.0-es7

echo "$(date) deploying oap-server v7.0.0-es7"
docker stack deploy -c $ROOT_PATH/oap/docker-compose.yml sky
while true; do curl -XGET http://localhost:12800 2>/dev/null; if [ $? -eq 0 ]; then echo -e "\n$(date) oap-server v7.0.0-es7 is READY!"; break; fi; printf  "."; sleep 1; done

echo "$(date) pulling ui v7.0.0 image"
docker pull apache/skywalking-ui:7.0.0

echo "$(date) deploying ui v7.0.0"
docker stack deploy -c $ROOT_PATH/ui/docker-compose.yml sky
while true; do curl -XGET http://localhost:8080 2>/dev/null; if [ $? -eq 0 ]; then echo -e "\n$(date) ui v7.0.0 is READY!"; break; fi; printf  "."; sleep 1; done