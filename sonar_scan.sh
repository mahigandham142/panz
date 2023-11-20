#!/bin/bash
curl -u admin:Mahi@123  http://af92004913f324520ba8606446672f5d-467569492.us-east-2.elb.amazonaws.com:9000/api/qualitygates/project_status?projectKey=sonar > demo.json
sonar_scan=$(cat demo.json | grep -i status | cut -d ':' -f 3 | cut -d ',' -f 1 | tr -d '"')
if [[ sonar_scan -eq ok ]]
then
    echo "sonar_scan_status is $sonar_scan"
else
    echo "sonar_scan_status is having errors and please check"
fi
