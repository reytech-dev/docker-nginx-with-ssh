#!/bin/bash

trap "exit" INT
/usr/sbin/sshd
exec nginx -g 'daemon off;'
