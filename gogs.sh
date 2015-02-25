#!/bin/sh -xe

PATH=/bin:/usr/bin:/usr/local/bin
USER=git
HOME=/home/$USER
GOGS_CUSTOM=$HOME
export PATH USER HOME GOGS_CUSTOM

if test -z "$DOMAIN"; then
    echo "Please set a domain with:\n\tdocker -e DOMAIN=git.domain.com\nto generate proper Gogs config and HTTPS key."
    sleep 20
    exit 1
fi
if test -n "$HTTP_PORT"; then
    protocol=http
    port=$HTTP_PORT
else
    protocol=https
    port=${HTTPS_PORT:-50443}
fi

chown $USER:$USER $HOME

if ! test -d $GOGS_CUSTOM/conf; then
    mkdir -p $GOGS_CUSTOM/conf
    key=$(dd if=/dev/urandom bs=32 count=1 status=none | base64)
    sed -e "s|{{DOMAIN}}|$DOMAIN|" \
        -e "s|{{SECRET_KEY}}|$key|" \
        -e "s|{{PROTOCOL}}|$protocol|" \
        -e "s|{{HTTP_PORT}}|$port|" \
        -e "s|{{SSH_PORT}}|${SSH_PORT:-50022}|" \
        < /opt/gogs/app.ini.custom > $GOGS_CUSTOM/conf/app.ini
    chown $USER:$USER $GOGS_CUSTOM/conf/app.ini
fi

if test $protocol = https -a ! -f $GOGS_CUSTOM/conf/cert.pem; then
    openssl req -new -newkey rsa:2048 -nodes -x509 -days 5000 -extensions v3_ca \
      -subj "/CN=$DOMAIN" \
      -keyout $GOGS_CUSTOM/conf/key.pem -out $GOGS_CUSTOM/conf/cert.pem
fi

if ! test -d $HOME/.ssh; then
    mkdir -p $HOME/.ssh
    chown $USER:$USER $HOME/.ssh
    chmod 700 $HOME/.ssh
    echo "GOGS_CUSTOM=$GOGS_CUSTOM" > $HOME/.ssh/environment
    chown $USER:$USER $HOME/.ssh/environment
    chmod 600 $HOME/.ssh/environment
fi

for d in repositories log avatars attachments sessions; do
    if ! test -d $HOME/$d; then
        mkdir -p $HOME/$d
        chown $USER:$USER $HOME/$d
    fi
done

cd /opt/gogs
exec chpst -u $USER:$USER /opt/gogs/gogs web
