# documentation openldap server side

## package

```
sudo pacman -S openldap
```

## make password root

```
slappasswd
```
> input the password

### output slappasswd

```
{SSHA}YlP95x9HOw+Cieiue0e1x0MBoA5DRs5r
```

## configure

```
sudo echo "" > /etc/openldap/slapd.conf
```

```
sudo nvim /etc/openldap/slapd.conf
```

```
include /etc/openldap/schema/core.schema
include /etc/openldap/schema/cosine.schema
include /etc/openldap/schema/inetorgperson.schema
include /etc/openldap/schema/nis.schema

# --- TAMBAHKAN BARIS TLS & AKSES INTERNAL INI ---
TLSCertificateFile /etc/openldap/certs/cert.pem
TLSCertificateKeyFile /etc/openldap/certs/key.pem

# Memberikan izin akses penuh untuk root system via socket local (ldapi)
access to *
    by dn.exact="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" write
    by * read
# ------------------------------------------------

database mdb
suffix "dc=lan,dc=local"
rootdn "cn=admin,dc=lan,dc=local"
rootpw {SSHA}YlP95x9HOw+Cieiue0e1x0MBoA5DRs5r

directory /var/lib/openldap/openldap-data
```

## create directory

```
sudo mkdir /etc/openldap/slapd.d
```

```
sudo mkdir -p /var/lib/openldap/openldap-data
```

## tls

### create directory for cert tls

```
sudo mkdir -p /etc/openldap/certs
```

### create cert for tls

```
sudo openssl req -new -x509 -nodes -out /etc/openldap/certs/cert.pem -keyout /etc/openldap/certs/key.pem -days 365
```
> put information like below, custom with your information
```
Country Name (2 letter code) [AU]:ID
State or Province Name (full name) [Some-State]:Banten     
Locality Name (eg, city) []:Tangerang Selatan
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Yuros
Organizational Unit Name (eg, section) []:SysAdmin
Common Name (e.g. server FQDN or YOUR name) []:sulfar
Email Address []:sultanfajar371@gmail.com
```

## change owner

```
sudo chown -R ldap:ldap /etc/openldap/slapd.d
```

```
sudo chown -R ldap:ldap /var/lib/openldap/openldap-data
```

```
sudo chown -R ldap:ldap /etc/openldap/certs
```

## change mod folder

```
sudo chmod 700 /etc/openldap/certs
```

```
sudo chmod 600 /etc/openldap/certs/key.pem
```

```
sudo chmod 644 /etc/openldap/certs/cert.pem
```

## wipe data on folder

```
sudo rm -rf /etc/openldap/slapd.d/*
```

```
sudo rm -rf /var/lib/openldap/openldap-data/*
```

## slaptest

```
sudo slaptest -u -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d
```
> Output must like below

```
config file testing succeeded
```

## run systemctl 

```
sudo systemctl enable --now slapd
```

```
sudo systemctl status slapd
```
> output must be like below
```
● slapd.service - OpenLDAP Server Daemon
     Loaded: loaded (/usr/lib/systemd/system/slapd.service; enabled; preset: disabled)
     Active: active (running) since Mon 2026-05-11 15:41:59 WIB; 4s ago
 Invocation: 2d9b5cee48264ec0b9b2d4241fb2584e
       Docs: man:slapd
             man:slapd-config
             man:slapd-mdb
   Main PID: 71643 (slapd)
      Tasks: 2 (limit: 8630)
     Memory: 3.9M (peak: 4M)
        CPU: 20ms
     CGroup: /system.slice/slapd.service
             └─71643 /usr/lib/slapd -d 0 -u ldap -g ldap -h "ldap:/// ldapi:///"

May 11 15:41:59 smu systemd[1]: Starting OpenLDAP Server Daemon...
May 11 15:41:59 smu slapd[71643]: @(#) $OpenLDAP: slapd 2.6.13 (Mar  9 2026 18:47:39) $
                                          openldap
May 11 15:41:59 smu slapd[71643]: daemon: IPv6 socket() failed errno=97 (Address family not supported by protocol)
May 11 15:41:59 smu slapd[71643]: slapd starting
May 11 15:41:59 smu systemd[1]: Started OpenLDAP Server Daemon.
```

## create for user

### create password for user
```
slappasswd
```

### configuration structure yout organization

```
nvim ~/struktur.ldif
```

```
dn: dc=lan,dc=local
objectClass: top
objectClass: dcObject
objectClass: organization
o: Lokal Network
dc: lan

dn: cn=admin,dc=lan,dc=local
objectClass: organizationalRole
cn: admin

dn: ou=users,dc=lan,dc=local
objectClass: organizationalUnit
ou: users

dn: ou=groups,dc=lan,dc=local
objectClass: organizationalUnit
ou: groups

dn: cn=karyawan,ou=groups,dc=lan,dc=local
objectClass: top
objectClass: posixGroup
cn: karyawan
gidNumber: 20001

dn: uid=budi,ou=users,dc=lan,dc=local
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: Budi Santoso
uid: budi
uidNumber: 20001
gidNumber: 20001
homeDirectory: /home/budi
loginShell: /bin/bash
gecos: Budi Santoso
userPassword: {SSHA}LXOxieTByB90rjfGowXdY5uxZmJ/QCYS
shadowLastChange: 0
shadowMax: 99999
shadowWarning: 7
```

### put the stucture to server

```
ldapadd -x -D "cn=admin,dc=lan,dc=local" -W -f ~/struktur.ldif
```
> input password when you create for admin

> output must like below
```
adding new entry "dc=lan,dc=local"

adding new entry "cn=admin,dc=lan,dc=local"

adding new entry "ou=users,dc=lan,dc=local"

adding new entry "ou=groups,dc=lan,dc=local"

adding new entry "cn=karyawan,ou=groups,dc=lan,dc=local"

adding new entry "uid=budi,ou=users,dc=lan,dc=local"
```

### test the structure with server

```
ldapsearch -x -b "dc=lan,dc=local" "(objectClass=*)"
```
> output must like below

```
# extended LDIF
#
# LDAPv3
# base <dc=lan,dc=local> with scope subtree
# filter: (objectClass=*)
# requesting: ALL
#

# lan.local
dn: dc=lan,dc=local
objectClass: top
objectClass: dcObject
objectClass: organization
o: Lokal Network
dc: lan

# admin, lan.local
dn: cn=admin,dc=lan,dc=local
objectClass: organizationalRole
cn: admin

# users, lan.local
dn: ou=users,dc=lan,dc=local
objectClass: organizationalUnit
ou: users

# groups, lan.local
dn: ou=groups,dc=lan,dc=local
objectClass: organizationalUnit
ou: groups

# karyawan, groups, lan.local
dn: cn=karyawan,ou=groups,dc=lan,dc=local
objectClass: top
objectClass: posixGroup
cn: karyawan
gidNumber: 20001

# budi, users, lan.local
dn: uid=budi,ou=users,dc=lan,dc=local
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: Budi Santoso
uid: budi
uidNumber: 20001
gidNumber: 20001
homeDirectory: /home/budi
loginShell: /bin/bash
gecos: Budi Santoso
userPassword:: e1NTSEF9TFhPeGllVEJ5QjkwcmpmR293WGRZNXV4Wm1KL1FDWVM=
shadowLastChange: 0
shadowMax: 99999
shadowWarning: 7

# search result
search: 2
result: 0 Success

# numResponses: 7
# numEntries: 6
```

# documentation openldap client side

## package 

```
sudo pacman -Syu sssd openldap
```

## create folder for tls

```
sudo mkdir -p /etc/openldap/certs
```

## copy cert tls from server

```
sudo scp user@192.168.1.100:/etc/openldap/certs/cert.pem /etc/openldap/certs/server-cert.pem
```

## configure ldap

```
sudo nvim /etc/openldap/ldap.conf
```

```
BASE    dc=lan,dc=local
URI     ldaps://192.168.1.100
TLS_CACERT /etc/openldap/certs/server-cert.pem
```

```
ldapsearch -x
```

## configure sssd

```
sudo nano /etc/sssd/sssd.conf
```

```
[sssd]
config_file_version = 2
services = nss, pam
domains = lan.local

[domain/lan.local]
id_provider = ldap
auth_provider = ldap
chpass_provider = ldap

ldap_uri = ldaps://192.168.1.100
ldap_search_base = dc=lan,dc=local
ldap_id_use_start_tls = false
ldap_tls_cacert = /etc/openldap/certs/server-cert.pem

ldap_user_search_base = ou=users,dc=lan,dc=local
ldap_group_search_base = ou=groups,dc=lan,dc=local

cache_credentials = true
```

## change access for user

```
sudo chmod 600 /etc/sssd/sssd.conf
```

```
sudo chown root:root /etc/sssd/sssd.conf
```

## configure nsswitch

```
sudo nvim /etc/nsswitch.conf
```

```
passwd: files sss
group: files sss
```

## configure pam.d

```
sudo nvim /etc/pam.d/system-auth
```

```
#%PAM-1.0

auth      sufficient pam_sss.so forward_pass
auth      required   pam_unix.so try_first_pass nullok
auth      required   pam_deny.so

account   [default=bad success=ok user_unknown=ignore] pam_sss.so
account   required   pam_unix.so
account   required   pam_permit.so

password  sufficient pam_sss.so use_authtok
password  required   pam_unix.so try_first_pass shadow nullok
password  required   pam_deny.so

session   optional   pam_keyinit.so revoke
session   required   pam_limits.so
session   required   pam_mkhomedir.so skel=/etc/skel/ umask=0022
session   [success=1 default=ignore] pam_sss.so
session   required   pam_unix.so
```

```
sudo systemctl enable --now sssd
```

## test user

```
id budi
```
