#!/bin/bash
aws route53 list-hosted-zones | grep hostedzone > 1.txt && cat 1.txt
hostedzoneroute=$(sed -e "s/^.\{,31\}//;s/.\{,2\}$//" 1.txt)
echo $ hostedzoneroute
aws route53 list-resource-record-sets --hosted-zone-id $hostedzoneroute
aws route53 list-resource-record-sets --hosted-zone-id $hostedzoneroute | grep HostedZoneId > 2.txt
cat 2.txt
hostedzonenlb=\"$(sed -e "s/^.\{,33\}//;s/.\{,2\}$//" 2.txt)\"
echo $hostedzonenlb
kubectl get svc -n ingress-nginx | grep amazonaws | awk '{ print $4 }'
nlb=\"$(kubectl get svc -n ingress-nginx | grep amazonaws | awk '{ print $4 }')\"
echo $nlb
aws route53 change-resource-record-sets \
    --hosted-zone-id /hostedzone/$hostedzoneroute\
    --change-batch \
     '{"Changes": [ { "Action": "UPSERT", "ResourceRecordSet": { "Name": "wizardneon.link", "Type": "A", "AliasTarget":{ "HostedZoneId": '$hostedzonenlb',"DNSName": '$nlb',"EvaluateTargetHealth":
false} } } ]}'
