#!/bin/bash

function fix_permissions() {
  chown -R backups:backups $DEST_DIR
  chmod -R 700 $DEST_DIR
}

function duplicity_docker() {
  docker run --rm -it --user root \
        -e PASSPHRASE=$PASSPHRASE \
        -v $FROM_DIR:/from:ro \
        -v $DEST_DIR/data:/dest \
        -v $DEST_DIR/cache:/home/duplicity/.cache/duplicity \
        theorician/duplicity \
        duplicity --volsize 1024 --full-if-older-than=3M \
        --allow-source-mismatch \
        /from file:///dest/
}
