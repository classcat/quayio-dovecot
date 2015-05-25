# Dovecot POP/IMAP Server

Run dovecot pop/imap server in a container.

## Overview

Ubuntu Vivid/Trusty POP/IMAP Server images with :

+ dovecot
+ supervisord
+ sshd

built on the top of the formal Ubuntu images.

## Maintainer

[ClassCat Co.,Ltd.](http://www.classcat.com/) (This website is written in Japanese.)

## TAGS

+ latest - vivid
+ vivid
+ trusty

## Pull Image

```
$ docker pull classcat/dovecot
````

## Usage

```
$ docker run -d --name (container name) \  
-p 2022:22 110:110 -p 143:143 \  
-e ROOT_PASSWORD=(root password) \  
-e SSH_PUBLIC_KEY="ssh-rsa xxx" \  
-e USERS=(usr0:uid0:pwd0,usr1:uid1:pwd1) \  
-v (dirname of host):/var/mail \  
classcat/dovecot
````

example)

```
$ docker run -d --name dovecot \  
-p 2022:22 -p 110:110 -p 143:143 \  
-e ROOT_PASSWORD=mypassword \  
-e USERS=foo:1001:password,foo2:1002:password2 \  
-v /mail:/var/mail \  
classcat/dovecot

$ docker run -d --name dovecot \  
-p 2022:22 -p 110:110 -p 143:143 \  
-e ROOT_PASSWORD=mypassword \  
-e USERS=foo:1001:password,foo2:1002:password2 \  
-v /mail:/var/mail \  
classcat/dovecot:trusty
```

