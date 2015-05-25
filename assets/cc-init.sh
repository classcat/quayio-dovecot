#!/bin/bash

########################################################################
# ClassCat/Dovecot Asset files
# Copyright (C) 2015 ClassCat Co.,Ltd. All rights reserved.
########################################################################

#--- HISTORY -----------------------------------------------------------
# 06-may-15 : Add init code.
# 06-may-15 : Change var name 'users' to 'USERS'.
# 04-may-15 : Add sshd and code portion to handle root password.
# 03-may-15 : Removed the nodaemon steps.
#-----------------------------------------------------------------------


######################
### INITIALIZATION ###
######################

function init () {
  echo "ClassCat Info >> initialization code for ClassCat/Dovecot"
  echo "Copyright (C) 2015 ClassCat Co.,Ltd. All rights reserved."
  echo ""
}


############
### SSHD ###
############

function change_root_password() {
  if [ -z "${ROOT_PASSWORD}" ]; then
    echo "ClassCat Warning >> No ROOT_PASSWORD specified."
  else
    echo -e "root:${ROOT_PASSWORD}" | chpasswd
    # echo -e "${password}\n${password}" | passwd root
  fi
}


function put_public_key() {
  if [ -z "$SSH_PUBLIC_KEY" ]; then
    echo "ClassCat Warning >> No SSH_PUBLIC_KEY specified."
  else
    mkdir -p /root/.ssh
    chmod 0700 /root/.ssh
    echo "${SSH_PUBLIC_KEY}" > /root/.ssh/authorized_keys
  fi
}


###############
### DOVECOT ###
###############

function config_dovecot () {
  sed -i -e "s/^#disable_plaintext_auth\s*=\s*yes/disable_plaintext_auth = no/" /etc/dovecot/conf.d/10-auth.conf
}

function add_accounts () {
  echo ${USERS} | tr , \\n > /var/tmp/users
  while IFS=':' read -r _user _id _pwd; do
    useradd -u $_id -s /usr/sbin/nologin -m $_user
    echo -e "${_pwd}\n${_pwd}" | passwd $_user
  done < /var/tmp/users
  rm /var/tmp/users
}

function proc_dovecot () {
  config_dovecot
  add_accounts
}


##################
### SUPERVISOR ###
##################

# See http://docs.docker.com/articles/using_supervisord/

function proc_supervisor () {
  cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[program:dovecot]
command=/opt/cc-dovecot.sh

[program:ssh]
command=/usr/sbin/sshd -D

[program:rsyslog]
command=/usr/sbin/rsyslogd -n
EOF

  cat >> /opt/cc-dovecot.sh <<EOF
#!/bin/bash
/etc/init.d/dovecot start
tail -f /var/log/mail.log
EOF

  chmod +x /opt/cc-dovecot.sh
}


init
change_root_password
put_public_key
proc_dovecot
proc_supervisor

# /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

exit 0


### End of Script ###

