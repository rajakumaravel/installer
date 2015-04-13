include:
  - mysqlserver.stop


mysql_restart:
  cmd:
    - run
    {% if 'cluster-id' in grains -%}
    {%- for mysql_status in salt['cmd.run']('service mysql status').split() -%}
      {%- if mysql_status == 'SUCCESS!' and grains['mysql-is-master'] == True %}
    - name: service mysql start --wsrep-new-cluster
      {%- elif mysql_status == 'SUCCESS!' and grains['mysql-is-master'] == False %}
    - name: service mysql start
      {%- elif mysql_status == 'ERROR!' and grains['mysql-is-master'] == True %}
    - name: service mysql start --wsrep-new-cluster
      {%- elif  mysql_status == 'ERROR!' and grains['mysql-is-master'] == False %}
    - name: service mysql start
      {%- endif -%}
    {%- endfor %}
    {%- else %}
    - name: service mysql start
    {%- endif %}
    - require:
      - sls : mysqlserver.stop
