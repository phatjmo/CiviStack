#!/bin/bash
DIR="/var/www/html"
DBHOST="${DBHOST:-mariadb}"
DBNAME="${DBNAME:-wordpress}"
DBUSER="${DBUSER:-root}"
DBPASS="${DBPASS:-password}"
SITETITLE="${SITETITLE:-devsite}"
SITEUSER="${SITEUSER:-admin}"
SITEPASS="${SITEPASS:-password}"
SITEEMAIL="${SITEEMAIL:-dev@dev.dev}"
DOCKER_IP=$(echo $DOCKER_HOST | cut -d/ -f3- | cut -d: -f1)
#DOCKER_IP=$(shell if [ -n "$DOCKER_HOST" ]; then echo $DOCKER_HOST | cut -d/ -f3- | cut -d: -f1 ; elif [ -n "$DOCKER_IP" ] ; then echo "$DOCKER_IP" ; else docker run --rm --net host alpine ip a show dev eth0 | grep inet | cut -d/ -f1 | sed -e 's/^.*inet //' ; fi)
#SITE="http://$DOCKER_IP"
SITE="$DOCKER_IP"
SITEURL="http://$DOCKER_IP"

if [ "$(ls -A $DIR)" ] ; then
    echo "Looks like $DIR is not empty, not installing"
else
    cp -R /usr/src/wordpress/* $DIR && \
      chown -R www-data:www-data $DIR && \
	  sudo -u www-data -- wp core config --dbname=$DBNAME --dbuser=$DBUSER --dbpass=$DBPASS --dbhost=$DBHOST --path=$DIR && \
      #sudo -u www-data -- wp db create --path=$DIR && \
      sudo -u www-data -- wp core install --url=$SITE --title=$SITETITLE --admin_user=$SITEUSER --admin_password=$SITEPASS --admin_email=$SITEEMAIL --path=$DIR && \
	  sudo -u www-data -- wp option update home "$SITEURL" && \
      sudo -u www-data -- wp option update siteurl "$SITEURL" && \
      wget https://download.civicrm.org/civicrm-4.7.6-wordpress.zip && \
	  mkdir -p $DIR/wp-content/plugins  && \
	  mv civicrm-4.7.6-wordpress.zip $DIR/wp-content/plugins/civicrm-4.7.6-wordpress.zip  && \
	  unzip $DIR/wp-content/plugins/civicrm-4.7.6-wordpress.zip -d $DIR/wp-content/plugins
fi
