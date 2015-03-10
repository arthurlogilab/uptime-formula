nodejs-legacy:
  pkg.installed:
    - refresh: True

curl:
  pkg.installed

# XXX TODO : bad practice in general, this will not be necessary with jessie 
# where appropriate packages will be avaible
install npm:
  cmd.run:
    - name :  curl https://www.npmjs.com/install.sh | sh
    - unless: ls /usr/bin/npm

node-uptime:
  npm.installed:
    - require:
      - pkg: nodejs-legacy
      - cmd: install npm

/var/www/uptime/:
  file.directory:
    - makedirs: True

git:
  pkg.installed

git://github.com/fzaninotto/uptime.git:
  git.latest:
    - target: /var/www/uptime/
    - require:
      - file: /var/www/uptime/
      - pkg: git 

build-essential:
  pkg.installed

mongodb-server install:
  pkg.installed:
    - name: mongodb-server
    {% if grains['oscodename'] == 'wheezy' %}
    - fromrepo: wheezy-backports
    {% endif %}

/etc/mongodb.conf:
  file.uncomment:
    - regex: '^auth'
    - require:
       - pkg: mongodb-server

mongodb:
  service.running:
    - require:
       - pkg: mongodb-server
    - watch : 
      - file: /etc/mongodb.conf

python-pymongo:
  pkg.installed

mongodb user:
  mongodb_user.present:
    - name: {{ pillar['mongodb_user'] }}
    - passwd: {{ pillar['mongodb_password'] }} 
    - port: 27017

# if above doesn't work, type mongodb then 
# use uptime
# db.addUser('uptime', 'uptime')

install app:
  cmd.run:
    - name : npm install
    - cwd : /var/www/uptime/

deploy configuration:
  file.managed:
    - name: /var/www/uptime/config/default.yaml
    - source: salt://uptime/default.yaml
    - template: jinja

# TODO convert to supervisord
deploy initscript:
  file.managed:
    - name: /etc/init.d/uptime
    - mode: 755
    - source: salt://uptime/initscript

configure initscript:
  cmd.run:
    - name : update-rc.d uptime defaults 
    - unless: service uptime status

ensure uptime is started:
  service.running:
    - name : uptime
