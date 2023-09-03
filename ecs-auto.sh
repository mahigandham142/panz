#!/bin/bash
SERVICE="demo"
CLUSTER_NAME="demo"
AWS_REGION="ap-south-1"
export AWS_PROFILE=default

# Register a new Task definition 
aws ecs register-task-definition --family demo --cli-input-json file://task-new.json --region $AWS_REGION

# Update Service in the Cluster
aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE --task-definition demo --desired-count 1 --region $AWS_REGION

