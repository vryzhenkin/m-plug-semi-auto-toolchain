#!/usr/bin/env bash

set -x

export WORKSPACE=$(pwd)

wget -qO- https://get.docker.com/ | sh

sudo -H docker build -t rally-tempest "$WORKSPACE/rally-tempest/latest"

CONTAINER_MOUNT_HOME_DIR="${CONTAINER_MOUNT_HOME_DIR:-/var/lib/rally-tempest-container-home-dir}"
KEYSTONE_API_VERSION="v2.0"
CA_CERT_PATH="/var/lib/astute/haproxy/public_haproxy.pem"

if [ ! -d ${CONTAINER_MOUNT_HOME_DIR} ]; then
    mkdir ${CONTAINER_MOUNT_HOME_DIR}
fi
chown 65500 ${CONTAINER_MOUNT_HOME_DIR}

cp /root/openrc ${CONTAINER_MOUNT_HOME_DIR}/
chown 65500 ${CONTAINER_MOUNT_HOME_DIR}/openrc
echo "export HTTP_PROXY='$CONTROLLER_PROXY_URL'" >> ${CONTAINER_MOUNT_HOME_DIR}/openrc
echo "export HTTPS_PROXY='$CONTROLLER_PROXY_URL'" >> ${CONTAINER_MOUNT_HOME_DIR}/openrc

IS_TLS=`. openrc; openstack endpoint show identity 2>/dev/null | awk '/https/'`

if [ "${IS_TLS}" ]; then
    cp ${CA_CERT_PATH} ${CONTAINER_MOUNT_HOME_DIR}/
    chown 65500 ${CONTAINER_MOUNT_HOME_DIR}/$(basename ${CA_CERT_PATH})
    echo "export OS_CACERT='/home/rally/$(basename ${CA_CERT_PATH})'" >> ${CONTAINER_MOUNT_HOME_DIR}/openrc
fi

cat > ${CONTAINER_MOUNT_HOME_DIR}/bashrc <<EOF
test "\${PS1}" || return
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
alias ls=ls\ --color=auto
alias ll=ls\ --color=auto\ -lhap
echo \${PATH} | grep ":\${HOME}/bin" >/dev/null || export PATH="\${PATH}:\${HOME}/bin"
if [ \$(id -u) -eq 0 ]; then
    export PS1='\[\033[01;41m\]\u@\h:\[\033[01;44m\] \W \[\033[01;41m\] #\[\033[0m\] '
else
    export PS1='\[\033[01;33m\]\u@\h\[\033[01;0m\]:\[\033[01;34m\]\W\[\033[01;0m\]$ '
fi
source /home/rally/openrc
EOF

ID=$(docker images | awk '/rally/ {print $3}')
echo "LOG: INFO rally image id=$ID"

docker rm $(docker ps -aq)

sudo -H docker save -o "$WORKSPACE/dimage" rally-tempest

sudo mv "$WORKSPACE/dimage" /root/rally

docker rmi $ID

docker load -i /root/rally
ID=$(docker images | awk '/rally/ {print $3}')

echo "LOG: INFO rally image id=$ID"
export DOCK_ID=$(docker run -tid -v /var/lib/rally-tempest-container-home-dir:/home/rally --net host "$ID")

sed -i "s|:5000|:5000/v2.0|g" /var/lib/rally-tempest-container-home-dir/openrc
docker exec -u root "$DOCK_ID" sed -i "s|\#swift_operator_role = Member|swift_operator_role=SwiftOperator|g" /etc/rally/rally.conf
docker exec "$DOCK_ID" setup-tempest
tempest_file=$(find / -name tempest.conf)
sed -i "79i max_template_size = 5440000" $tempest_file
sed -i "80i max_resources_per_stack = 20000" $tempest_file
sed -i "81i max_json_body_size = 10880000" $tempest_file
sed -i "24i volume_device_name = vdc" $tempest_file

echo "LOG: INFO tempest file $tempest_file"
echo "You should add [service available] group manually. (murano, murano_cfapi, glare). and [application_catalog], [service_broker]"
echo "Use this command to execute tests: docker exec "$DOCK_ID" bash -c \"source /home/rally/openrc && rally verify start --regex application_catalog --concurrency 2\""

