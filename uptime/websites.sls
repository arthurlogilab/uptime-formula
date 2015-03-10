{% for domain in salt['pillar.get']('apache:sites').keys() %}
uptime {{ domain }} (http):
  uptime.monitored:
    - name : http://{{ domain }}
{% endfor %}
{% for url in salt['pillar.get']('uptime:urls') %}
uptime {{ url }}:
  uptime.monitored:
    - name : {{ url }}
    {% if 'sitemap.xml' in url %}
    - interval: 3600
    - tags: sitemap
    {% endif %}
{% endfor %}