#!/bin/bash

service slapd restart

# Simple health check
until ldapsearch -x -b "" -s base "objectclass=*" -H ldapi:/// >/dev/null 2>&1; do
    echo "Waiting for slapd to start..."
    sleep 1
done

echo "slapd is running."

#HACK: Keep the container running
exec tail -f /dev/null
