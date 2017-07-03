Vagrant.configure('2') do |config|
  config.vm.box = 'mjanser/fedora25-64-lxc'

  config.vm.define 'mysql-dist-fedora-25' do | vmconfig |
    vmconfig.vm.hostname = 'mysql-dist-fedora-25'
    vmconfig.vm.box = 'mjanser/fedora25-64-lxc'
  end

  config.vm.define 'mysql-upstream-fedora-25' do | vmconfig |
    vmconfig.vm.hostname = 'mysql-upstream-fedora-25'
    vmconfig.vm.box = 'mjanser/fedora25-64-lxc'
  end

  config.vm.define 'mariadb-dist-fedora-25' do | vmconfig |
    vmconfig.vm.hostname = 'mariadb-dist-fedora-25'
    vmconfig.vm.box = 'mjanser/fedora25-64-lxc'
  end

  config.vm.define 'mariadb-upstream-fedora-25' do | vmconfig |
    vmconfig.vm.hostname = 'mariadb-upstream-fedora-25'
    vmconfig.vm.box = 'mjanser/fedora25-64-lxc'
  end

  config.vm.define 'mysql-upstream-debian-stretch' do | vmconfig |
    vmconfig.vm.hostname = 'mysql-upstream-debian-stretch'
    vmconfig.vm.box = 'debian/stretch64'
  end

  config.vm.define 'mariadb-dist-debian-stretch' do | vmconfig |
    vmconfig.vm.hostname = 'mariadb-dist-debian-stretch'
    vmconfig.vm.box = 'debian/stretch64'
  end

  config.vm.define 'mariadb-upstream-debian-stretch' do | vmconfig |
    vmconfig.vm.hostname = 'mariadb-upstream-debian-stretch'
    vmconfig.vm.box = 'debian/stretch64'
  end

  config.vm.define 'mysql-dist-ubuntu-xenial' do | vmconfig |
    vmconfig.vm.hostname = 'mysql-dist-ubuntu-xenial'
    vmconfig.vm.box = 'nhinds/xenial64'
  end

  config.vm.define 'mysql-upstream-ubuntu-xenial' do | vmconfig |
    vmconfig.vm.hostname = 'mysql-upstream-ubuntu-xenial'
    vmconfig.vm.box = 'nhinds/xenial64'
  end

  config.vm.define 'mariadb-dist-ubuntu-xenial' do | vmconfig |
    vmconfig.vm.hostname = 'mariadb-dist-ubuntu-xenial'
    vmconfig.vm.box = 'nhinds/xenial64'
  end

  config.vm.define 'mariadb-upstream-ubuntu-xenial' do | vmconfig |
    vmconfig.vm.hostname = 'mariadb-upstream-ubuntu-xenial'
    vmconfig.vm.box = 'nhinds/xenial64'
  end

  config.vm.provision 'ansible_local' do |ansible|
    ansible.playbook = 'playbook.yml'
    ansible.groups = {
        'mysql' => [
            'mysql-dist-fedora-25',
            'mysql-upstream-fedora-25',
            'mysql-dist-debian-stretch',
            'mysql-dist-ubuntu-xenial',
            'mysql-upstream-ubuntu-xenial',
        ],
        'mysql:vars' => {'mysql_vendor' => 'mysql'},
        'mariadb' => [
            'mariadb-dist-fedora-25',
            'mariadb-upstream-fedora-25',
            'mariadb-dist-debian-stretch',
            'mariadb-upstream-debian-stretch',
            'mariadb-dist-ubuntu-xenial',
            'mariadb-upstream-ubuntu-xenial',
        ],
        'mariadb:vars' => {'mysql_vendor' => 'mariadb'},
        'dist' => [
            'mysql-dist-fedora-25',
            'mariadb-dist-fedora-25',
            'mariadb-dist-debian-stretch',
            'mysql-dist-ubuntu-xenial',
            'mariadb-dist-ubuntu-xenial',
        ],
        'dist:vars' => {'mysql_origin' => 'distribution'},
        'upstream' => [
            'mysql-upstream-fedora-25',
            'mariadb-upstream-fedora-25',
            'mysql-upstream-debian-stretch',
            'mariadb-upstream-debian-stretch',
            'mysql-upstream-ubuntu-xenial',
            'mariadb-upstream-ubuntu-xenial',
        ],
        'upstream:vars' => {'mysql_origin' => 'upstream'}
    }
    ansible.sudo = true
  end

  config.vm.provision 'shell' do |s|
    s.keep_color = true
    s.inline = <<SCRIPT
MYSQL_VENDOR=$(hostname | cut -d- -f1)

# vendor test
[ $MYSQL_VENDOR == 'mariadb' ] && { mysql --version | grep -i 'mariadb' && echo 'mariadb installed' || { echo 'not mariadb installed' && exit 1; }; }
[ $MYSQL_VENDOR == 'mysql' ] && { mysql --version | grep -i 'mariadb' && { echo 'not mysql installed' && exit 1; } || echo 'mysql installed'; }
mysql --version

# connection tests
mysql -e 'show databases;' 2>/dev/null | grep -q 'performance_schema' && echo 'running normally through socket' || { echo 'not running through socket' && exit 1; }
mysql -h 127.0.0.1 -e 'show databases;' 2>/dev/null | grep -q 'performance_schema' && echo 'running normally through network' || { echo 'not running through network' && exit 1; }

# timezone import test
mysql -NBe 'select count(*) from mysql.time_zone;' 2>/dev/null | grep -q '^[0-9]\\{3,10\\}$' && echo 'timezones imported' || { echo 'timezones not imported' && exit 1; }

# database creation test
mysql -e 'show databases;' 2>/dev/null | grep -q 'my_db' && echo 'database created' || { echo 'database not created' && exit 1; }

# database import test
mysql -e 'select * from my_db.my_table;' 2>/dev/null | grep -q 'entry 1' && echo 'data imported' || { echo 'data not imported' && exit 1; }

# user creation test
mysql -u my_user -p"very LONG s3cr3t password" -e 'show databases;' 2>/dev/null | grep -q 'my_db' && echo 'user created' || { echo 'user not created' && exit 1; }

# backup test
/usr/local/bin/mysql-backup && echo 'backup created' || { echo 'backup failed' && exit 1;}

cd /vagrant/
ansible-playbook playbook.yml --limit $(hostname) --inventory-file /tmp/vagrant-ansible/inventory/vagrant_ansible_local_inventory 2>&1 | tee /tmp/ansible.log

# Remove colors from log file
sed -i -r "s/\\x1B\\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" /tmp/ansible.log

# Test for errors
test -n "$(grep -L 'ERROR' /tmp/ansible.log)" \
    && { echo "Errors test: pass"; } \
    || { echo "Errors test: fail" && exit 1; }

# Test for warnings
test -n "$(grep -L 'WARNING' /tmp/ansible.log)" \
    && { echo "Warnings test: pass"; } \
    || { echo "Warnings test: fail" && exit 1; }

# Test for idempotence
grep -q "changed=0.*failed=0" /tmp/ansible.log \
    && { echo "Idempotence test: pass"; } \
    || { echo "Idempotence test: fail" && exit 1; }

ansible-playbook playbook.yml --limit $(hostname) --inventory-file /tmp/vagrant-ansible/inventory/vagrant_ansible_local_inventory --check 2>&1 | grep -q "changed=0.*failed=0" \
    && { echo "Check mode: pass"; } \
    || { echo "Check mode: fail" && exit 1; }

SCRIPT
  end
end
