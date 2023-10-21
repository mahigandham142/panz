#!/bin/bash
SERVICE="demo"
CLUSTER_NAME="demo"
AWS_REGION="us-east-2"

# Register a new Task definition 
aws ecs register-task-definition --family demo-new-oct --cli-input-json file://task-new.json --region $AWS_REGION

# Update Service in the Cluster
aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE --task-definition demo-new-oct --desired-count 1 --region $AWS_REGION

