# 1. Install Packages

Arch Linux:

```bash
sudo pacman -S \
  podman \
  openssl \
  curl \
  wget \
  nss \
  libnssckbi \
  postgresql-libs
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
