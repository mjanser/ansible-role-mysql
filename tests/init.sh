#!/bin/bash

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=1
export DEBIAN_FRONTEND=noninteractive

if ! which ansible &>/dev/null; then
    if which dnf &>/dev/null; then
        echo "Installing Ansible"
        dnf install --enablerepo updates-testing -q -y ansible python-dnf >/dev/null || exit 1
    else
        echo "Installing Ansible"
        apt-get update -qq >/dev/null
        apt-get install -qq python-pip python-markupsafe python-ecdsa libpython-dev >/dev/null || exit 1
        apt-get upgrade -qq tzdata >/dev/null

        pip install ansible >/dev/null || exit 1

        mkdir /etc/ansible
    fi
fi


cd /vagrant/ansible-role-mysql/tests

echo "127.0.0.1" > /etc/ansible/hosts
echo "localhost" > /etc/ansible/inventory
echo -e "[defaults]\nroles_path = /vagrant" > /etc/ansible/ansible.cfg

. test.sh $@
