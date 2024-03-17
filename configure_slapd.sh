#!/bin/bash

log() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" 1>&2
}

if [ "$(id -u)" -ne 0 ]; then
    error "This script must be run as root"
    exit 1
fi

SLAPD_ROOT_PASSWORD="${SLAPD_ROOT_PASSWORD:-Respons11}"
SLAPD_DOMAIN="${SLAPD_DOMAIN:-adia.dev}"
SLAPD_ORGANIZATION="${SLAPD_ORGANIZATION:-Adia Company}"
SLAPD_BACKEND="${SLAPD_BACKEND:-MDB}"
SLAPD_PURGE_DB="${SLAPD_PURGE_DB:-false}"
SLAPD_DUMP_DB="${SLAPD_DUMP_DB:-false}"

# Useful for debugging purposes, but add noise to the terminal
# export DEBCONF_DEBUG=developer
export DEBIAN_FRONTEND=noninteractive

log "Starting slapd configuration..."

set_selections() {
    echo -e "$1" | debconf-set-selections
}

configure_slapd() {
    set_selections "slapd slapd/root_password password ${SLAPD_ROOT_PASSWORD}" &&
    set_selections "slapd slapd/root_password_again password ${SLAPD_ROOT_PASSWORD}" &&
    set_selections "slapd slapd/internal/adminpw password ${SLAPD_ROOT_PASSWORD}" &&
    set_selections "slapd slapd/internal/generated_adminpw password ${SLAPD_ROOT_PASSWORD}" &&
    set_selections "slapd slapd/password1 password ${SLAPD_ROOT_PASSWORD}" &&
    set_selections "slapd slapd/password2 password ${SLAPD_ROOT_PASSWORD}" &&
    set_selections "slapd slapd/domain string ${SLAPD_DOMAIN}" &&
    set_selections "slapd slapd/backend string ${SLAPD_BACKEND}" &&
    set_selections "slapd shared/organization string ${SLAPD_ORGANIZATION}" &&
    set_selections "slapd slapd/purge_database boolean ${SLAPD_PURGE_DB}" &&
    set_selections "slapd slapd/move_old_database boolean ${SLAPD_DUMP_DB}" &&
    set_selections "slapd slapd/no_configuration boolean false"
}

if configure_slapd; then
    log "Successfully set debconf selections for slapd."
else
    error "Failed to set debconf selections for slapd."
    exit 1
fi

if dpkg-reconfigure slapd -f noninteractive; then
    log "Successfully reconfigured slapd."
else
    error "Failed to reconfigure slapd."
    exit 1
fi

log "Done configuring slapd."
