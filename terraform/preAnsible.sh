#!/bin/bash
terraform output

# get terraform clean outputs
elbDns=$(terraform output elbDns)
elbIp=$(host $elbDns | head -n 1 | awk '{print $4}')
mysqlDns=$(terraform output mysqlDns)
mysqlIp=$(host $mysqlDns | awk '{print $4}')
ubuntuIp=$(terraform output ubuntuIp)
ubuntuIpPrivate=$(terraform output ubuntuIpPrivate)
dbPass=$(terraform output dbPass)
dbUname=$(terraform output dbUname)

## ansible preparing
# write instance ip
echo $ubuntuIp >> ../ansible/hosts.inf

# install python
ssh -i ../keywptest.pem ubuntu@$ubuntuIp \
'sudo apt update && sudo apt install -y python-minimal'

# write db infos
ansbileMysqlPath="../ansible/roles/mysql/tasks/main.yml"
sed -i "s/wordpress/wpmysql/" $ansbileMysqlPath
sed -i "s/wpuser/$dbUname/" $ansbileMysqlPath
sed -i "s/wppass/$dbPass/" $ansbileMysqlPath
sed -i "s/sedhst/$mysqlIp/" $ansbileMysqlPath

#write elb ip
echo $elbIp > elbIp.txt
