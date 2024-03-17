FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

COPY ./configure_slapd.sh /configure_slapd.sh
COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /configure_slapd.sh /entrypoint.sh

RUN apt-get update -y && \
    apt-get install -y vim slapd ldap-utils iproute2 \
    iputils-ping openssh-client openssh-server \
    debconf-utils && \
    rm -rf /var/lib/apt/lists/*

# Configure slapd with the script, environment variables can be set
# to override the script variables
RUN chmod +x /configure_slapd.sh && ./configure_slapd.sh

COPY ./ldap.conf /etc/ldap/ldap.conf

# Expose necessary ports
# TODO: maybe add 2222 for ssh to avoid conflict
EXPOSE 22 389 636

ENTRYPOINT ["/entrypoint.sh"]
