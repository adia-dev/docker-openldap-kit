# OpenLDAP Docker Experiment

Bootstrap/experiment project for exploring OpenLDAP with Docker.

## Using Docker Hub Image

Pull and run the pre-built image directly from Docker Hub:

### Pull Image

```
docker pull adiadev/simple-openldap:latest
```

You can find the image on Docker Hub: [adiadev/simple-openldap](https://hub.docker.com/r/adiadev/simple-openldap)

### Run

```bash
docker run -d \
    -p 389:389 \
    -p 636:636 \
    --name simple-openldap \
    adiadev/simple-openldap:latest
```

Specify environment variables with `-e` option if needed:

```bash
docker run -d \
    -p 389:389 \
    -p 636:636 \
    --name simple-openldap \
    -e SLAPD_ROOT_PASSWORD=yourpassword \
    -e SLAPD_DOMAIN=yourdomain \
    -e SLAPD_ORGANIZATION=yourorganization \
    adiadev/simple-openldap:latest
```

## Building From Dockerfile

### Build

```
docker build -t simple-openldap .
```

### Run

```
docker run -d -p 389:389 -p 636:636 --name simple-openldap simple-openldap
```

### Docker Compose

```
docker-compose up -d
```

## Access LDAP Server

- **LDAP:** ldap://localhost:389
- **LDAPS:** ldaps://localhost:636

The docker compose file contains a phpLDAPadmin service that you can use to access the LDAP server.
You can access it at [https://localhost:6443](https://localhost:6443).

To login, use the following credentials:

```
Login DN: cn=admin,dc=example,dc=com
Password: yourpassword
```

Make sure to replace `yourpassword` with the actual password you set for the `SLAPD_ROOT_PASSWORD` environment variable and `example.com` with the domain you set for the `SLAPD_DOMAIN` environment variable.

## Configuration

Customize using environment variables (`SLAPD_ROOT_PASSWORD`, `SLAPD_DOMAIN`, etc.).

## Future Plans

- [ ] Add LDAP replication
- [ ] Add SASL
- [ ] Implement SSL/TLS
- [ ] Backend for Kerberos
- [ ] Seed big loads of data
