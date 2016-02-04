#!/bin/bash

MYSQL_VENDOR=$1
test -n "$2" && MYSQL_ORIGIN=$2 || MYSQL_ORIGIN=distribution

ansible-playbook playbook.yml --syntax-check || exit 1

ansible-playbook playbook.yml --connection=local --extra-vars="mysql_vendor=$MYSQL_VENDOR mysql_origin=$MYSQL_ORIGIN" || exit 1

# vendor test
[ $MYSQL_VENDOR == 'mariadb' ] && { mysql --version | grep -i 'mariadb' && echo 'mariadb installed' || { echo 'not mariadb installed' && exit 1; }; }
[ $MYSQL_VENDOR == 'mysql' ] && { mysql --version | grep -i 'mariadb' && { echo 'not mysql installed' && exit 1; } || echo 'mysql installed'; }

# connection tests
mysql -e 'show databases;' 2>/dev/null | grep -q 'performance_schema' && echo 'running normally' || { echo 'not running' && exit 1; }
mysql -h 127.0.0.1 -e 'show databases;' 2>/dev/null | grep -q 'performance_schema' && echo 'running normally' || { echo 'not running' && exit 1; }

# flush privileges
#mysql -u root -proot -h 127.0.0.1 -e 'flush privileges;' &>/dev/null | { echo 'flush privileges failed' && exit 1; }

# timezone import test
mysql -NBe 'select count(*) from mysql.time_zone;' 2>/dev/null | grep -q '^[0-9]\{3,10\}$' && echo 'timezones imported' || { echo 'timezones not imported' && exit 1; }

# database creation test
mysql -e 'show databases;' 2>/dev/null | grep -q 'my_db' && echo 'database created' || { echo 'database not created' && exit 1; }

# database import test
mysql -e 'select * from my_db.my_table;' 2>/dev/null | grep -q 'entry 1' && echo 'data imported' || { echo 'data no imported' && exit 1; }

# user creation test
mysql -u my_user -p"very LONG s3cr3t password" -e 'show databases;' 2>/dev/null | grep -q 'my_db' && echo 'user created' || { echo 'user not created' && exit 1; }

ansible-playbook playbook.yml --connection=local --extra-vars="mysql_vendor=$MYSQL_VENDOR mysql_origin=$MYSQL_ORIGIN" | tee /tmp/idempotence.log
sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" /tmp/idempotence.log | grep -q "changed=0.*failed=0" \
    && echo "Idempotence test: pass" \
    || { echo "Idempotence test: fail" && exit 1; }
