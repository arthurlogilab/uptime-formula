======
uptime
======

Formulas to set up and configure an uptime server.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``uptime``
----------

Installs the uptime server and starts the service.

``uptime.websites``
-------------------

Monitors URLs found in pillars. Used with `apache-formula
<https://github.com/saltstack-formulas/apache-formula>`_ it will
monitor all the domains deployed by apache (described in your
pillars).

``uptime.websites``
-------------------

Deploy an nginx server in front of uptime

Pillars
=======

Example Pillar:

.. code:: yaml

  mongodb_user: uptime
  mongodb_password: uptime
  # optional webpagetest api key
  #webpagetest_key: 1234567

  # optional for uptime.nginx
  #uptime_server_name: uptime.example.org


To add some monitored URLs:

.. code:: yaml

  uptime:
    application_url: http://localhost:5000
    urls: 
      - http://example.org/
      - http://example.com/

With the uptime state (see websites.sls): 

.. code:: yaml

  {% for url in salt['pillar.get']('uptime:urls') %}
  uptime {{ url }}:
    uptime.monitored:
      - name : {{ url }}
  {% endfor %}
