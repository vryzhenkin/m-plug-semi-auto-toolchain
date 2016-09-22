#!/usr/bin/env bash

puppet apply --modulepath=/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/murano_hiera_override.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"
puppet apply --modulepath=/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/pin_murano_plugin_repo.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"
puppet apply --modulepath=modules:/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/murano.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"
puppet apply --modulepath=modules:/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/murano_rabbitmq.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"
puppet apply --modulepath=modules:/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/murano_cfapi.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"
puppet apply --modulepath=modules:/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/murano_keystone.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"
puppet apply --modulepath=modules:/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/murano_db.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"
puppet apply --modulepath=modules:/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/murano_dashboard.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"
puppet apply --modulepath=modules:/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/import_murano_package.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"
puppet apply --modulepath=/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/murano_logging.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"
puppet apply --modulepath=/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/update_openrc.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"
puppet apply --modulepath=/etc/puppet/modules/ /etc/fuel/plugins/detach-murano-1.0/manifests/murano_haproxy.pp -d --detailed-exitcodes; echo $? && echo "_______" && echo "EXIT CODE ^" && echo "_______"