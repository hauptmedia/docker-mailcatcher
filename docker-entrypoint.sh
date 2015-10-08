#!/bin/bash

MAILCATCHER_HOSTNAME=$(hostname)
MAILCATCHER_USERNAME=${MAILCATCHER_USERNAME:-mailcatcher}
MAILCATCHER_PASSWORD=${MAILCATCHER_PASSWORD:-mailcatcher}

CRYPTED_PASSWORD=$(perl -e 'print crypt($ARGV[0], "password")' $MAILCATCHER_PASSWORD)
mkdir /home/$MAILCATCHER_USERNAME
useradd --shell /bin/sh -d /home/$MAILCATCHER_USERNAME --password $CRYPTED_PASSWORD $MAILCATCHER_USERNAME
chown -R $MAILCATCHER_USERNAME:$MAILCATCHER_USERNAME /home/$MAILCATCHER_USERNAME

# configure exim4
echo $MAILCATCHER_HOSTNAME >/etc/mailname

cat >/etc/exim4/update-exim4.conf.conf<<EOF
dc_eximconfig_configtype='local'
dc_other_hostnames=''
dc_local_interfaces='127.0.0.1 ; ::1'
dc_readhost=''
dc_relay_domains=''
dc_minimaldns='false'
dc_relay_nets=''
dc_smarthost=''
CFILEMODE='644'
dc_use_split_config='true'
dc_hide_mailname=''
dc_mailname_in_oh='true'
dc_localdelivery='maildir_home'
EOF

sed -i -e"s/  data = :fail: Mailing to remote domains not supported/  data = ${MAILCATCHER_USERNAME}@${MAILCATCHER_HOSTNAME}/" /etc/exim4/conf.d/router/200_exim4-config_primary

#update-exim4.conf.template -r
update-exim4.conf

exec "$@"
