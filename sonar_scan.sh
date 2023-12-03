#!/bin/bash
curl -u admin:mahesh@123  http://a73651e2fcb4a4f08acea3340884f16a-951601558.us-east-2.elb.amazonaws.com:9000/api/qualitygates/project_status?projectKey=dotnet-app > demo.json
sonar_scan=$(cat demo.json | grep -i status | cut -d ':' -f 3 | cut -d ',' -f 1 | tr -d '"')
if [[ sonar_scan -eq ok ]]
then
    echo "sonar_scan_status is $sonar_scan"
else
    echo "sonar_scan_status is having errors and please check"
    exit 1
fi
