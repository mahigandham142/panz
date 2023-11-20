#!/bin/bash
sonar_scan=$(cat demo.json | grep -i status | cut -d ':' -f 3 | cut -d ',' -f 1 | tr -d '"')
if [[ $? -eq 0 ]]
then
    echo "sonar_scan_status is $sonar_scan"
else
    echo "sonar_scan_status is having errors and please check"
fi
