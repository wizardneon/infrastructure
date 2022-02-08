#!/bin/bash

hostedzoneroute=$(aws route53 list-hosted-zones | grep hostedzone | cut -c32-52)

hostedzonenlb=\"$(aws route53 list-resource-record-sets --hosted-zone-id $hostedzoneroute | grep HostedZoneId | cut -c34-47)\"

nlb=\"$(kubectl get svc -n ingress-nginx | grep LoadBalancer | cut -c70-146)\"

aws route53 change-resource-record-sets \
    --hosted-zone-id /hostedzone/$hostedzoneroute\
    --change-batch \
     '{"Changes": [ { "Action": "UPSERT", "ResourceRecordSet": { "Name": "wizardneon.link", "Type": "A", "AliasTarget":{ "HostedZoneId": '$hostedzonenlb',"DNSName": '$nlb',"EvaluateTargetHealth": false} } } ]}'
