#!/bin/bash
repo_name=demo
image_tag=SAMPLE-PROJECT-${BUILD_NUMBER}
arn=arn:aws:sns:ap-south-1:207203418893:sample
critical_vulnr=$(aws ecr describe-image-scan-findings --repository-name $repo_name --image-id imageTag=$image_tag | grep -i "findingSeverityCounts" -A 5 | grep -i critical | cut -d ":" -f 2 | tr -d ",")
high_vulnr=$(aws ecr describe-image-scan-findings --repository-name $repo_name --image-id imageTag=$image_tag | grep -i "findingSeverityCounts" -A 5 | grep -i high | cut -d ":" -f 2 | tr -d ",")

if [ -z "$critical_vulnr" ]
then
        critical_vulnr=0
fi

if [ -z "$high_vulnr" ]
then
        high_vulnr=0
fi

echo "High vulnerabilities: $high_vulnr"
echo "Critical vulnerabilities: $critical_vulnr"

if [[ $high_vulnr -gt 0 && $critical_vulnr -ge 0 ]]
then
   echo "your image is having higher vulnerabilities,please check...." && aws sns publish --topic-arn $arn --message "your image in this $repo_name repo in this $image_tag image is having higher vulnerabilities,please check..."
    exit 1
else
    echo "your image is safe for deployment"
fi
