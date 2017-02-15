# Ansible Role: mysql

An Ansible role that installs MySQL or MariaDB server on Fedora, Debian and Ubuntu.

Upstream versions of MySQL will be installed from https://dev.mysql.com/downloads/repo/apt/ for Debian and Ubuntu
and from https://dev.mysql.com/downloads/repo/yum/ for Fedora.

For upstream MariaDB the repositories from https://downloads.mariadb.org/mariadb/repositories/ will be used.

## Requirements

For configuring the firewall the service `firewalld` has to run and the package `python-firewall` needs to be installed.

## Role Variables

Available variables are listed below, along with default values:

    mysql_vendor: mysql
    mysql_origin: distribution
    mysql_upstream_version: ~ # MariaDB: 10.1, MySQL: 5.7

    mysql_root_password: "My $3cr3t password"

    mysql_import_timezones: yes

    mysql_bind_address: 0.0.0.0

    mysql_key_buffer_size: 256M
    mysql_max_allowed_packet: 1M
    mysql_table_open_cache: 256
    mysql_sort_buffer_size: 1M
    mysql_read_buffer_size: 1M
    mysql_read_rnd_buffer_size: 4M
    mysql_net_buffer_length: 1M
    mysql_myisam_sort_buffer_size: 64M
    mysql_thread_cache_size: 8
    mysql_query_cache_size: 16M

    mysql_max_connections: ~
    mysql_thread_concurrency: ~

    mysql_ssl_ca: ~
    mysql_ssl_cert: ~
    mysql_ssl_key: ~

    mysql_custom_config: ~

    mysql_firewall_zones: []

    mysql_databases: []
    mysql_users: []

### Vendor and origin

This Ansible role supports the installation of MySQL and MariaDB from distribution or upstream packages.

The vendor can be set in the variable `mysql_vendor`, which supports the values `mysql` and `mariadb`.
The default vendor is `mysql`.

The variable `mysql_origin` defines where the packages come from.
The default value `distribution` means that the packages from the distribution will be installed.
With this configuration the distribution defines the version and cannot be changed.

If the variable `mysql_origin` is set to `upstream` the package from MySQL/MariaDB will be installed.
This is done using the repositories from https://downloads.mariadb.org/mariadb/repositories/.
In this setup the version can be specified in the variable `mysql_upstream_version`.

### Root user

The password defined in the variable `mysql_root_password` will be set as the root password during installation.
This should be changed to a secure password.

The root user will only be able to connect from the local host. All remote host entries will be removed.

Additionally the anonymous users and the test database will be removed.

### Timezone import

Timezone data will be imported by default (see https://dev.mysql.com/doc/refman/5.7/en/mysql-tzinfo-to-sql.html).
To change this behavior adjust the variable `mysql_import_timezones` to `no`.

### Networking

By default the server listens on all IPv4 interfaces on the host.
This can changed with setting the variable `mysql_bind_address` to another address than `0.0.0.0`.

### Options

There are some options which can be adjusted and have default values.
See above or in defaults/tasks.yml and the documentation for more information.

### SSL

To enable SSL support the variables `mysql_ssl_ca`, `mysql_ssl_cert` and `mysql_ssl_key` must be configured.

### Custom configuration

Additional configuration can be defined in the variable `mysql_custom_config`, for example:

    mysql_custom_config: |
                         skip_name_resolve
                         skip-locking

### Firewall

The variable `mysql_firewall_zones` can be used to declare firewall zones in which nginx should be accessible.
This means the ports `3306/tcp` will be opened.

Currently only `firewalld` is supported which is default on Fedora.

### Databases

Databases to create can be defined in the variable `mysql_databases`.
Possible values for each entry in `mysql_databases` are, along with default values:

    name: ~
    collation: utf8_general_ci
    encoding: utf8
    import_file: ~

#### Name

In the key `name` you can set the name of the database.

#### Collation and encoding

To adjust the collection and encoding, you can set them in `collaction` and `encoding`.

#### Import

There is the possibility to set a path to an SQL file in `import_file` which will be imported after creating the database.
This can be used for importing backups.

If the database already exists, nothing will be imported.

### Users

Database users can be defined in the variable `mysql_users`.
Possible values for each entry in `mysql_users` are, along with default values:

    name: ~
    password: ~
    host: localhost
    privileges: "*.*:USAGE"
    append_privileges: no

#### Credentials

The keys `name` and `password` define the credentials of the user.
The user can only access the server from the host set in `host`. A value of `%` will allow it from every host.

#### Privileges

Privileges can be defined in `privileges` as a string, see MySQL or MariaDB manual for more information.
If `append_privileges` is set to `yes`, the defined privileges will be appended to the already existing ones.

## Dependencies

None

## Example Playbook

    - hosts: all
      roles:
        - { role: mjanser.mysql }
      vars:
        mysql_root_password: secret
        mysql_databases:
          - name: my_db
        mysql_users:
          - name: my_user
            password: secret
            privileges: "my_db.*:ALL"

## License

MIT
