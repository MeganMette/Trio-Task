#!/bin/bash

# Create network
docker network create trio-task-network

# Create db volume
docker volume create trio-db-volume

# Build images
docker build -t trio-db db
docker build -t trio-flask-app flask-app

# Run database container
docker run -d \
    --network trio-task-network \
    --volume trio-db-volume:/var/lib/mysql \
    --name mysql \
    trio-db

# Run Flask app
docker run -d \
    --network trio-task-network \
    --name flask-app \
    trio-flask-app

# Run NGINX container
docker run -d \
    --network trio-task-network \
    --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf \
    -p 80:80 \
    --name nginx \
    nginx:alpine

docker ps -a

