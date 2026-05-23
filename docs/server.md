# 1. Install Packages

Arch Linux:

```bash
sudo pacman -S \
  podman \
  openssl \
```

---

# 2. Configure Rootless Podman

## Configure subuid

```bash
sudo nvim /etc/subuid
```

Add:

```text
USERNAME:100000:65536
```

---

## Configure subgid

```bash
sudo nvim /etc/subgid
```

Add:

```text
USERNAME:100000:65536
```

Replace:

```text
USERNAME
```

with your Linux username.

---

# 3. Enable Podman User Socket

```bash
systemctl --user enable --now podman.socket
```

---

# 4. Enable Linger

```bash
loginctl enable-linger $USER
```

---

# 5. Create Networks

```bash
podman network create frontend
```

---

```bash
podman network create backend
```

---

# 6. Create Directory Structure

```bash
mkdir -p ~/.config/containers/{postgres,traefik,secrets,ca}
```

---

```bash
mkdir -p ~/.config/containers/postgres/{data,certs}
```

---

```bash
mkdir -p ~/.config/containers/traefik/{dynamic,certs}
```

---

```bash
mkdir -p ~/.config/containers/ca/{root,private,certs}
```

---

# 7. Secure Secret Permissions

```bash
chmod 700 ~/.config/containers/secrets
```

---

# 8. Create OpenSSL Root CA

## Generate Root CA Key

```bash
openssl genrsa \
-out ~/.config/containers/ca/private/rootCA.key \
4096
```

---

## Secure Root Key

```bash
chmod 600 ~/.config/containers/ca/private/rootCA.key
```

---

## Generate Root Certificate

```bash
openssl req \
-x509 \
-new \
-nodes \
-key ~/.config/containers/ca/private/rootCA.key \
-sha256 \
-days 3650 \
-out ~/.config/containers/ca/root/rootCA.crt \
-subj "/C=ID/ST=Homelab/L=Homelab/O=Homelab/CN=Homelab Root CA"
```

---

# 9. Install Root CA Into System

```bash
sudo cp \
~/.config/containers/ca/root/rootCA.crt \
/etc/ca-certificates/trust-source/anchors/
```

---

```bash
sudo update-ca-trust
```

---

# 10. Install Root CA Into Firefox NSSDB

## Create NSSDB

```bash
mkdir -p ~/.pki/nssdb
```

---

## Initialize NSSDB

```bash
certutil -N \
-d sql:$HOME/.pki/nssdb
```

Press ENTER for empty password.

---

## Import Root CA

```bash
certutil \
-d sql:$HOME/.pki/nssdb \
-A \
-t "CT,C,C" \
-n "Homelab Root CA" \
-i ~/.config/containers/ca/root/rootCA.crt
```

---

# 11. Create SAN Config

```bash
nvim ~/.config/containers/ca/openssl-san.cnf
```

```conf
[req]
default_bits = 4096
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[dn]
C = ID
ST = Homelab
L = Homelab
O = Homelab
CN = local.test

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = auth.local.test
DNS.2 = git.local.test
DNS.3 = ldap.local.test
DNS.4 = postgres.local.test
```

---

# 12. Generate Homelab Certificate

## Generate Private Key

```bash
openssl genrsa \
-out ~/.config/containers/ca/private/local.test.key \
4096
```

---

## Secure Key

```bash
chmod 600 ~/.config/containers/ca/private/local.test.key
```

---

## Generate CSR

```bash
openssl req \
-new \
-key ~/.config/containers/ca/private/local.test.key \
-out ~/.config/containers/ca/local.test.csr \
-config ~/.config/containers/ca/openssl-san.cnf
```

---

## Generate Signed Certificate

```bash
openssl x509 \
-req \
-in ~/.config/containers/ca/local.test.csr \
-CA ~/.config/containers/ca/root/rootCA.crt \
-CAkey ~/.config/containers/ca/private/rootCA.key \
-CAcreateserial \
-out ~/.config/containers/ca/certs/local.test.crt \
-days 825 \
-sha256 \
-extfile ~/.config/containers/ca/openssl-san.cnf \
-extensions req_ext
```

---

# 13. Verify SAN

```bash
openssl x509 \
-in ~/.config/containers/ca/certs/local.test.crt \
-text \
-noout | grep -A1 "Subject Alternative"
```

Expected:

```text
DNS:auth.local.test
DNS:git.local.test
DNS:ldap.local.test
DNS:postgres.local.test
```

---

# 14. Install Traefik Certificates

```bash
cp ~/.config/containers/ca/certs/local.test.crt \
~/.config/containers/traefik/certs/
```

---

```bash
cp ~/.config/containers/ca/private/local.test.key \
~/.config/containers/traefik/certs/
```

---

# 15. Configure Traefik Dynamic Config

```bash
nvim ~/.config/containers/traefik/dynamic/dynamic.yml
```

```yaml
http:
  middlewares:
    security:
      headers:
        frameDeny: true
        browserXssFilter: true
        contentTypeNosniff: true
        referrerPolicy: strict-origin
        stsSeconds: 31536000
        stsIncludeSubdomains: true
        stsPreload: true

tls:
  certificates:
    - certFile: /certs/local.test.crt
      keyFile: /certs/local.test.key

  options:
    default:
      minVersion: VersionTLS13
      sniStrict: true
```

---

# 16. Create PostgreSQL Secret

```bash
nvim ~/.config/containers/secrets/postgres.env
```

```env
POSTGRES_USER=postgres
POSTGRES_PASSWORD=CHANGE_ME_POSTGRES_PASSWORD
```

---

# 17. Create Temporary PostgreSQL Config

## postgresql.conf

```bash
nvim ~/.config/containers/postgres/postgresql.conf
```

```conf
listen_addresses = '*'

password_encryption = scram-sha-256
```

---

## pg_hba.conf

```bash
nvim ~/.config/containers/postgres/pg_hba.conf
```

```conf
local   all             postgres                                trust

local   all             all                                     scram-sha-256

host    all             all             0.0.0.0/0               scram-sha-256

host    all             all             ::/0                    scram-sha-256
```

---

# 18. Initialize PostgreSQL Cluster

```bash
podman run -d \
  --name postgres-init \
  --restart unless-stopped \
  --network backend \
  --security-opt no-new-privileges \
  --memory 1g \
  --cpus 2 \
  --env-file ~/.config/containers/secrets/postgres.env \
  -e POSTGRES_INITDB_ARGS="--data-checksums --auth-host=scram-sha-256" \
  -v ~/.config/containers/postgres/data:/var/lib/postgresql/data:Z \
  -v ~/.config/containers/postgres/postgresql.conf:/etc/postgresql/postgresql.conf:ro,Z \
  -v ~/.config/containers/postgres/pg_hba.conf:/etc/postgresql/pg_hba.conf:ro,Z \
  docker.io/library/postgres:17 \
  -c config_file=/etc/postgresql/postgresql.conf \
  -c hba_file=/etc/postgresql/pg_hba.conf
```

---

# 19. Verify Bootstrap

```bash
podman logs -f postgres-init
```

Expected:

```text
database system is ready to accept connections
```

---

# 20. Stop Bootstrap Container

```bash
podman rm -f postgres-init
```

---

# 21. Install PostgreSQL TLS Certificates

## Copy Certificate

```bash
cp ~/.config/containers/ca/certs/local.test.crt \
~/.config/containers/postgres/certs/server.crt
```

---

## Copy Key

```bash
cp ~/.config/containers/ca/private/local.test.key \
~/.config/containers/postgres/certs/server.key
```

---

# 22. Fix PostgreSQL Certificate Ownership

```bash
podman unshare chown 999:999 \
~/.config/containers/postgres/certs/server.crt
```

---

```bash
podman unshare chown 999:999 \
~/.config/containers/postgres/certs/server.key
```

---

# 23. Fix PostgreSQL Certificate Permissions

```bash
podman unshare chmod 600 \
~/.config/containers/postgres/certs/server.key
```

---

# 24. Enable PostgreSQL SSL

## Replace postgresql.conf

```bash
nvim ~/.config/containers/postgres/postgresql.conf
```

```conf
listen_addresses = '*'

ssl = on

ssl_cert_file = '/certs/server.crt'

ssl_key_file = '/certs/server.key'

ssl_min_protocol_version = 'TLSv1.3'

password_encryption = scram-sha-256
```

---

## Replace pg_hba.conf

```bash
nvim ~/.config/containers/postgres/pg_hba.conf
```

```conf
local   all             postgres                                trust

local   all             all                                     scram-sha-256

hostssl all             all             0.0.0.0/0               scram-sha-256

hostssl all             all             ::/0                    scram-sha-256
```

---

# 25. Run Final PostgreSQL

```bash
podman run -d \
  --name postgres \
  --restart unless-stopped \
  --network backend \
  --security-opt no-new-privileges \
  --memory 1g \
  --cpus 2 \
  --health-cmd "pg_isready -U postgres" \
  --health-interval 10s \
  --health-retries 5 \
  --env-file ~/.config/containers/secrets/postgres.env \
  -v ~/.config/containers/postgres/data:/var/lib/postgresql/data:Z \
  -v ~/.config/containers/postgres/certs:/certs:ro,Z \
  -v ~/.config/containers/postgres/postgresql.conf:/etc/postgresql/postgresql.conf:ro,Z \
  -v ~/.config/containers/postgres/pg_hba.conf:/etc/postgresql/pg_hba.conf:ro,Z \
  docker.io/library/postgres:17 \
  -c config_file=/etc/postgresql/postgresql.conf \
  -c hba_file=/etc/postgresql/pg_hba.conf
```

---

# 26. Verify PostgreSQL

```bash
podman logs -f postgres
```

Expected:

```text
database system is ready to accept connections
```

---

# 27. Verify PostgreSQL TLS

```bash
podman exec -it postgres \
psql "sslmode=require host=localhost user=postgres"
```

Expected:

```text
postgres=#
```

```bash
podman exec -it postgres psql -U postgres
```

---

# Forgejo Database

## Create User

```sql
CREATE USER forgejo
WITH ENCRYPTED PASSWORD 'forgejo1511';
```

## Create Database

```sql
CREATE DATABASE forgejo
OWNER forgejo;
```

## Grant Database Privileges

```sql
GRANT ALL PRIVILEGES
ON DATABASE forgejo
TO forgejo;
```

## Change Public Schema Ownership

```sql
\c forgejo
```

```sql
ALTER SCHEMA public
OWNER TO forgejo;
```

## Grant Schema Privileges

```sql
GRANT ALL
ON SCHEMA public
TO forgejo;
```

---

# Authelia Database

## Create User

```sql
CREATE USER authelia
WITH ENCRYPTED PASSWORD 'authelia1511';
```

## Create Database

```sql
CREATE DATABASE authelia
OWNER authelia;
```

## Grant Database Privileges

```sql
GRANT ALL PRIVILEGES
ON DATABASE authelia
TO authelia;
```

## Change Public Schema Ownership

```sql
\c authelia
```

```sql
ALTER SCHEMA public
OWNER TO authelia;
```

## Grant Schema Privileges

```sql
GRANT ALL
ON SCHEMA public
TO authelia;
```

---

# LLDAP Database

## Create User

```sql
CREATE USER lldap
WITH ENCRYPTED PASSWORD 'lldap1511';
```

## Create Database

```sql
CREATE DATABASE lldap
OWNER lldap;
```

## Grant Database Privileges

```sql
GRANT ALL PRIVILEGES
ON DATABASE lldap
TO lldap;
```

## Change Public Schema Ownership

```sql
\c lldap
```

```sql
ALTER SCHEMA public
OWNER TO lldap;
```

## Grant Schema Privileges

```sql
GRANT ALL
ON SCHEMA public
TO lldap;
```

---

# Exit PostgreSQL Shell

```sql
\q
```

# 28. Configure Valkey TLS

## Create Directories

```bash
mkdir -p ~/.config/containers/valkey/{data,certs}
```

---

## Copy Certificates

```bash
cp ~/.config/containers/ca/certs/local.test.crt \
~/.config/containers/valkey/certs/server.crt
```

```bash
cp ~/.config/containers/ca/private/local.test.key \
~/.config/containers/valkey/certs/server.key
```

```bash
cp ~/.config/containers/ca/root/rootCA.crt \
~/.config/containers/valkey/certs/ca.crt
```

---

## Fix Permissions

```bash
podman unshare chown 999:999 \
~/.config/containers/valkey/certs/server.crt
```

```bash
podman unshare chown 999:999 \
~/.config/containers/valkey/certs/server.key
```

```bash
podman unshare chmod 600 \
~/.config/containers/valkey/certs/server.key
```

---

## Create Secret

```bash
nvim ~/.config/containers/secrets/valkey.env
```

```env
VALKEY_PASSWORD=CHANGE_ME_VALKEY_PASSWORD
```

---

## Create Config

```bash
nvim ~/.config/containers/valkey/valkey.conf
```

```conf
bind 0.0.0.0

protected-mode yes

port 0

tls-port 6379

tls-cert-file /certs/server.crt
tls-key-file /certs/server.key
tls-ca-cert-file /certs/ca.crt

tls-auth-clients no

appendonly yes

save 60 1000

maxmemory 256mb

maxmemory-policy allkeys-lru

requirepass CHANGE_ME_VALKEY_PASSWORD
```

---

## Run Valkey

```bash
podman run -d \
  --name valkey \
  --restart unless-stopped \
  --network backend \
  --security-opt no-new-privileges \
  --memory 512m \
  --cpus 1 \
  --health-cmd "valkey-cli --tls --insecure -a CHANGE_ME_VALKEY_PASSWORD ping" \
  --health-interval 30s \
  --health-retries 5 \
  --env-file ~/.config/containers/secrets/valkey.env \
  -v ~/.config/containers/valkey/data:/data:Z \
  -v ~/.config/containers/valkey/valkey.conf:/etc/valkey/valkey.conf:ro,Z \
  -v ~/.config/containers/valkey/certs:/certs:ro,Z \
  docker.io/valkey/valkey:latest \
  valkey-server /etc/valkey/valkey.conf
```

---

## Verify Valkey

```bash
podman logs -f valkey
```

Expected:

```text
Ready to accept connections
```

---

# 29. Configure LLDAP TLS

## Create Directories

```bash
mkdir -p ~/.config/containers/lldap/{data,certs}
```

---

## Copy Certificates

```bash
cp ~/.config/containers/ca/certs/local.test.crt \
~/.config/containers/lldap/certs/server.crt
```

```bash
cp ~/.config/containers/ca/private/local.test.key \
~/.config/containers/lldap/certs/server.key
```

```bash
cp ~/.config/containers/ca/root/rootCA.crt \
~/.config/containers/lldap/certs/ca.crt
```

---

## Fix Permissions

```bash
podman unshare chown 1000:1000 \
~/.config/containers/lldap/certs/server.crt
```

```bash
podman unshare chown 1000:1000 \
~/.config/containers/lldap/certs/server.key
```

```bash
podman unshare chmod 600 \
~/.config/containers/lldap/certs/server.key
```

---

## Create Secret


### run this command 2 times

```
openssl rand -hex 64
```

```bash
nvim ~/.config/containers/secrets/lldap.env
```

```env
LLDAP_JWT_SECRET=CHANGE_ME
LLDAP_KEY_SEED=CHANGE_ME
LLDAP_LDAP_USER_PASS=CHANGE_ME
LLDAP_DATABASE_URL=postgres://lldap:CHANGE_ME_LLDAP_DB@postgres:5432/lldap?sslmode=require
```

---

## Run LLDAP

```bash
podman run -d \
  --name lldap \
  --restart unless-stopped \
  --network backend \
  --security-opt no-new-privileges \
  --memory 512m \
  --cpus 1 \
  --health-cmd "wget -qO- --no-check-certificate https://localhost:17170" \
  --health-interval 30s \
  --health-retries 5 \
  --env-file ~/.config/containers/secrets/lldap.env \
  -e LLDAP_HTTP_URL=https://ldap.local.test:8999 \
  -e LLDAP_LDAP_BASE_DN=dc=local,dc=test \
  -e LLDAP_LDAP_USER_DN=admin \
  -e LLDAP_HTTP_TLS_CERT=/certs/server.crt \
  -e LLDAP_HTTP_TLS_KEY=/certs/server.key \
  -e LLDAP_LDAPS_OPTIONS__ENABLED=true \
  -e LLDAP_LDAPS_OPTIONS__CERT_FILE=/certs/server.crt \
  -e LLDAP_LDAPS_OPTIONS__KEY_FILE=/certs/server.key \
  -v ~/.config/containers/lldap/data:/data:Z \
  -v ~/.config/containers/lldap/certs:/certs:ro,Z \
  docker.io/lldap/lldap:stable
```

---

## Verify LLDAP

```bash
podman logs -f lldap
```

Expected:

```text
LDAP server listening
```

---

# 30. Configure Traefik TLS

## Create Directories

```bash
mkdir -p ~/.config/containers/traefik/{dynamic,certs}
```

---

## Copy Certificates

```bash
cp ~/.config/containers/ca/certs/local.test.crt \
~/.config/containers/traefik/certs/server.crt
```

```bash
cp ~/.config/containers/ca/private/local.test.key \
~/.config/containers/traefik/certs/server.key
```

---

## Create Dynamic Config

```bash
nvim ~/.config/containers/traefik/dynamic/dynamic.yml
```

```yaml
http:
  middlewares:
    security:
      headers:
        frameDeny: true
        browserXssFilter: true
        contentTypeNosniff: true
        stsSeconds: 31536000
        stsIncludeSubdomains: true
        stsPreload: true
        referrerPolicy: strict-origin

  routers:
    authelia:
      rule: "Host(`auth.local.test`)"
      entryPoints:
        - websecure
      service: authelia
      middlewares:
        - security
      tls: {}

    forgejo:
      rule: "Host(`git.local.test`)"
      entryPoints:
        - websecure
      service: forgejo
      middlewares:
        - security
      tls: {}

    lldap:
      rule: "Host(`ldap.local.test`)"
      entryPoints:
        - websecure
      service: lldap
      middlewares:
        - security
      tls: {}

  services:
    authelia:
      loadBalancer:
        servers:
          - url: "http://authelia:9091"

    forgejo:
      loadBalancer:
        servers:
          - url: "http://forgejo:3000"

    lldap:
      loadBalancer:
        servers:
          - url: "http://lldap:17170"

tls:
  certificates:
    - certFile: /certs/server.crt
      keyFile: /certs/server.key

  options:
    default:
      minVersion: VersionTLS13
      sniStrict: true
```

---

## Run Traefik

```bash
podman run -d \
  --name traefik \
  --restart unless-stopped \
  --network frontend \
  --security-opt no-new-privileges \
  --read-only \
  --tmpfs /tmp \
  --memory 512m \
  --cpus 1 \
  -p 8999:443 \
  -p 8080:8080 \
  -v ~/.config/containers/traefik/dynamic:/dynamic:Z \
  -v ~/.config/containers/traefik/certs:/certs:ro,Z \
  docker.io/library/traefik:v3 \
  --providers.file.directory=/dynamic \
  --providers.file.watch=true \
  --entrypoints.websecure.address=:443 \
  --serversTransport.insecureSkipVerify=true \
  --api.dashboard=true
```

---

## Connect Traefik To Backend

```bash
podman network connect backend traefik
```

---

## Verify Traefik

```bash
curl -k https://localhost:8999
```

---

# 31. Configure Authelia TLS

## Create Directories

```bash
mkdir -p ~/.config/containers/authelia/certs
```

---

## Copy Certificates

```bash
cp ~/.config/containers/ca/certs/local.test.crt \
~/.config/containers/authelia/certs/server.crt
```

```bash
cp ~/.config/containers/ca/private/local.test.key \
~/.config/containers/authelia/certs/server.key
```

```bash
cp ~/.config/containers/ca/root/rootCA.crt \
~/.config/containers/authelia/certs/ca.crt
```

---

## Fix Permissions

```bash
podman unshare chown 999:999 \
~/.config/containers/authelia/certs/server.crt
```

```bash
podman unshare chown 999:999 \
~/.config/containers/authelia/certs/server.key
```

```bash
podman unshare chmod 600 \
~/.config/containers/lldap/certs/server.key
```

---

## Generate RSA Key

```bash
openssl genrsa -out ~/.config/containers/authelia/private.pem 4096
```

---

## Create Secret


### run this command 5 times

```
openssl rand -hex 64
```

```bash
nvim ~/.config/containers/secrets/authelia.env
```

```env
AUTHELIA_SESSION_SECRET=CHANGE_ME
AUTHELIA_STORAGE_ENCRYPTION_KEY=CHANGE_ME
AUTHELIA_IDENTITY_VALIDATION_RESET_PASSWORD_JWT_SECRET=CHANGE_ME
AUTHELIA_IDENTITY_PROVIDERS_OIDC_HMAC_SECRET=CHANGE_ME
AUTHELIA_STORAGE_POSTGRES_PASSWORD=CHANGE_ME_AUTHELIA_DB
AUTHELIA_VALKEY_PASSWORD=CHANGE_ME_VALKEY_PASSWORD
AUTHELIA_FORGEJO_CLIENT_SECRET=CHANGE_ME
```

---

## Create Configuration

```bash
nvim ~/.config/containers/authelia/configuration.yml
```

```yaml
server:
  address: 'tcp://0.0.0.0:9091'

  tls:
    key: '/certs/server.key'
    certificate: '/certs/server.crt'

log:
  level: 'debug'

session:
  secret: ${AUTHELIA_SESSION_SECRET}

  cookies:
    - domain: 'local.test'
      authelia_url: 'https://auth.local.test:8999'
      default_redirection_url: 'https://git.local.test:8999'

  redis:
    host: 'valkey'
    port: 6379
    password: valkey1511
    tls:
      skip_verify: true

storage:
  encryption_key: '${AUTHELIA_STORAGE_ENCRYPTION_KEY}'

  postgres:
    address: 'tcp://postgres:5432'
    database: 'authelia'
    username: 'authelia'
    password: ${AUTHELIA_STORAGE_POSTGRES_PASSWORD}

    tls:
      server_name: 'postgres.local.test'
      skip_verify: true

authentication_backend:
  ldap:
    implementation: 'lldap'

    address: 'ldaps://ldap.local.test:6360'

    tls:
      server_name: 'ldap.local.test'
      skip_verify: true

    timeout: '5s'

    start_tls: false

    base_dn: 'dc=local,dc=test'

    additional_users_dn: ou=people

    users_filter: "(&(objectClass=person)({username_attribute}={input}))"

    additional_groups_dn: ou=groups

    groups_filter: "(member={dn})"

    user: 'uid=admin,ou=people,dc=local,dc=test'

    password: '[password admin lldap]'

    attributes:
      username: 'uid'
      display_name: 'displayName'
      mail: 'mail'
      group_name: 'cn'


access_control:
  default_policy: 'one_factor'

identity_providers:
  oidc:
    hmac_secret: ${AUTHELIA_IDENTITY_PROVIDERS_OIDC_HMAC_SECRET}

    jwks:
      - key_id: 'main'
        algorithm: 'RS256'
        use: 'sig'
        key: |
          -----BEGIN PRIVATE KEY-----
          -- paste here (indensasi harus sama)
          -----END PRIVATE KEY-----

    clients:
      - client_id: 'forgejo'

        client_name: 'Forgejo'

        client_secret: CHANGE_ME 

        public: false

        authorization_policy: 'one_factor'

        redirect_uris:
          - https://git.local.test:8999/user/oauth2/Authelia/callback

        scopes:
          - openid
          - profile
          - email
          - groups

        userinfo_signed_response_alg: 'none'

notifier:
  filesystem:
    filename: '/config/notification.txt'
```

---

## Run Authelia

```bash
podman run -d \
  --name authelia \
  --restart unless-stopped \
  --network backend \
  --add-host ldap.local.test:10.89.1.231 \
  --security-opt no-new-privileges \
  --memory 512m \
  --cpus 1 \
  --health-cmd "wget -qO- --no-check-certificate https://localhost:9091/api/health" \
  --health-interval 30s \
  --health-retries 5 \
  --env-file ~/.config/containers/secrets/authelia.env \
  -v ~/.config/containers/authelia:/config:Z \
  -v ~/.config/containers/authelia/certs:/certs:ro,Z \
  docker.io/authelia/authelia:latest
```

---

# 32. Configure Forgejo TLS

## Create Directories

```bash
mkdir -p ~/.config/containers/forgejo/certs
```

---

## Copy Certificates

```bash
cp ~/.config/containers/ca/certs/local.test.crt \
~/.config/containers/forgejo/certs/server.crt
```

```bash
cp ~/.config/containers/ca/private/local.test.key \
~/.config/containers/forgejo/certs/server.key
```


---

## Create Secret


### run this command 3 times

```
openssl rand -hex 64
```

```bash
nvim ~/.config/containers/secrets/forgejo.env
```

```env
FORGEJO__database__PASSWD=CHANGE_ME_FORGEJO_DB
FORGEJO__security__INTERNAL_TOKEN=CHANGE_ME
FORGEJO__oauth2__JWT_SECRET=CHANGE_ME
FORGEJO__security__SECRET_KEY=CHANGE_ME
```

---

## Run Forgejo

```bash
podman run -d \
  --name forgejo \
  --restart unless-stopped \
  --network backend \
  --security-opt no-new-privileges \
  --memory 2g \
  --cpus 2 \
  --health-cmd "wget -qO- --no-check-certificate https://localhost:3000" \
  --health-interval 30s \
  --health-retries 5 \
  --env-file ~/.config/containers/secrets/forgejo.env \
  -v ~/.config/containers/forgejo:/data:Z \
  -v ~/.config/containers/forgejo/certs:/certs:ro,Z \
  -e USER_UID=1000 \
  -e USER_GID=1000 \
  -e FORGEJO__database__DB_TYPE=postgres \
  -e FORGEJO__database__HOST=postgres.local.test:5432 \
  -e FORGEJO__database__NAME=forgejo \
  -e FORGEJO__database__USER=forgejo \
  -e FORGEJO__database__SSL_MODE=verify-full \
  -e FORGEJO__database__SSL_ROOT_CERT=/certs/ca.crt \
  -e FORGEJO__server__ROOT_URL=https://git.local.test:8999/ \
  -e FORGEJO__server__DOMAIN=git.local.test \
  -e FORGEJO__server__PROTOCOL=https \
  -e FORGEJO__server__HTTP_PORT=3000 \
  -e FORGEJO__server__CERT_FILE=/certs/server.crt \
  -e FORGEJO__server__KEY_FILE=/certs/server.key \
  codeberg.org/forgejo/forgejo:15
```

---

# 33. Verify Services

## Verify PostgreSQL TLS

```bash
openssl s_client \
-connect localhost:5432 \
-starttls postgres
```

---

## Verify Valkey TLS

```bash
podman exec -it valkey \
valkey-cli \
--tls \
--insecure \
-a CHANGE_ME_VALKEY_PASSWORD ping
```

Expected:

```text
PONG
```

---

## Verify LLDAP HTTPS

```bash
curl -k https://ldap.local.test:8999
```

---

## Verify Authelia HTTPS

```bash
curl -k https://auth.local.test:8999
```

---

## Verify Forgejo HTTPS

```bash
curl -k https://git.local.test:8999
```

---

# 34. Configure Forgejo OIDC

Open:

```text
https://git.local.test:8999
```

---

Go To:

```text
Site Administration
→ Authentication Sources
→ Add OAuth2 Source
```

---

## Configure

Provider:

```text
OpenID Connect
```

---

Discovery URL:

```text
https://auth.local.test:8999/.well-known/openid-configuration
```

---

Client ID:

```text
forgejo
```

---

Client Secret:

```text
AUTHELIA_FORGEJO_CLIENT_SECRET
```

---

Enable:

```text
Auto Discover URL
```
