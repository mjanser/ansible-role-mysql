Vagrant.configure('2') do |config|
  config.vm.box = 'obnox/fedora23-64-lxc'

  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder '.', '/vagrant/ansible-role-mysql'

  config.vm.define 'fedora-23-mysql' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mysql-fedora-23'
    vmconfig.vm.box = 'obnox/fedora23-64-lxc'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mysql' ]
    end
  end

  config.vm.define 'fedora-23-mysql-upstream' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mysql-upstream-fedora-23'
    vmconfig.vm.box = 'obnox/fedora23-64-lxc'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mysql', 'upstream' ]
    end
  end

  config.vm.define 'fedora-23-mariadb' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mariadb-fedora-23'
    vmconfig.vm.box = 'obnox/fedora23-64-lxc'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mariadb' ]
    end
  end

  config.vm.define 'fedora-23-mariadb-upstream' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mariadb-upstream-fedora-23'
    vmconfig.vm.box = 'obnox/fedora23-64-lxc'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mariadb', 'upstream' ]
    end
  end

  config.vm.define 'debian-jessie-mysql' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mysql-debian-jessie'
    vmconfig.vm.box = 'debian/jessie64'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mysql' ]
    end
  end

  config.vm.define 'debian-jessie-mysql-upstream' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mysql-upstream-debian-jessie'
    vmconfig.vm.box = 'debian/jessie64'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mysql', 'upstream' ]
    end
  end

  config.vm.define 'debian-jessie-mariadb' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mariadb-debian-jessie'
    vmconfig.vm.box = 'debian/jessie64'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mariadb' ]
    end
  end

  config.vm.define 'debian-jessie-mariadb-upstream' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mariadb-upstream-debian-jessie'
    vmconfig.vm.box = 'debian/jessie64'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mariadb', 'upstream' ]
    end
  end

  config.vm.define 'ubuntu-trusty-mysql' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mysql-ubuntu-trusty'
    vmconfig.vm.box = 'fgrehm/trusty64-lxc'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mysql' ]
    end
  end

  config.vm.define 'ubuntu-trusty-mysql-upstream' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mysql-upstream-ubuntu-trusty'
    vmconfig.vm.box = 'fgrehm/trusty64-lxc'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mysql', 'upstream' ]
    end
  end

  config.vm.define 'ubuntu-trusty-mariadb' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mariadb-ubuntu-trusty'
    vmconfig.vm.box = 'fgrehm/trusty64-lxc'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mariadb' ]
    end
  end

  config.vm.define 'ubuntu-trusty-mariadb-upstream' do | vmconfig |
    vmconfig.vm.hostname = 'ansible-role-mariadb-upstream-ubuntu-trusty'
    vmconfig.vm.box = 'fgrehm/trusty64-lxc'

    vmconfig.vm.provision 'shell' do |s|
      s.keep_color = true
      s.path = 'tests/init.sh'
      s.args = [ 'mariadb', 'upstream' ]
    end
  end
end
