# Ansible Role: mysql

An Ansible role that installs MySQL or MariaDB server on Fedora, Debian and Ubuntu.

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

### Databases

Example for database configuration:

    mysql_databases:
      - name: my_db # required
        encoding: utf8 # default
        collation: utf8_general_ci # default

You can import a dump file when the database is created using the `import_file` option.
Nothing will be imported if the database already exists.

    mysql_databases:
      - name: my_db # required
        import_file: /var/lib/backup/my_db.sql

### Users

Example for user configuration:

    mysql_users:
      - name: my_user # required
        password: secret # required
        host: "%" # default: localhost
        privileges: "my_db.*:ALL" # default: *.*:USAGE
        append_privileges: no # default

### Timezone data

Timezone data will be imported by default (see https://dev.mysql.com/doc/refman/5.7/en/mysql-tzinfo-to-sql.html).
To change this behavior adjust the option `mysql_import_timezones`.

    mysql_import_timezones: no

### Vendors and origins

This Ansible role support the installation MySQL and MariaDB from different origins.

MySQL installed from distribution repository:

    mysql_vendor: mysql
    mysql_origin: distribution

MySQL 5.6 installed from upstream repository:

    mysql_vendor: mysql
    mysql_origin: upstream
    mysql_upstream_version: 5.6

MariaDB installed from distribution repository:

    mysql_vendor: mariadb
    mysql_origin: distribution

MariaDB 10.1 installed from upstream repository:

    mysql_vendor: mariadb
    mysql_origin: upstream
    mysql_upstream_version: 10.1

## License

MIT
