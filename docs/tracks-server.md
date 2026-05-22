```
podman network create homelab
Error: network name homelab already used: network already exists

 --(237)--( user@system )-->  /home/sultan/.config/containers |-->  18:01:17 
 󱞩 sudo nvim /etc/sudo nvim /etc/hosts
[sudo] password for user: 

 --(238)--( user@system )-->  /home/sultan/.config/containers |-->  18:01:33 
 󱞩 mkcert -install
The local CA is already installed in the system trust store! 👍
The local CA is already installed in the Firefox and/or Chrome/Chromium trust store! 👍


 --(239)--( user@system )-->  /home/sultan/.config/containers |-->  18:01:38 
 󱞩 mkdir -p ~/.conmkdir -p ~/.config/containers/{postgres,traefik,forgejo,authelia,lldap}

 --(240)--( user@system )-->  /home/sultan/.config/containers |-->  18:01:44 
 󱞩 mkdir -p ~/.conmkdir -p ~/.config/containers/traefik/{dynamic,certs}

 --(241)--( user@system )-->  /home/sultan/.config/containers |-->  18:01:48 
 󱞩 mkdir -p ~/.conmkdir -p ~/.config/containers/lldap/{data,config}

 --(242)--( user@system )-->  /home/sultan/.config/containers |-->  18:01:52 
 󱞩 cd ~/.config/cocd ~/.config/containers/traefik/certs

 --(243)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:01:58 
 󱞩 mkcert \
auth.local.test \
git.local.test \
ldap.local.test

Created a new certificate valid for the following names 📜
 - "auth.local.test"
 - "git.local.test"
 - "ldap.local.test"

The certificate is at "./auth.local.test+2.pem" and the key at "./auth.local.test+2-key.pem" ✅

It will expire on 22 August 2028 🗓


 --(244)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:02:10 
 󱞩 mv auth.local.tmv auth.local.test+2.pem local.test.crt
mv auth.local.test+2-key.pem local.test.key

 --(246)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:02:15 
 󱞩 ls
local.test.crt  local.test.key

 --(247)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:02:17 
 󱞩 openssl x509 \ openssl x509 \
-in ~/.config/containers/traefik/certs/local.test.crt \
-text -noout | grep -A1 "Subject Alternative"
            X509v3 Subject Alternative Name: 
                DNS:auth.local.test, DNS:git.local.test, DNS:ldap.local.test

 --(248)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:02:35 
 󱞩 nvim ~/.config/nvim ~/.config/containers/traefik/dynamic/dynamic.yml

 --(249)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:02:50 
 󱞩 podman run -d \podman run -d \
  --name postgres \
  --network homelab \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres123 \
  -v ~/.config/containers/postgres:/var/lib/postgresql/data:Z \
  docker.io/library/postgres:17
d17de8ebe2b94c5cf44ecf21983245073be8dee1bef5b0af0cb345c9d9d1202d

 --(250)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:02:59 
 󱞩 podman exec -itpodman exec -it postgres psql -U postgres
psql (17.10 (Debian 17.10-1.pgdg13+1))
Type "help" for help.

postgres=# CREATE DATABASE forgejo;
CREATE USER forgejo WITH ENCRYPTED PASSWORD 'forgejo123';
GRANT ALL PRIVILEGES ON DATABASE forgejo TO forgejo;

CREATE DATABASE authelia;
CREATE USER authelia WITH ENCRYPTED PASSWORD 'authelia123';
GRANT ALL PRIVILEGES ON DATABASE authelia TO authelia;

CREATE DATABASE lldap;
CREATE USER lldap WITH ENCRYPTED PASSWORD 'lldap123';
GRANT ALL PRIVILEGES ON DATABASE lldap TO lldap;
CREATE DATABASE
CREATE ROLE
GRANT
CREATE DATABASE
CREATE ROLE
GRANT
CREATE DATABASE
CREATE ROLE
GRANT
postgres=# \q

 --(251)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:03:13 
 󱞩 podman run -d \podman run -d \
  --name lldap \
  --network homelab \
  -p 17170:17170 \
  -p 3890:3890 \
  -v ~/.config/containers/lldap/data:/data:Z \
  -e LLDAP_JWT_SECRET=super-secret-jwt-token \
  -e LLDAP_KEY_SEED=super-secret-key-seed \
  -e LLDAP_LDAP_BASE_DN=dc=local,dc=test \
  -e LLDAP_LDAP_USER_PASS=admin123 \
  -e LLDAP_LDAP_USER_DN=admin \
  -e LLDAP_DATABASE_URL=postgres://lldap:lldap123@postgres:5432/lldap \
  docker.io/lldap/lldap:stable
ac5da7e8581dc53d6011dfa8ddbbc81bac3512c7fe278387fad730cfdbc5fbca

 --(252)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:03:30 
 󱞩 podman run -d \podman run -d \
  --name traefik \
  --network homelab \
  -p 8999:443 \
  -p 8080:8080 \
  -v /run/user/1000/podman/podman.sock:/var/run/docker.sock:ro \
  -v ~/.config/containers/traefik/dynamic:/dynamic:Z \
  -v ~/.config/containers/traefik/certs:/certs:Z \
  docker.io/library/traefik:v3 \
  --api.insecure=true \
  --providers.docker=true \
  --providers.docker.exposedbydefault=false \
  --providers.file.directory=/dynamic \
  --entrypoints.websecure.address=:443
5114cc1003d33b6e1efb38b9076b5b91264ca1951db398c4ad524a87e7510f3c

 --(253)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:03:33 
 󱞩 openssl rand -hopenssl rand -hex 64
cde3878cbdb245fbcd6248a93c18562cca8d67f5d0b81e3da6ea9224249333a0bf3dc0bccbc5d40661223f1050bf851114a88d25889b93e3f8279b13b5bfe8cc

 --(254)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:03:37 
 󱞩 openssl rand -hopenssl rand -hex 64
eeaf01cfa65d375cf0572f43a75d1a11a7c1d2b671e159d623ff3c69330fac3cb3b1131e57015eb4a2d7ab59d84f14608cb5b74709a63df49ff2be2976b5b90e

 --(255)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:03:41 
 󱞩 openssl rand -hopenssl rand -hex 64
0a8c8f4f6326d1d959456817b2baaeae3f414572d4ac8ea09ed83813d6d91be1ab8ebb4b461d2ee3f860aff72e23fb1f9f5684f2d8815dc682f53f0c9aaca52e

 --(256)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:03:44 
 󱞩 openssl rand -hopenssl rand -hex 64
59337659d78ddde63257a1d2b009f006e4e5cf78f9aeca5fc927f8217b923fed3502f8d3fca0af098d456276d8ad74939832a43ea3d53b4250dcb0d0a4a639a7

 --(257)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:03:48 
 󱞩 openssl genrsa openssl genrsa -out ~/.config/containers/authelia/private.pem 4096

 --(258)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:03:53 
 󱞩 nvim ~/.config/nvim ~/.config/containers/authelia/configuration.yml

 --(259)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:04:07 
 󱞩 nvim ~/.config/containers/authelia/configuration.yml

 --(260)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:04:22 
 󱞩 nvim ~/.config/containers/authelia/configuration.yml

 --(261)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:04:37 
 󱞩 nvim ~/.config/containers/authelia/configuration.yml

 --(262)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:04:51 
 󱞩 nvim ~/.config/containers/authelia/configuration.yml

 --(263)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:05:11 
 󱞩 nvim ~/.config/containers/authelia/configuration.yml

 --(264)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:05:26 
 󱞩 cat ~/.config/containers/authelia/
configuration.yml  private.pem        

 --(264)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:05:26 
 󱞩 cat ~/.config/containers/authelia/private.pem 
-----BEGIN PRIVATE KEY-----
MIIJQQIBADANBgkqhkiG9w0BAQEFAASCCSswggknAgEAAoICAQCdqkdbZfu34V5+
vyf+MBNn+yi68bbHb57YCJJn94NjZ8S8jxpOi8Lxg2Idsy+H8+OhCNr3wrmpPBMG
hadklr8+6ASb8IoRTYp2GEhggm+i9SOdyCi7n25f9sZ/L/mIbmgpqmTOlR1+bZeY
x5TtGvMyAVOMEMN8QMH9B8UkiDsZImQj4GoBqhUrLqDbONa9vjOYbRKQRAQd39z4
PlDsHSUSHaFfdA4zvcLU1BC3o8WB/E1mgrwkrzbJsSvFJay/j7vKHmKJsDddm9ok
uIAJzTtuZZq5G8neADzlKXTf+ilMo5oO9hAHXxws7scyU7z4Cabi4lq31vfzNSba
cUJOBWG+INvj6KOGj15nBmwdaMwYsr+MsPR2ZwiE2lijNdUC2UQci7JWVNxTYXZ7
eahbipmHnLs0oc7ALJytTSDcUSuOC5zKrdjuTzG73q0f1TIwLh8eW/STcXFOKTwW
zWGbfSa1eNVnpavwP62SC5nMfVt2GEkn4DyO4VxQjiL8lgnXxtc894/jDOhCyFcE
fTzzexb7cafd07FBl5i8vkGCQcj/v065ykzKkStwZpAJ+x2C05cGJm3HEuO5jaYG
U2aDwxEd7T4KzY2Ror8oqOKlLT1U23dZD0xrowSP07IGGvaIx9St/317rPGOBst0
C9hDpmnjNQvzFLHt+obiUqzotY/J4QIDAQABAoICAAhtM1QCB+2CjeMM7wuTqNbc
7mbq8C2ZtHH4B9CnErpxb2szRAj8iOhQ8QGUvAqqbSEkRLU7HuKJ1Zu6sRkUAj/P
xV7LAOsWs4q3JqejUwmA6/TU78Hi3hKikSZ3M0FQotAuxWVh5H4XSAPcL2RKhWLX
3a3xz6vkd2XBWH7Yyd1QmGzvM6U4AJqCqwnacGY63B22fyhvHS/2UPRi2r762gpN
Q3yjOpbW+pq2xJe3COFnEWE0Ja95fp5yIdxvJHvmyAbv/6zbmmLuN28Q3hWABsAS
Tb4c20m6ZibKk968a2CHai6IZdAKDBrF7ocs4O+6DtWHmukCVBVXYvan+N7sBFaw
Q6I6SQYVAotPHhm5pbBIQWgi6hrMhEiQPspBiiYpd72sv4AsEuur67pzVJLAlLTy
70AnN+kN3/R+HgCUrP9mrQVN19nr+HRDaTeJpu/u+taXqF8UXAOZSj7o6wKaj4fy
jmo103F4GXlGTcj4EGMleniEjBrloOwUmDs0XSXbIMTY/wEfuB9JD3kiOdaAuS5m
X6MW+cE4Zw2wc+yg/UkW2PMRDQOmfhIlck08l6Uq8sAp1tch+xrvmOYx+5l67uSE
G20EaWdm1ZiHpUqz4mHNOQBFOm8b8KNl1+gujRSicMVF/kmQVedL4odTaSpf006O
0LO4AK6DLHs0xkjencyxAoIBAQDQ7MX7hspzDUZUhR27xWXKb0fCiOcbI7OW537C
0uXPCwSLhhRSOHX238mKpXSUTudsGy55aZc9bzNqj/wYexnASFEf8VvSC8upjWwW
sx+YafrTey+QZ3PetH8lvQKLb6tQjujM5tGYwHiNZu1za3wU/fqFy44jK1JI7D04
S9CzzijtBRVrSrFcdgsBLQ8Y8mAmcvm09amTcL+I4a9GJuKXpo4UAZVq9a2wAv3x
pNTGZRfTkDuQvObccneB8+ERLgtkKsZ110hXSRNHmGV2mq41k2et2nkiKq/1BgPO
bVOcT+jyjSb/iI3CeuhF+3lq4JSGR/l4D4CNde3VR5EIzowxAoIBAQDBMLxVfTgQ
MYyYfjexRYD4cVlSZ0lvWBCWIKH3H8Du10Lk7kEQWc0MIaDunw9Gw1OI0lZ91DMo
x0h7dGFiebdAek2hR4w3Z7Va6mqgN6lzpvIQFINbpfpopxsHriI4ADnvm06PV9ji
ERAZa+QUQflDsC7titasb3U+xezn7ZmksoSZJS5aueli3sgN5kxV7I7wJ/ZE8Ox2
Bgrwb6MLWmj5Aah1GVyIi7WoHZXi5j2g0DleOb3JcIOkqlWdEsRGnTWzBteepNiO
BUeM1dnfWP0hHrNYYGU/5A8hgEv0h4y3nCj9tssrXk/EyoMph9L2Z+kiKN0+aiig
HPtlZrh4w5yxAoIBAFUVuGOBN323kEbnl35bG+NfgngFTSlOVttEF+m7/f9d21H/
HtOFTvVlmiyuyVWE9NagE0M6728DlIr3bJGDwK8ARJmfr+dRCnZYtAZimKF3t8Dc
0DgdCaFPHOD/osOqjLhYGxMnhYCSEgZ0Povc4EGkVZybk51bDT3Jh/0fUzWG5j/w
7BIv7x9aq4ylDxr3ypSeCnfZ/F+hcT+Ludf2Ch38pKwdIP7YYw3ligoZONY7YYK1
oKyHYfWxYF46NhTLDbSTfxOKw1lY11M3C0tMH1qOV5EEAoUZoWNGOdKdz4k/Of1d
4t36fNERQPsPORl/sL0nHr/4gEAcIOnVJYnSpGECggEAdnsuNfvq4zuQL4HRJB4t
P7E8h6Yiym+nFHuE+at2xsQsGXzpWF7Ku3LwYQgZ9VsboyDkvJzkl1DI6jXw99UQ
BzI64/ueSeiHt+9mX0Zj3TL459W8zftYPNCnailogRHadlG4d37324V9aynZIndn
qRSnYzWv/OcKb+oxJfh5LyHw4n+EE05LjUB2Ttf73wKKk0ze418iliuUj+rXgsH6
+SQELXTVZETSrv0eDJ8KEtNBK8Gb3KvtgJKamQ+GYoxN/7LlkD0nNsqUHBKXYTwR
Wjua4EuWLP3wLaqiaqCrM3xJQ3jU148qutU8Zb8QKeCGgVWwgnPW4IOFxqWd4yqM
sQKCAQB2+y94cyMoTjsoK8gX6B4bOWmhcMjknNPFjIXMemmQKnBEHEDsLxPFTmi3
EwAjwxJ/4ElLj4OQcvn3oul5hoKcPsOjMgyfXxBz1tHK2ZntXp5JloD18c8Nw0cO
IOji2R2/5hNmFF5DjafCPP8XTmje3u9otU4vlAQT2zs0KPjwsnhq+kJlKxyuV0Up
TDQ+htSWn4fpxbHMHD5tXQPgnXKbwQnV6KaE3Ljdsogjz40iqIrocO22/U48KKVJ
RIzXV4t2HwMF5IF1Wssrsw4+364o09f+Bvqdqn/OsnoSjwV3arw2oRwSg9iw2+Xh
tSIakDEwl2puyuXOlIiuWSZR1wao
-----END PRIVATE KEY-----

 --(265)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:05:51 
 󱞩 cat ~/.config/cnvim ~/.config/containers/authelia/configuration.yml

 --(266)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:07:43 
 󱞩 podman run -d \podman run -d \
  --name authelia \
  --network homelab \
  -v ~/.config/containers/authelia:/config:Z \
  -l traefik.enable=true \
  -l traefik.http.routers.authelia.rule=Host(`auth.local.test`) \
  -l traefik.http.routers.authelia.entrypoints=websecure \
  -l traefik.http.routers.authelia.tls=true \
  -l traefik.http.services.authelia.loadbalancer.server.port=9091 \
  docker.io/authelia/authelia:latest
bash: syntax error near unexpected token `('
bash: -l: command not found

 --(267)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:07:55 
 󱞩 podman run -d \podman run -d \
  --name forgejo \
  --network homelab \
  -v ~/.config/containers/forgejo:/data:Z \
  -e USER_UID=1000 \
  -e USER_GID=1000 \
  -e FORGEJO__database__DB_TYPE=postgres \
  -e FORGEJO__database__HOST=postgres:5432 \
  -e FORGEJO__database__NAME=forgejo \
  -e FORGEJO__database__USER=forgejo \
  -e FORGEJO__database__PASSWD=forgejo123 \
  -e FORGEJO__server__ROOT_URL=https://git.local.test:8999/ \
  -e FORGEJO__server__DOMAIN=git.local.test \
  -e FORGEJO__server__PROTOCOL=http \
  -e FORGEJO__server__HTTP_PORT=3000 \
  -l traefik.enable=true \
  -l traefik.http.routers.forgejo.rule=Host(`git.local.test`) \
  -l traefik.http.routers.forgejo.entrypoints=websecure \
  -l traefik.http.routers.forgejo.tls=true \
  -l traefik.http.services.forgejo.loadbalancer.server.port=3000 \
  codeberg.org/forgejo/forgejo:15
bash: syntax error near unexpected token `('
bash: -l: command not found

 --(268)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:08:13 
 󱞩 podman run -d \podman run -d \
  --name authelia \
  --network homelab \
  -v ~/.config/containers/authelia:/config:Z \
  -l 'traefik.enable=true' \
  -l 'traefik.http.routers.authelia.rule=Host(`auth.local.test`)' \
  -l 'traefik.http.routers.authelia.entrypoints=websecure' \
  -l 'traefik.http.routers.authelia.tls=true' \
  -l 'traefik.http.services.authelia.loadbalancer.server.port=9091' \
  docker.io/authelia/authelia:latest
9c6cd85ca489257d5a0355b4260ea2780ea33ed3366a3267245e36c6775d7a19

 --(269)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:08:48 
 󱞩 podman run -d \podman run -d \
  --name forgejo \
  --network homelab \
  -v ~/.config/containers/forgejo:/data:Z \
  -e USER_UID=1000 \
  -e USER_GID=1000 \
  -e FORGEJO__database__DB_TYPE=postgres \
  -e FORGEJO__database__HOST=postgres:5432 \
  -e FORGEJO__database__NAME=forgejo \
  -e FORGEJO__database__USER=forgejo \
  -e FORGEJO__database__PASSWD=forgejo123 \
  -e FORGEJO__server__ROOT_URL=https://git.local.test:8999/ \
  -e FORGEJO__server__DOMAIN=git.local.test \
  -e FORGEJO__server__PROTOCOL=http \
  -e FORGEJO__server__HTTP_PORT=3000 \
  -l 'traefik.enable=true' \
  -l 'traefik.http.routers.forgejo.rule=Host(`git.local.test`)' \
  -l 'traefik.http.routers.forgejo.entrypoints=websecure' \
  -l 'traefik.http.routers.forgejo.tls=true' \
  -l 'traefik.http.services.forgejo.loadbalancer.server.port=3000' \
  codeberg.org/forgejo/forgejo:15
4a2c0a0e8403d867cbbd58acb643b974023b1cffc23aa2d4b496b991cc6743ab

 --(270)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:08:54 
 󱞩 curl -k https:/curl -k https://auth.local.test:8999
404 page not found

 --(271)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:09:03 
 󱞩 curl -k https:/curl -k https://git.local.test:8999
<!DOCTYPE html>
<html lang="en-US" data-theme="forgejo-auto">
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<title>Installation - Forgejo: Beyond coding. We forge.</title>
	<link rel="manifest" href="/manifest.json">
	<meta name="author" content="Forgejo – Beyond coding. We forge.">
	<meta name="description" content="Forgejo is a self-hosted lightweight software forge. Easy to install and low maintenance, it just does the job.">
	<meta name="keywords" content="git,forge,forgejo">
	<meta name="referrer" content="strict-origin">


	<link rel="icon" href="/assets/img/favicon.svg" type="image/svg+xml">
	<link rel="alternate icon" href="/assets/img/favicon.png" type="image/png">
	
<script>
	
	window.addEventListener('error', function(e) {window._globalHandlerErrors=window._globalHandlerErrors||[]; window._globalHandlerErrors.push(e);});
	window.addEventListener('unhandledrejection', function(e) {window._globalHandlerErrors=window._globalHandlerErrors||[]; window._globalHandlerErrors.push(e);});
	window.config = {
		appUrl: 'https:\/\/git.local.test:8999\/',
		appSubUrl: '',
		assetVersionEncoded: encodeURIComponent('15.0.2~gitea-1.22.0'), 
		assetUrlPrefix: '\/assets',
		runModeIsProd:  true ,
		customEmojis: new Set(["git","gitea","codeberg","gitlab","github","gogs","forgejo"]),
		pageData:  null ,
		notificationSettings: {"EventSourceUpdateTime":10000,"MaxTimeout":60000,"MinTimeout":10000,"TimeoutStep":10000}, 
		enableTimeTracking:  true ,
		
		mermaidMaxSourceCharacters:  50000 ,
		
		i18n: {
			copy_success: "Copied!",
			copy_error: "Copy failed",
			error_occurred: "An error occurred",
			network_error: "Network error",
			remove_label_str: "Remove item \"%s\"",
			modal_confirm: "Confirm",
			modal_cancel: "Cancel",
			more_items: "More items",
			incorrect_root_url: "This Forgejo instance is configured to be served on \"https://git.local.test:8999/\". You are currently viewing Forgejo through a different URL, which may cause parts of the application to break. The canonical URL is controlled by Forgejo admins via the ROOT_URL setting in the app.ini.",
		},
	};
	
	window.config.pageData = window.config.pageData || {};
</script>
<script src="/assets/js/webcomponents.js?v=15.0.2~gitea-1.22.0"></script>

	

	
	<meta property="og:title" content="Installation">


	<meta property="og:url" content="https://git.local.test:8999/">


	<meta property="og:type" content="website">


		<meta property="og:image" content="/assets/img/logo.png">

<meta property="og:site_name" content="Forgejo: Beyond coding. We forge.">

	<link rel="stylesheet" href="/assets/css/index.css?v=15.0.2~gitea-1.22.0">
<link rel="stylesheet" href="/assets/css/theme-forgejo-auto.css?v=15.0.2~gitea-1.22.0">

	
</head>
<body class="no-js" hx-swap="outerHTML" hx-ext="morph" hx-push-url="false">
	

	<div class="full height">
		<noscript>
			<div class="tw-ml-2 tw-mr-2 tw-text-center tw-text-text-light-2">This website requires JavaScript.</div>
		</noscript>

		

		



<div role="main" aria-label="Installation" class="page-content install">
	<div class="ui grid install-config-container">
		<div class="sixteen wide center aligned centered column">
			<h3 class="ui top attached header">
				Initial configuration
			</h3>
			<div class="ui attached segment">
				




	<div id="flash-message" hx-swap-oob="true"></div>



				<form class="ui form" action="/" method="post">
					<p class="tw-mt-0">If you run Forgejo inside Docker, please read the <a target="_blank" rel="noopener noreferrer" href="https://forgejo.org/docs/latest/admin/installation-docker/">documentation</a> before changing any settings.</p>

					
					<h4 class="ui dividing header">Database settings</h4>
					<p>Forgejo requires MySQL, PostgreSQL, SQLite3 or TiDB (MySQL protocol).</p>
					<div class="inline required field ">
						<label>Database type</label>
						<div class="ui selection database type dropdown">
							<input type="hidden" id="db_type" name="db_type" value="postgres">
							<div class="text">postgres</div>
							<svg viewBox="0 0 16 16" class="dropdown icon svg octicon-triangle-down" aria-hidden="true" width="14" height="14"><path d="m4.427 7.427 3.396 3.396a.25.25 0 0 0 .354 0l3.396-3.396A.25.25 0 0 0 11.396 7H4.604a.25.25 0 0 0-.177.427"/></svg>
							<div class="menu">
								
									<div class="item" data-value="mysql">MySQL</div>
								
									<div class="item" data-value="postgres">PostgreSQL</div>
								
									<div class="item" data-value="sqlite3">SQLite3</div>
								
							</div>
						</div>
					</div>

					<div class="tw-mt-4 tw-hidden" data-db-setting-for="common-host">
						<div class="inline required field ">
							<label for="db_host">Host</label>
							<input id="db_host" name="db_host" value="postgres:5432">
						</div>
						<div class="inline required field ">
							<label for="db_user">Username</label>
							<input id="db_user" name="db_user" value="forgejo">
						</div>
						<div class="inline required field ">
							<label for="db_passwd">Password</label>
							<input id="db_passwd" name="db_passwd" type="password" value="forgejo123">
						</div>
						<div class="inline required field ">
							<label for="db_name">Database name</label>
							<input id="db_name" name="db_name" value="forgejo">
						</div>
					</div>

					<div class="tw-mt-4 tw-hidden" data-db-setting-for="postgres">
						<div class="inline required field">
							<label>SSL</label>
							<div class="ui selection database type dropdown">
								<input type="hidden" name="ssl_mode" value="disable">
								<div class="default text">disable</div>
								<svg viewBox="0 0 16 16" class="dropdown icon svg octicon-triangle-down" aria-hidden="true" width="14" height="14"><path d="m4.427 7.427 3.396 3.396a.25.25 0 0 0 .354 0l3.396-3.396A.25.25 0 0 0 11.396 7H4.604a.25.25 0 0 0-.177.427"/></svg>
								<div class="menu">
									<div class="item" data-value="disable">Disable</div>
									<div class="item" data-value="require">Require</div>
									<div class="item" data-value="verify-full">Verify Full</div>
								</div>
							</div>
						</div>
						<div class="inline field ">
							<label for="db_schema">Schema</label>
							<input id="db_schema" name="db_schema" value="">
							<span class="help">Leave blank for database default ("public").</span>
						</div>
					</div>

					<div class="tw-mt-4 tw-hidden" data-db-setting-for="sqlite3">
						<div class="inline required field ">
							<label for="db_path">Path</label>
							<input id="db_path" name="db_path" value="/data/gitea/gitea.db">
							<span class="help">File path for the SQLite3 database.<br>Enter an absolute path if you run Forgejo as a service.</span>
						</div>
					</div>

					

					
					<h4 class="ui dividing header">General settings</h4>
					<div class="inline required field ">
						<label for="app_name">Instance title</label>
						<input id="app_name" name="app_name" value="Forgejo" required>
						<span class="help">Enter your instance name here. It will be displayed on every page.</span>
					</div>
					<div class="inline field">
						<label for="app_slogan">Instance slogan</label>
						<input id="app_slogan" name="app_slogan" value="Beyond coding. We Forge.">
						<span class="help">Enter your instance slogan here. Leave empty to disable.</span>
					</div>
					<div class="inline required field ">
						<label for="repo_root_path">Repository root path</label>
						<input id="repo_root_path" name="repo_root_path" value="/data/git/repositories" required>
						<span class="help">Remote Git repositories will be saved to this directory.</span>
					</div>
					<div class="inline field ">
						<label for="lfs_root_path">Git LFS root path</label>
						<input id="lfs_root_path" name="lfs_root_path" value="/data/git/lfs">
						<span class="help">Files tracked by Git LFS will be stored in this directory. Leave empty to disable.</span>
					</div>
					<div class="inline required field ">
						<label for="run_user">User to run as</label>
						<input id="run_user" name="run_user" value="git" readonly>
						<span class="help">The operating system username that Forgejo runs as. Note that this user must have access to the repository root path.</span>
					</div>
					<div class="inline required field">
						<label for="domain">Server domain</label>
						<input id="domain" name="domain" value="git.local.test" placeholder="next.forgejo.org" required>
						<span class="help">Domain or host address for the server.</span>
					</div>
					<div class="inline field">
						<label for="ssh_port">SSH server port</label>
						<input id="ssh_port" name="ssh_port" value="22">
						<span class="help">Port number that will be used by the SSH server. Leave empty to disable SSH server.</span>
					</div>
					<div class="inline required field">
						<label for="http_port">HTTP listen port</label>
						<input id="http_port" name="http_port" value="3000" required>
						<span class="help">Port number that will be used by the Forgejo web server.</span>
					</div>
					<div class="inline required field">
						<label for="app_url">Base URL</label>
						<input id="app_url" name="app_url" value="https://git.local.test:8999/" placeholder="https://next.forgejo.org" required>
						<span class="help">Base address for HTTP(S) clone URLs and email notifications.</span>
					</div>
					<div class="inline required field">
						<label for="log_root_path">Log path</label>
						<input id="log_root_path" name="log_root_path" value="/data/gitea/log" placeholder="log" required>
						<span class="help">Log files will be written to this directory.</span>
					</div>
					<div class="inline field">
						<div class="ui checkbox" id="disable-registration">
							<label class="">Disable self-registration</label>
							<input name="disable_registration" type="checkbox" checked>
						</div>
						<span class="help">Only instance administrators will be able to create new user accounts. It is highly recommended to keep registration disabled unless you intend to host a public instance for everyone and ready to deal with large amounts of spam accounts.</span>
					</div>
					<div class="inline field">
						<div class="ui checkbox">
							<label>Enable update checker</label>
							<input name="enable_update_checker" type="checkbox" checked>
						</div>
						<span class="help">It will periodically check for new Forgejo versions by checking a TXT DNS record at release.forgejo.org.</span>
					</div>

					
					<h4 class="ui dividing header">Optional settings</h4>

					
					<details class="collapsible optional field">
						<summary class="tw-py-2">
							Email settings
						</summary>
						<div class="inline field">
							<label for="smtp_addr">SMTP host</label>
							<input id="smtp_addr" name="smtp_addr" value="">
						</div>
						<div class="inline field">
							<label for="smtp_port">SMTP port</label>
							<input id="smtp_port" name="smtp_port" value="">
						</div>
						<div class="inline field ">
							<label for="smtp_from">Send email as</label>
							<input id="smtp_from" name="smtp_from" value="">
							<span class="help">Email address Forgejo will use. Enter a plain email address or use the &#34;Name&#34; &lt;email@example.com&gt; format.</span>
						</div>
						<div class="inline field ">
							<label for="smtp_user">SMTP username</label>
							<input id="smtp_user" name="smtp_user" value="">
						</div>
						<div class="inline field">
							<label for="smtp_passwd">SMTP password</label>
							<input id="smtp_passwd" name="smtp_passwd" type="password" value="">
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Require email confirmation to register</label>
								<input name="register_confirm" type="checkbox" >
							</div>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Enable email notifications</label>
								<input name="mail_notify" type="checkbox" >
							</div>
						</div>
					</details>

					
					<details class="collapsible optional field">
						<summary class="tw-py-2">
							Server and third-party service settings
						</summary>
						<div class="inline field">
							<div class="ui checkbox" id="offline-mode">
								<label>Enable local mode</label>
								<input name="offline_mode" type="checkbox" checked>
							</div>
							<span class="help">Disable third-party content delivery networks and serve all resources locally.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="disable-gravatar">
								<label>Disable Gravatar</label>
								<input name="disable_gravatar" type="checkbox" checked>
							</div>
							<span class="help">Disable usage of Gravatar or other third-party avatar sources. Default images will be used for user avatars unless they upload their own avatar to the instance.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="federated-avatar-lookup">
								<label>Enable federated avatars</label>
								<input name="enable_federated_avatar" type="checkbox" >
							</div>
							<span class="help">Look up avatars using Libravatar.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="enable-openid-signin">
								<label>Enable OpenID sign-in</label>
								<input name="enable_open_id_sign_in" type="checkbox" checked>
							</div>
							<span class="help">Allow users to sign in via OpenID.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="allow-only-external-registration">
								<label>Allow registration only via external services</label>
								<input name="allow_only_external_registration" type="checkbox" >
							</div>
							<span class="help">Users will only be able to create new accounts by using configured external services.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="enable-openid-signup">
								<label>Enable OpenID self-registration</label>
								<input name="enable_open_id_sign_up" type="checkbox" checked>
							</div>
							<span class="help">Allow users to create accounts via OpenID if self-registration is enabled.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="enable-captcha">
								<label>Enable registration CAPTCHA</label>
								<input name="enable_captcha" type="checkbox" >
							</div>
							<span class="help">Require users to pass CAPTCHA in order to create accounts.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Require to sign-in to view instance content</label>
								<input name="require_sign_in_view" type="checkbox" >
							</div>
							<span class="help">Limit content access to signed-in users. Guests will only be able to visit the authentication pages.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Hide email addresses by default</label>
								<input name="default_keep_email_private" type="checkbox" >
							</div>
							<span class="help">Enable email address hiding for new users by default so that this information is not leaked immediately after signing up.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Allow creation of organizations by default</label>
								<input name="default_allow_create_organization" type="checkbox" checked>
							</div>
							<span class="help">Allow new users to create organizations by default. When this option is disabled, an admin will have to grant a permission for creating organizations to new users.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Enable time tracking by default</label>
								<input name="default_enable_timetracking" type="checkbox" checked>
							</div>
							<span class="help">Allow usage of time tracking feature for new repositories by default.</span>
						</div>
						<div class="inline field">
							<label for="no_reply_address">Hidden email domain</label>
							<input id="_no_reply_address" name="no_reply_address" value="noreply.git.local.test">
							<span class="help">Domain name for users with a hidden email address. For example, the username "joe" will be logged in Git as "joe@noreply.example.org" if the hidden email domain is set to "noreply.example.org".</span>
						</div>
						<div class="inline field">
							<label for="password_algorithm">Password hash algorithm</label>
							<div class="ui selection dropdown">
								<input id="password_algorithm" type="hidden" name="password_algorithm" value="pbkdf2_hi">
								<div class="text">pbkdf2_hi</div>
								<svg viewBox="0 0 16 16" class="dropdown icon svg octicon-triangle-down" aria-hidden="true" width="14" height="14"><path d="m4.427 7.427 3.396 3.396a.25.25 0 0 0 .354 0l3.396-3.396A.25.25 0 0 0 11.396 7H4.604a.25.25 0 0 0-.177.427"/></svg>
								<div class="menu">
									
										<div class="item" data-value="pbkdf2">pbkdf2</div>
									
										<div class="item" data-value="argon2">argon2</div>
									
										<div class="item" data-value="bcrypt">bcrypt</div>
									
										<div class="item" data-value="scrypt">scrypt</div>
									
										<div class="item" data-value="pbkdf2_hi">pbkdf2_hi</div>
									
								</div>
							</div>
							<span class="help">Set the password hashing algorithm. Algorithms have differing requirements and strengths. The argon2 algorithm is rather secure but uses a lot of memory and may be inappropriate for small systems.</span>
						</div>
					</details>

					
					<details class="collapsible optional field">
						<summary class="tw-py-2">
							Administrator account settings
						</summary>
						<p class="center">Creating an administrator account is optional. The first registered user will automatically become an administrator.</p>
						<div class="inline field ">
							<label for="admin_name">Administrator username</label>
							<input id="admin_name" name="admin_name" value="">
						</div>
						<div class="inline field ">
							<label for="admin_email">Email address</label>
							<input id="admin_email" name="admin_email" type="email" value="">
						</div>
						<div class="inline field ">
							<label for="admin_passwd">Password</label>
							<input id="admin_passwd" name="admin_passwd" type="password" autocomplete="new-password" value="">
						</div>
						<div class="inline field ">
							<label for="admin_confirm_passwd">Confirm password</label>
							<input id="admin_confirm_passwd" name="admin_confirm_passwd" autocomplete="new-password" type="password" value="">
						</div>
					</details>

					<div class="divider"></div>

					

					<p>These configuration options will be saved in: /data/gitea/conf/app.ini</p>
					<div class="inline field">
						<div class="tw-mt-4 tw-mb-2 tw-text-center">
							<button class="ui primary button">Install Forgejo</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<img class="tw-hidden" src="/assets/img/forgejo-loading.svg" alt="Loading…" width="256" height="256">


	

	</div>

	

	<footer class="page-footer" role="group" aria-label="Footer">
	<div class="left-links" role="contentinfo" aria-label="About this software">
		
			<a target="_blank" rel="noopener noreferrer" href="https://forgejo.org">Powered by Forgejo</a>
		
		
			Version:
			
				15.0.2
			
		
		
			Page: <strong>5ms</strong>
			Template: <strong>4ms</strong>
		
	</div>
	<div class="right-links" role="group" aria-label="Links">
		<div class="ui dropdown upward language">
			<span class="flex-text-inline"><svg viewBox="0 0 16 16" class="svg octicon-globe" aria-hidden="true" width="14" height="14"><path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0M5.78 8.75a9.64 9.64 0 0 0 1.363 4.177q.383.64.857 1.215c.245-.296.551-.705.857-1.215A9.64 9.64 0 0 0 10.22 8.75Zm4.44-1.5a9.64 9.64 0 0 0-1.363-4.177c-.307-.51-.612-.919-.857-1.215a10 10 0 0 0-.857 1.215A9.64 9.64 0 0 0 5.78 7.25Zm-5.944 1.5H1.543a6.51 6.51 0 0 0 4.666 5.5q-.184-.271-.352-.552c-.715-1.192-1.437-2.874-1.581-4.948m-2.733-1.5h2.733c.144-2.074.866-3.756 1.58-4.948q.18-.295.353-.552a6.51 6.51 0 0 0-4.666 5.5m10.181 1.5c-.144 2.074-.866 3.756-1.58 4.948q-.18.296-.353.552a6.51 6.51 0 0 0 4.666-5.5Zm2.733-1.5a6.51 6.51 0 0 0-4.666-5.5q.184.272.353.552c.714 1.192 1.436 2.874 1.58 4.948Z"/></svg> English</span>
			<div class="menu language-menu">
				
					<a lang="id-ID" data-url="/?lang=id-ID" class="item ">Bahasa Indonesia</a>
				
					<a lang="da" data-url="/?lang=da" class="item ">Dansk</a>
				
					<a lang="de-DE" data-url="/?lang=de-DE" class="item ">Deutsch</a>
				
					<a lang="en-US" data-url="/?lang=en-US" class="item active selected">English</a>
				
					<a lang="es-ES" data-url="/?lang=es-ES" class="item ">Español</a>
				
					<a lang="eo" data-url="/?lang=eo" class="item ">Esperanto</a>
				
					<a lang="fil" data-url="/?lang=fil" class="item ">Filipino</a>
				
					<a lang="fr-FR" data-url="/?lang=fr-FR" class="item ">Français</a>
				
					<a lang="it-IT" data-url="/?lang=it-IT" class="item ">Italiano</a>
				
					<a lang="lv-LV" data-url="/?lang=lv-LV" class="item ">Latviešu</a>
				
					<a lang="hu-HU" data-url="/?lang=hu-HU" class="item ">Magyar nyelv</a>
				
					<a lang="nl-NL" data-url="/?lang=nl-NL" class="item ">Nederlands</a>
				
					<a lang="nds" data-url="/?lang=nds" class="item ">Plattdüütsch</a>
				
					<a lang="pl-PL" data-url="/?lang=pl-PL" class="item ">Polski</a>
				
					<a lang="pt-PT" data-url="/?lang=pt-PT" class="item ">Português de Portugal</a>
				
					<a lang="pt-BR" data-url="/?lang=pt-BR" class="item ">Português do Brasil</a>
				
					<a lang="sl" data-url="/?lang=sl" class="item ">Slovenščina</a>
				
					<a lang="fi-FI" data-url="/?lang=fi-FI" class="item ">Suomi</a>
				
					<a lang="sv-SE" data-url="/?lang=sv-SE" class="item ">Svenska</a>
				
					<a lang="tr-TR" data-url="/?lang=tr-TR" class="item ">Türkçe</a>
				
					<a lang="cs-CZ" data-url="/?lang=cs-CZ" class="item ">Čeština</a>
				
					<a lang="el-GR" data-url="/?lang=el-GR" class="item ">Ελληνικά</a>
				
					<a lang="bg" data-url="/?lang=bg" class="item ">Български</a>
				
					<a lang="ru-RU" data-url="/?lang=ru-RU" class="item ">Русский</a>
				
					<a lang="uk-UA" data-url="/?lang=uk-UA" class="item ">Українська</a>
				
					<a lang="fa-IR" data-url="/?lang=fa-IR" class="item ">فارسی</a>
				
					<a lang="ja-JP" data-url="/?lang=ja-JP" class="item ">日本語</a>
				
					<a lang="zh-CN" data-url="/?lang=zh-CN" class="item ">简体中文</a>
				
					<a lang="zh-TW" data-url="/?lang=zh-TW" class="item ">繁體中文（台灣）</a>
				
					<a lang="zh-HK" data-url="/?lang=zh-HK" class="item ">繁體中文（香港）</a>
				
					<a lang="ko-KR" data-url="/?lang=ko-KR" class="item ">한국어</a>
				
			</div>
		</div>
		<a href="/assets/licenses.txt">Licenses</a>
		<a href="/api/swagger">API</a>
		
	</div>
</footer>


	<script src="/assets/js/index.js?v=15.0.2~gitea-1.22.0" onerror="alert('Failed to load asset files from {path}. Please make sure the asset files can be accessed.'.replace('{path}', this.src))"></script>

	
</body>
</html>


 --(272)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:09:12 
 󱞩 curl -k https:/curl -k https://auth.local.test:8999
404 page not found

 --(273)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:09:18 
 󱞩 podman rm -f trpodman rm -f traefik
traefik

 --(274)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:09:48 
 󱞩 mkdir -p ~/.conmkdir -p ~/.config/containers/traefik/dynamic

 --(275)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:09:54 
 󱞩 nvim ~/.config/nvim ~/.config/containers/traefik/dynamic/dynamic.yml

 --(276)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:10:27 
 󱞩 podman run -d \podman run -d \
  --name traefik \
  --network homelab \
  -p 8999:443 \
  -p 8080:8080 \
  -v ~/.config/containers/traefik/dynamic:/dynamic:Z \
  -v ~/.config/containers/traefik/certs:/certs:Z \
  docker.io/library/traefik:v3 \
  --api.insecure=true \
  --providers.file.directory=/dynamic \
  --entrypoints.websecure.address=:443
4208c9dff45160da9058609d7ff73e6b9a383cbe7390a459c1fbd161ecfa11d3

 --(277)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:10:35 
 󱞩 podman ps
CONTAINER ID  IMAGE                            COMMAND               CREATED             STATUS             PORTS                                                  NAMES
d17de8ebe2b9  docker.io/library/postgres:17    postgres              7 minutes ago       Up 7 minutes       5432/tcp                                               postgres
4a2c0a0e8403  codeberg.org/forgejo/forgejo:15  /usr/bin/s6-svsca...  About a minute ago  Up About a minute  22/tcp, 3000/tcp                                       forgejo
4208c9dff451  docker.io/library/traefik:v3     --api.insecure=tr...  1 second ago        Up 2 seconds       0.0.0.0:8080->8080/tcp, 0.0.0.0:8999->443/tcp, 80/tcp  traefik

 --(278)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:10:37 
 󱞩 podman logs -f authelia 
time="2026-05-22T11:08:48Z" level=debug msg="Loaded Configuration Sources" files="[/config/configuration.yml]" filters="[]"
time="2026-05-22T11:08:48Z" level=debug msg="Logging Initialized" fields.level=debug file= format= keep_stdout=false
time="2026-05-22T11:08:48Z" level=debug msg="Process user information" gid=0 name=root uid=0 username=root
time="2026-05-22T11:08:48Z" level=warning msg="Configuration: access_control: no rules have been specified so the 'default_policy' of 'one_factor' is going to be applied to all requests"
time="2026-05-22T11:08:48Z" level=warning msg="Configuration: identity_providers: oidc: clients: client 'forgejo': option 'client_secret' is plaintext but for clients not using any endpoint authentication method 'client_secret_jwt' it should be a hashed value as plaintext values are deprecated with the exception of 'client_secret_jwt' and will be removed in the near future"
time="2026-05-22T11:08:48Z" level=info msg="Authelia v4.39.19 is starting"
time="2026-05-22T11:08:48Z" level=info msg="Log severity set to debug"
time="2026-05-22T11:08:48Z" level=debug msg="Registering OpenID Connect 1.0 client with client id 'forgejo' and policy 'one_factor'"
time="2026-05-22T11:08:48Z" level=info msg="Storage schema is being checked for updates"
time="2026-05-22T11:08:48Z" level=info msg="Storage schema migration from 0 to 23 is being attempted"
time="2026-05-22T11:08:48Z" level=error msg="Error occurred running a startup check" error="error during schema migrate: migration rollback complete. rollback caused by: schema migration 1 (Initial Schema) failed: ERROR: permission denied for schema public (SQLSTATE 42501)" provider=storage stack="github.com/authelia/authelia/v4/internal/middlewares/startup.go:96 doStartupCheck\ngithub.com/authelia/authelia/v4/internal/middlewares/startup.go:31 (*Providers).StartupChecks\ngithub.com/authelia/authelia/v4/internal/commands/root.go:90       (*CmdCtx).RootRunE\ngithub.com/spf13/cobra@v1.10.2/command.go:1015                     (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148                     (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071                     (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11            main\ninternal/runtime/atomic/types.go:194                               (*Uint32).Load\nruntime/asm_amd64.s:1771                                           goexit"
time="2026-05-22T11:08:48Z" level=error msg="Error occurred running a startup check" error="error occurred dialing address: error occurred attempting to dial LDAP server at 'ldap://lldap:3890': LDAP Result Code 200 \"Network Error\": dial tcp: lookup lldap on 10.89.0.1:53: no such host" provider=user stack="github.com/authelia/authelia/v4/internal/middlewares/startup.go:96 doStartupCheck\ngithub.com/authelia/authelia/v4/internal/middlewares/startup.go:34 (*Providers).StartupChecks\ngithub.com/authelia/authelia/v4/internal/commands/root.go:90       (*CmdCtx).RootRunE\ngithub.com/spf13/cobra@v1.10.2/command.go:1015                     (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148                     (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071                     (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11            main\ninternal/runtime/atomic/types.go:194                               (*Uint32).Load\nruntime/asm_amd64.s:1771                                           goexit"
time="2026-05-22T11:08:48Z" level=debug msg="webauthn-metadata provider: startup check skipped as it is disabled"
time="2026-05-22T11:08:48Z" level=fatal msg="One or more providers had fatal failures performing startup checks, for more details check the error level logs" providers="[user storage]" stack="github.com/authelia/authelia/v4/internal/commands/root.go:93 (*CmdCtx).RootRunE\ngithub.com/spf13/cobra@v1.10.2/command.go:1015               (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148               (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071               (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11      main\ninternal/runtime/atomic/types.go:194                         (*Uint32).Load\nruntime/asm_amd64.s:1771                                     goexit"

 --(279)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:10:46 
 󱞩 curl -k https:/curl -k https://auth.local.test:8999
Bad Gateway
 --(280)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:11:00 
 󱞩 curl -k https:/curl -k https://git.local.test:8999
<!DOCTYPE html>
<html lang="en-US" data-theme="forgejo-auto">
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<title>Installation - Forgejo: Beyond coding. We forge.</title>
	<link rel="manifest" href="/manifest.json">
	<meta name="author" content="Forgejo – Beyond coding. We forge.">
	<meta name="description" content="Forgejo is a self-hosted lightweight software forge. Easy to install and low maintenance, it just does the job.">
	<meta name="keywords" content="git,forge,forgejo">
	<meta name="referrer" content="strict-origin">


	<link rel="icon" href="/assets/img/favicon.svg" type="image/svg+xml">
	<link rel="alternate icon" href="/assets/img/favicon.png" type="image/png">
	
<script>
	
	window.addEventListener('error', function(e) {window._globalHandlerErrors=window._globalHandlerErrors||[]; window._globalHandlerErrors.push(e);});
	window.addEventListener('unhandledrejection', function(e) {window._globalHandlerErrors=window._globalHandlerErrors||[]; window._globalHandlerErrors.push(e);});
	window.config = {
		appUrl: 'https:\/\/git.local.test:8999\/',
		appSubUrl: '',
		assetVersionEncoded: encodeURIComponent('15.0.2~gitea-1.22.0'), 
		assetUrlPrefix: '\/assets',
		runModeIsProd:  true ,
		customEmojis: new Set(["git","gitea","codeberg","gitlab","github","gogs","forgejo"]),
		pageData:  null ,
		notificationSettings: {"EventSourceUpdateTime":10000,"MaxTimeout":60000,"MinTimeout":10000,"TimeoutStep":10000}, 
		enableTimeTracking:  true ,
		
		mermaidMaxSourceCharacters:  50000 ,
		
		i18n: {
			copy_success: "Copied!",
			copy_error: "Copy failed",
			error_occurred: "An error occurred",
			network_error: "Network error",
			remove_label_str: "Remove item \"%s\"",
			modal_confirm: "Confirm",
			modal_cancel: "Cancel",
			more_items: "More items",
			incorrect_root_url: "This Forgejo instance is configured to be served on \"https://git.local.test:8999/\". You are currently viewing Forgejo through a different URL, which may cause parts of the application to break. The canonical URL is controlled by Forgejo admins via the ROOT_URL setting in the app.ini.",
		},
	};
	
	window.config.pageData = window.config.pageData || {};
</script>
<script src="/assets/js/webcomponents.js?v=15.0.2~gitea-1.22.0"></script>

	

	
	<meta property="og:title" content="Installation">


	<meta property="og:url" content="https://git.local.test:8999/">


	<meta property="og:type" content="website">


		<meta property="og:image" content="/assets/img/logo.png">

<meta property="og:site_name" content="Forgejo: Beyond coding. We forge.">

	<link rel="stylesheet" href="/assets/css/index.css?v=15.0.2~gitea-1.22.0">
<link rel="stylesheet" href="/assets/css/theme-forgejo-auto.css?v=15.0.2~gitea-1.22.0">

	
</head>
<body class="no-js" hx-swap="outerHTML" hx-ext="morph" hx-push-url="false">
	

	<div class="full height">
		<noscript>
			<div class="tw-ml-2 tw-mr-2 tw-text-center tw-text-text-light-2">This website requires JavaScript.</div>
		</noscript>

		

		



<div role="main" aria-label="Installation" class="page-content install">
	<div class="ui grid install-config-container">
		<div class="sixteen wide center aligned centered column">
			<h3 class="ui top attached header">
				Initial configuration
			</h3>
			<div class="ui attached segment">
				




	<div id="flash-message" hx-swap-oob="true"></div>



				<form class="ui form" action="/" method="post">
					<p class="tw-mt-0">If you run Forgejo inside Docker, please read the <a target="_blank" rel="noopener noreferrer" href="https://forgejo.org/docs/latest/admin/installation-docker/">documentation</a> before changing any settings.</p>

					
					<h4 class="ui dividing header">Database settings</h4>
					<p>Forgejo requires MySQL, PostgreSQL, SQLite3 or TiDB (MySQL protocol).</p>
					<div class="inline required field ">
						<label>Database type</label>
						<div class="ui selection database type dropdown">
							<input type="hidden" id="db_type" name="db_type" value="postgres">
							<div class="text">postgres</div>
							<svg viewBox="0 0 16 16" class="dropdown icon svg octicon-triangle-down" aria-hidden="true" width="14" height="14"><path d="m4.427 7.427 3.396 3.396a.25.25 0 0 0 .354 0l3.396-3.396A.25.25 0 0 0 11.396 7H4.604a.25.25 0 0 0-.177.427"/></svg>
							<div class="menu">
								
									<div class="item" data-value="mysql">MySQL</div>
								
									<div class="item" data-value="postgres">PostgreSQL</div>
								
									<div class="item" data-value="sqlite3">SQLite3</div>
								
							</div>
						</div>
					</div>

					<div class="tw-mt-4 tw-hidden" data-db-setting-for="common-host">
						<div class="inline required field ">
							<label for="db_host">Host</label>
							<input id="db_host" name="db_host" value="postgres:5432">
						</div>
						<div class="inline required field ">
							<label for="db_user">Username</label>
							<input id="db_user" name="db_user" value="forgejo">
						</div>
						<div class="inline required field ">
							<label for="db_passwd">Password</label>
							<input id="db_passwd" name="db_passwd" type="password" value="forgejo123">
						</div>
						<div class="inline required field ">
							<label for="db_name">Database name</label>
							<input id="db_name" name="db_name" value="forgejo">
						</div>
					</div>

					<div class="tw-mt-4 tw-hidden" data-db-setting-for="postgres">
						<div class="inline required field">
							<label>SSL</label>
							<div class="ui selection database type dropdown">
								<input type="hidden" name="ssl_mode" value="disable">
								<div class="default text">disable</div>
								<svg viewBox="0 0 16 16" class="dropdown icon svg octicon-triangle-down" aria-hidden="true" width="14" height="14"><path d="m4.427 7.427 3.396 3.396a.25.25 0 0 0 .354 0l3.396-3.396A.25.25 0 0 0 11.396 7H4.604a.25.25 0 0 0-.177.427"/></svg>
								<div class="menu">
									<div class="item" data-value="disable">Disable</div>
									<div class="item" data-value="require">Require</div>
									<div class="item" data-value="verify-full">Verify Full</div>
								</div>
							</div>
						</div>
						<div class="inline field ">
							<label for="db_schema">Schema</label>
							<input id="db_schema" name="db_schema" value="">
							<span class="help">Leave blank for database default ("public").</span>
						</div>
					</div>

					<div class="tw-mt-4 tw-hidden" data-db-setting-for="sqlite3">
						<div class="inline required field ">
							<label for="db_path">Path</label>
							<input id="db_path" name="db_path" value="/data/gitea/gitea.db">
							<span class="help">File path for the SQLite3 database.<br>Enter an absolute path if you run Forgejo as a service.</span>
						</div>
					</div>

					

					
					<h4 class="ui dividing header">General settings</h4>
					<div class="inline required field ">
						<label for="app_name">Instance title</label>
						<input id="app_name" name="app_name" value="Forgejo" required>
						<span class="help">Enter your instance name here. It will be displayed on every page.</span>
					</div>
					<div class="inline field">
						<label for="app_slogan">Instance slogan</label>
						<input id="app_slogan" name="app_slogan" value="Beyond coding. We Forge.">
						<span class="help">Enter your instance slogan here. Leave empty to disable.</span>
					</div>
					<div class="inline required field ">
						<label for="repo_root_path">Repository root path</label>
						<input id="repo_root_path" name="repo_root_path" value="/data/git/repositories" required>
						<span class="help">Remote Git repositories will be saved to this directory.</span>
					</div>
					<div class="inline field ">
						<label for="lfs_root_path">Git LFS root path</label>
						<input id="lfs_root_path" name="lfs_root_path" value="/data/git/lfs">
						<span class="help">Files tracked by Git LFS will be stored in this directory. Leave empty to disable.</span>
					</div>
					<div class="inline required field ">
						<label for="run_user">User to run as</label>
						<input id="run_user" name="run_user" value="git" readonly>
						<span class="help">The operating system username that Forgejo runs as. Note that this user must have access to the repository root path.</span>
					</div>
					<div class="inline required field">
						<label for="domain">Server domain</label>
						<input id="domain" name="domain" value="git.local.test" placeholder="next.forgejo.org" required>
						<span class="help">Domain or host address for the server.</span>
					</div>
					<div class="inline field">
						<label for="ssh_port">SSH server port</label>
						<input id="ssh_port" name="ssh_port" value="22">
						<span class="help">Port number that will be used by the SSH server. Leave empty to disable SSH server.</span>
					</div>
					<div class="inline required field">
						<label for="http_port">HTTP listen port</label>
						<input id="http_port" name="http_port" value="3000" required>
						<span class="help">Port number that will be used by the Forgejo web server.</span>
					</div>
					<div class="inline required field">
						<label for="app_url">Base URL</label>
						<input id="app_url" name="app_url" value="https://git.local.test:8999/" placeholder="https://next.forgejo.org" required>
						<span class="help">Base address for HTTP(S) clone URLs and email notifications.</span>
					</div>
					<div class="inline required field">
						<label for="log_root_path">Log path</label>
						<input id="log_root_path" name="log_root_path" value="/data/gitea/log" placeholder="log" required>
						<span class="help">Log files will be written to this directory.</span>
					</div>
					<div class="inline field">
						<div class="ui checkbox" id="disable-registration">
							<label class="">Disable self-registration</label>
							<input name="disable_registration" type="checkbox" checked>
						</div>
						<span class="help">Only instance administrators will be able to create new user accounts. It is highly recommended to keep registration disabled unless you intend to host a public instance for everyone and ready to deal with large amounts of spam accounts.</span>
					</div>
					<div class="inline field">
						<div class="ui checkbox">
							<label>Enable update checker</label>
							<input name="enable_update_checker" type="checkbox" checked>
						</div>
						<span class="help">It will periodically check for new Forgejo versions by checking a TXT DNS record at release.forgejo.org.</span>
					</div>

					
					<h4 class="ui dividing header">Optional settings</h4>

					
					<details class="collapsible optional field">
						<summary class="tw-py-2">
							Email settings
						</summary>
						<div class="inline field">
							<label for="smtp_addr">SMTP host</label>
							<input id="smtp_addr" name="smtp_addr" value="">
						</div>
						<div class="inline field">
							<label for="smtp_port">SMTP port</label>
							<input id="smtp_port" name="smtp_port" value="">
						</div>
						<div class="inline field ">
							<label for="smtp_from">Send email as</label>
							<input id="smtp_from" name="smtp_from" value="">
							<span class="help">Email address Forgejo will use. Enter a plain email address or use the &#34;Name&#34; &lt;email@example.com&gt; format.</span>
						</div>
						<div class="inline field ">
							<label for="smtp_user">SMTP username</label>
							<input id="smtp_user" name="smtp_user" value="">
						</div>
						<div class="inline field">
							<label for="smtp_passwd">SMTP password</label>
							<input id="smtp_passwd" name="smtp_passwd" type="password" value="">
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Require email confirmation to register</label>
								<input name="register_confirm" type="checkbox" >
							</div>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Enable email notifications</label>
								<input name="mail_notify" type="checkbox" >
							</div>
						</div>
					</details>

					
					<details class="collapsible optional field">
						<summary class="tw-py-2">
							Server and third-party service settings
						</summary>
						<div class="inline field">
							<div class="ui checkbox" id="offline-mode">
								<label>Enable local mode</label>
								<input name="offline_mode" type="checkbox" checked>
							</div>
							<span class="help">Disable third-party content delivery networks and serve all resources locally.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="disable-gravatar">
								<label>Disable Gravatar</label>
								<input name="disable_gravatar" type="checkbox" checked>
							</div>
							<span class="help">Disable usage of Gravatar or other third-party avatar sources. Default images will be used for user avatars unless they upload their own avatar to the instance.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="federated-avatar-lookup">
								<label>Enable federated avatars</label>
								<input name="enable_federated_avatar" type="checkbox" >
							</div>
							<span class="help">Look up avatars using Libravatar.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="enable-openid-signin">
								<label>Enable OpenID sign-in</label>
								<input name="enable_open_id_sign_in" type="checkbox" checked>
							</div>
							<span class="help">Allow users to sign in via OpenID.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="allow-only-external-registration">
								<label>Allow registration only via external services</label>
								<input name="allow_only_external_registration" type="checkbox" >
							</div>
							<span class="help">Users will only be able to create new accounts by using configured external services.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="enable-openid-signup">
								<label>Enable OpenID self-registration</label>
								<input name="enable_open_id_sign_up" type="checkbox" checked>
							</div>
							<span class="help">Allow users to create accounts via OpenID if self-registration is enabled.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="enable-captcha">
								<label>Enable registration CAPTCHA</label>
								<input name="enable_captcha" type="checkbox" >
							</div>
							<span class="help">Require users to pass CAPTCHA in order to create accounts.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Require to sign-in to view instance content</label>
								<input name="require_sign_in_view" type="checkbox" >
							</div>
							<span class="help">Limit content access to signed-in users. Guests will only be able to visit the authentication pages.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Hide email addresses by default</label>
								<input name="default_keep_email_private" type="checkbox" >
							</div>
							<span class="help">Enable email address hiding for new users by default so that this information is not leaked immediately after signing up.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Allow creation of organizations by default</label>
								<input name="default_allow_create_organization" type="checkbox" checked>
							</div>
							<span class="help">Allow new users to create organizations by default. When this option is disabled, an admin will have to grant a permission for creating organizations to new users.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Enable time tracking by default</label>
								<input name="default_enable_timetracking" type="checkbox" checked>
							</div>
							<span class="help">Allow usage of time tracking feature for new repositories by default.</span>
						</div>
						<div class="inline field">
							<label for="no_reply_address">Hidden email domain</label>
							<input id="_no_reply_address" name="no_reply_address" value="noreply.git.local.test">
							<span class="help">Domain name for users with a hidden email address. For example, the username "joe" will be logged in Git as "joe@noreply.example.org" if the hidden email domain is set to "noreply.example.org".</span>
						</div>
						<div class="inline field">
							<label for="password_algorithm">Password hash algorithm</label>
							<div class="ui selection dropdown">
								<input id="password_algorithm" type="hidden" name="password_algorithm" value="pbkdf2_hi">
								<div class="text">pbkdf2_hi</div>
								<svg viewBox="0 0 16 16" class="dropdown icon svg octicon-triangle-down" aria-hidden="true" width="14" height="14"><path d="m4.427 7.427 3.396 3.396a.25.25 0 0 0 .354 0l3.396-3.396A.25.25 0 0 0 11.396 7H4.604a.25.25 0 0 0-.177.427"/></svg>
								<div class="menu">
									
										<div class="item" data-value="pbkdf2">pbkdf2</div>
									
										<div class="item" data-value="argon2">argon2</div>
									
										<div class="item" data-value="bcrypt">bcrypt</div>
									
										<div class="item" data-value="scrypt">scrypt</div>
									
										<div class="item" data-value="pbkdf2_hi">pbkdf2_hi</div>
									
								</div>
							</div>
							<span class="help">Set the password hashing algorithm. Algorithms have differing requirements and strengths. The argon2 algorithm is rather secure but uses a lot of memory and may be inappropriate for small systems.</span>
						</div>
					</details>

					
					<details class="collapsible optional field">
						<summary class="tw-py-2">
							Administrator account settings
						</summary>
						<p class="center">Creating an administrator account is optional. The first registered user will automatically become an administrator.</p>
						<div class="inline field ">
							<label for="admin_name">Administrator username</label>
							<input id="admin_name" name="admin_name" value="">
						</div>
						<div class="inline field ">
							<label for="admin_email">Email address</label>
							<input id="admin_email" name="admin_email" type="email" value="">
						</div>
						<div class="inline field ">
							<label for="admin_passwd">Password</label>
							<input id="admin_passwd" name="admin_passwd" type="password" autocomplete="new-password" value="">
						</div>
						<div class="inline field ">
							<label for="admin_confirm_passwd">Confirm password</label>
							<input id="admin_confirm_passwd" name="admin_confirm_passwd" autocomplete="new-password" type="password" value="">
						</div>
					</details>

					<div class="divider"></div>

					

					<p>These configuration options will be saved in: /data/gitea/conf/app.ini</p>
					<div class="inline field">
						<div class="tw-mt-4 tw-mb-2 tw-text-center">
							<button class="ui primary button">Install Forgejo</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<img class="tw-hidden" src="/assets/img/forgejo-loading.svg" alt="Loading…" width="256" height="256">


	

	</div>

	

	<footer class="page-footer" role="group" aria-label="Footer">
	<div class="left-links" role="contentinfo" aria-label="About this software">
		
			<a target="_blank" rel="noopener noreferrer" href="https://forgejo.org">Powered by Forgejo</a>
		
		
			Version:
			
				15.0.2
			
		
		
			Page: <strong>0ms</strong>
			Template: <strong>0ms</strong>
		
	</div>
	<div class="right-links" role="group" aria-label="Links">
		<div class="ui dropdown upward language">
			<span class="flex-text-inline"><svg viewBox="0 0 16 16" class="svg octicon-globe" aria-hidden="true" width="14" height="14"><path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0M5.78 8.75a9.64 9.64 0 0 0 1.363 4.177q.383.64.857 1.215c.245-.296.551-.705.857-1.215A9.64 9.64 0 0 0 10.22 8.75Zm4.44-1.5a9.64 9.64 0 0 0-1.363-4.177c-.307-.51-.612-.919-.857-1.215a10 10 0 0 0-.857 1.215A9.64 9.64 0 0 0 5.78 7.25Zm-5.944 1.5H1.543a6.51 6.51 0 0 0 4.666 5.5q-.184-.271-.352-.552c-.715-1.192-1.437-2.874-1.581-4.948m-2.733-1.5h2.733c.144-2.074.866-3.756 1.58-4.948q.18-.295.353-.552a6.51 6.51 0 0 0-4.666 5.5m10.181 1.5c-.144 2.074-.866 3.756-1.58 4.948q-.18.296-.353.552a6.51 6.51 0 0 0 4.666-5.5Zm2.733-1.5a6.51 6.51 0 0 0-4.666-5.5q.184.272.353.552c.714 1.192 1.436 2.874 1.58 4.948Z"/></svg> English</span>
			<div class="menu language-menu">
				
					<a lang="id-ID" data-url="/?lang=id-ID" class="item ">Bahasa Indonesia</a>
				
					<a lang="da" data-url="/?lang=da" class="item ">Dansk</a>
				
					<a lang="de-DE" data-url="/?lang=de-DE" class="item ">Deutsch</a>
				
					<a lang="en-US" data-url="/?lang=en-US" class="item active selected">English</a>
				
					<a lang="es-ES" data-url="/?lang=es-ES" class="item ">Español</a>
				
					<a lang="eo" data-url="/?lang=eo" class="item ">Esperanto</a>
				
					<a lang="fil" data-url="/?lang=fil" class="item ">Filipino</a>
				
					<a lang="fr-FR" data-url="/?lang=fr-FR" class="item ">Français</a>
				
					<a lang="it-IT" data-url="/?lang=it-IT" class="item ">Italiano</a>
				
					<a lang="lv-LV" data-url="/?lang=lv-LV" class="item ">Latviešu</a>
				
					<a lang="hu-HU" data-url="/?lang=hu-HU" class="item ">Magyar nyelv</a>
				
					<a lang="nl-NL" data-url="/?lang=nl-NL" class="item ">Nederlands</a>
				
					<a lang="nds" data-url="/?lang=nds" class="item ">Plattdüütsch</a>
				
					<a lang="pl-PL" data-url="/?lang=pl-PL" class="item ">Polski</a>
				
					<a lang="pt-PT" data-url="/?lang=pt-PT" class="item ">Português de Portugal</a>
				
					<a lang="pt-BR" data-url="/?lang=pt-BR" class="item ">Português do Brasil</a>
				
					<a lang="sl" data-url="/?lang=sl" class="item ">Slovenščina</a>
				
					<a lang="fi-FI" data-url="/?lang=fi-FI" class="item ">Suomi</a>
				
					<a lang="sv-SE" data-url="/?lang=sv-SE" class="item ">Svenska</a>
				
					<a lang="tr-TR" data-url="/?lang=tr-TR" class="item ">Türkçe</a>
				
					<a lang="cs-CZ" data-url="/?lang=cs-CZ" class="item ">Čeština</a>
				
					<a lang="el-GR" data-url="/?lang=el-GR" class="item ">Ελληνικά</a>
				
					<a lang="bg" data-url="/?lang=bg" class="item ">Български</a>
				
					<a lang="ru-RU" data-url="/?lang=ru-RU" class="item ">Русский</a>
				
					<a lang="uk-UA" data-url="/?lang=uk-UA" class="item ">Українська</a>
				
					<a lang="fa-IR" data-url="/?lang=fa-IR" class="item ">فارسی</a>
				
					<a lang="ja-JP" data-url="/?lang=ja-JP" class="item ">日本語</a>
				
					<a lang="zh-CN" data-url="/?lang=zh-CN" class="item ">简体中文</a>
				
					<a lang="zh-TW" data-url="/?lang=zh-TW" class="item ">繁體中文（台灣）</a>
				
					<a lang="zh-HK" data-url="/?lang=zh-HK" class="item ">繁體中文（香港）</a>
				
					<a lang="ko-KR" data-url="/?lang=ko-KR" class="item ">한국어</a>
				
			</div>
		</div>
		<a href="/assets/licenses.txt">Licenses</a>
		<a href="/api/swagger">API</a>
		
	</div>
</footer>


	<script src="/assets/js/index.js?v=15.0.2~gitea-1.22.0" onerror="alert('Failed to load asset files from {path}. Please make sure the asset files can be accessed.'.replace('{path}', this.src))"></script>

	
</body>
</html>


 --(281)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:11:04 
 󱞩 curl -k https:/curl -k https://auth.local.test:8999
Bad Gateway
 --(282)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:11:11 
 󱞩 podman logs autpodman logs authelia
time="2026-05-22T11:08:48Z" level=debug msg="Loaded Configuration Sources" files="[/config/configuration.yml]" filters="[]"
time="2026-05-22T11:08:48Z" level=debug msg="Logging Initialized" fields.level=debug file= format= keep_stdout=false
time="2026-05-22T11:08:48Z" level=debug msg="Process user information" gid=0 name=root uid=0 username=root
time="2026-05-22T11:08:48Z" level=warning msg="Configuration: access_control: no rules have been specified so the 'default_policy' of 'one_factor' is going to be applied to all requests"
time="2026-05-22T11:08:48Z" level=warning msg="Configuration: identity_providers: oidc: clients: client 'forgejo': option 'client_secret' is plaintext but for clients not using any endpoint authentication method 'client_secret_jwt' it should be a hashed value as plaintext values are deprecated with the exception of 'client_secret_jwt' and will be removed in the near future"
time="2026-05-22T11:08:48Z" level=info msg="Authelia v4.39.19 is starting"
time="2026-05-22T11:08:48Z" level=info msg="Log severity set to debug"
time="2026-05-22T11:08:48Z" level=debug msg="Registering OpenID Connect 1.0 client with client id 'forgejo' and policy 'one_factor'"
time="2026-05-22T11:08:48Z" level=info msg="Storage schema is being checked for updates"
time="2026-05-22T11:08:48Z" level=info msg="Storage schema migration from 0 to 23 is being attempted"
time="2026-05-22T11:08:48Z" level=error msg="Error occurred running a startup check" error="error during schema migrate: migration rollback complete. rollback caused by: schema migration 1 (Initial Schema) failed: ERROR: permission denied for schema public (SQLSTATE 42501)" provider=storage stack="github.com/authelia/authelia/v4/internal/middlewares/startup.go:96 doStartupCheck\ngithub.com/authelia/authelia/v4/internal/middlewares/startup.go:31 (*Providers).StartupChecks\ngithub.com/authelia/authelia/v4/internal/commands/root.go:90       (*CmdCtx).RootRunE\ngithub.com/spf13/cobra@v1.10.2/command.go:1015                     (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148                     (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071                     (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11            main\ninternal/runtime/atomic/types.go:194                               (*Uint32).Load\nruntime/asm_amd64.s:1771                                           goexit"
time="2026-05-22T11:08:48Z" level=error msg="Error occurred running a startup check" error="error occurred dialing address: error occurred attempting to dial LDAP server at 'ldap://lldap:3890': LDAP Result Code 200 \"Network Error\": dial tcp: lookup lldap on 10.89.0.1:53: no such host" provider=user stack="github.com/authelia/authelia/v4/internal/middlewares/startup.go:96 doStartupCheck\ngithub.com/authelia/authelia/v4/internal/middlewares/startup.go:34 (*Providers).StartupChecks\ngithub.com/authelia/authelia/v4/internal/commands/root.go:90       (*CmdCtx).RootRunE\ngithub.com/spf13/cobra@v1.10.2/command.go:1015                     (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148                     (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071                     (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11            main\ninternal/runtime/atomic/types.go:194                               (*Uint32).Load\nruntime/asm_amd64.s:1771                                           goexit"
time="2026-05-22T11:08:48Z" level=debug msg="webauthn-metadata provider: startup check skipped as it is disabled"
time="2026-05-22T11:08:48Z" level=fatal msg="One or more providers had fatal failures performing startup checks, for more details check the error level logs" providers="[user storage]" stack="github.com/authelia/authelia/v4/internal/commands/root.go:93 (*CmdCtx).RootRunE\ngithub.com/spf13/cobra@v1.10.2/command.go:1015               (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148               (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071               (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11      main\ninternal/runtime/atomic/types.go:194                         (*Uint32).Load\nruntime/asm_amd64.s:1771                                     goexit"

 --(283)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:11:15 
 󱞩 podman ps
CONTAINER ID  IMAGE                            COMMAND               CREATED             STATUS             PORTS                                                  NAMES
d17de8ebe2b9  docker.io/library/postgres:17    postgres              8 minutes ago       Up 8 minutes       5432/tcp                                               postgres
4a2c0a0e8403  codeberg.org/forgejo/forgejo:15  /usr/bin/s6-svsca...  2 minutes ago       Up 2 minutes       22/tcp, 3000/tcp                                       forgejo
4208c9dff451  docker.io/library/traefik:v3     --api.insecure=tr...  About a minute ago  Up About a minute  0.0.0.0:8080->8080/tcp, 0.0.0.0:8999->443/tcp, 80/tcp  traefik

 --(284)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:11:50 
 󱞩 podman ps -a
CONTAINER ID  IMAGE                               COMMAND               CREATED             STATUS                    PORTS                                                  NAMES
d17de8ebe2b9  docker.io/library/postgres:17       postgres              8 minutes ago       Up 8 minutes              5432/tcp                                               postgres
ac5da7e8581d  docker.io/lldap/lldap:stable        run --config-file...  8 minutes ago       Exited (1) 8 minutes ago  0.0.0.0:3890->3890/tcp, 0.0.0.0:17170->17170/tcp       lldap
9c6cd85ca489  docker.io/authelia/authelia:latest                        3 minutes ago       Exited (1) 3 minutes ago  9091/tcp                                               authelia
4a2c0a0e8403  codeberg.org/forgejo/forgejo:15     /usr/bin/s6-svsca...  3 minutes ago       Up 3 minutes              22/tcp, 3000/tcp                                       forgejo
4208c9dff451  docker.io/library/traefik:v3        --api.insecure=tr...  About a minute ago  Up About a minute         0.0.0.0:8080->8080/tcp, 0.0.0.0:8999->443/tcp, 80/tcp  traefik

 --(285)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:11:56 
 󱞩 podman ps --forpodman ps --format "{{.Names}}"
postgres
forgejo
traefik

 --(286)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:12:08 
 󱞩 podman exec -itpodman exec -it postgres psql -U authelia
psql (17.10 (Debian 17.10-1.pgdg13+1))
Type "help" for help.

authelia=> CREATE USER forgejo WITH PASSWORD 'forgejo123';

CREATE DATABASE forgejo OWNER forgejo;

GRANT ALL PRIVILEGES ON DATABASE forgejo TO forgejo;

GRANT ALL ON SCHEMA public TO authelia;

ALTER SCHEMA public OWNER TO authelia;
ERROR:  permission denied to create role
DETAIL:  Only roles with the CREATEROLE attribute may create roles.
ERROR:  permission denied to create database
WARNING:  no privileges were granted for "forgejo"
GRANT
WARNING:  no privileges were granted for "public"
GRANT
ERROR:  must be owner of schema public
authelia=> \q

 --(287)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:12:23 
 󱞩 podman logs -f lldap 
[entrypoint] Copying the default config to /data/lldap_config.toml
[entrypoint] Edit this file to configure LLDAP.
> Setup permissions..
> Starting lldap..

Loading configuration from /data/lldap_config.toml
WARNING: A key_seed was given, we will ignore the key_file and generate one from the seed! Set key_file to an empty string in the config to silence this message.
2026-05-22T11:03:30.204090286+00:00  INFO     set_up_server [ 11.1ms | 100.00% ]
2026-05-22T11:03:30.204109612+00:00  INFO     ┕━ ｉ [info]: Starting LLDAP version 0.6.3
Error: while creating base tables

Caused by:
    0: Execution Error: error returned from database: permission denied for schema public
    1: error returned from database: permission denied for schema public
    2: error returned from database: permission denied for schema public
    3: permission denied for schema public

 --(288)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:12:32 
 󱞩 podman exec -itpodman exec -it postgres psql -U authelia
psql (17.10 (Debian 17.10-1.pgdg13+1))
Type "help" for help.

authelia=> CREATE USER lldap WITH PASSWORD 'lldap123';

CREATE DATABASE lldap OWNER lldap;

GRANT ALL PRIVILEGES ON DATABASE lldap TO lldap;

\c lldap

GRANT ALL ON SCHEMA public TO lldap;

ALTER SCHEMA public OWNER TO lldap;

ALTER DATABASE lldap OWNER TO lldap;
ERROR:  permission denied to create role
DETAIL:  Only roles with the CREATEROLE attribute may create roles.
ERROR:  permission denied to create database
WARNING:  no privileges were granted for "lldap"
GRANT
invalid integer value "ON" for connection option "port"
Previous connection kept
authelia=> \q

 --(289)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:13:21 
 󱞩 nvim ~/.config/podman exec -it postgres psql -U postgres
psql (17.10 (Debian 17.10-1.pgdg13+1))
Type "help" for help.

postgres=# CREATE USER lldap WITH PASSWORD 'lldap123';

CREATE DATABASE lldap OWNER lldap;

GRANT ALL PRIVILEGES ON DATABASE lldap TO lldap;

\c lldap

GRANT ALL ON SCHEMA public TO lldap;

ALTER SCHEMA public OWNER TO lldap;

ALTER DATABASE lldap OWNER TO lldap;
ERROR:  role "lldap" already exists
ERROR:  database "lldap" already exists
GRANT
invalid integer value "ON" for connection option "port"
Previous connection kept
postgres=# \q

 --(290)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:15:59 
 󱞩 podman exec -itpodman exec -it postgres psql -U postgres
psql (17.10 (Debian 17.10-1.pgdg13+1))
Type "help" for help.

postgres=# ALTER DATABASE lldap OWNER TO lldap;
ALTER DATABASE
postgres=# \c lldap
You are now connected to database "lldap" as user "postgres".
lldap=# GRANT ALL ON SCHEMA public TO lldap;
GRANT
lldap=# ALTER SCHEMA public OWNER TO lldap;
ALTER SCHEMA
lldap=# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO lldap;
GRANT
lldap=# GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO lldap;
GRANT
lldap=# ALTER DATABASE authelia OWNER TO authelia;
ALTER DATABASE
lldap=# \c authelia
You are now connected to database "authelia" as user "postgres".
authelia=# GRANT ALL ON SCHEMA public TO authelia;
GRANT
authelia=# ALTER SCHEMA public OWNER TO authelia;
ALTER SCHEMA
authelia=# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO authelia;
GRANT
authelia=# GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO authelia;
GRANT
authelia=# \q

 --(291)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:22:00 
 󱞩 podman rm -f llpodman rm -f lldap authelia
lldap
authelia

 --(292)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:22:04 
 󱞩 podman run -d \podman run -d \
  --name lldap \
  --network homelab \
  -p 17170:17170 \
  -p 3890:3890 \
  -v ~/.config/containers/lldap/data:/data:Z \
  -e LLDAP_JWT_SECRET=super-secret-jwt-token \
  -e LLDAP_KEY_SEED=super-secret-key-seed \
  -e LLDAP_LDAP_BASE_DN=dc=local,dc=test \
  -e LLDAP_LDAP_USER_PASS=admin123 \
  -e LLDAP_LDAP_USER_DN=admin \
  -e LLDAP_DATABASE_URL=postgres://lldap:lldap123@postgres:5432/lldap \
  docker.io/lldap/lldap:stable
2e774dbe12569a44ba02983a71257374bd2746c1dd947962b27d3d8630aef3eb

 --(293)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:22:08 
 󱞩 podman logs -f podman logs -f lldap
> Setup permissions..
> Starting lldap..

Loading configuration from /data/lldap_config.toml
WARNING: A key_seed was given, we will ignore the key_file and generate one from the seed! Set key_file to an empty string in the config to silence this message.
2026-05-22T11:22:08.864005539+00:00  INFO     set_up_server [ 92.1ms | 100.00% ]
2026-05-22T11:22:08.864025326+00:00  INFO     ┝━ ｉ [info]: Starting LLDAP version 0.6.3
2026-05-22T11:22:08.900932736+00:00  INFO     ┝━ ｉ [info]: Upgrading DB schema from version 1
2026-05-22T11:22:08.900937314+00:00  INFO     ┝━ ｉ [info]: Upgrading DB schema to version 2
2026-05-22T11:22:08.904586682+00:00  INFO     ┝━ ｉ [info]: Upgrading DB schema to version 3
2026-05-22T11:22:08.908444164+00:00  INFO     ┝━ ｉ [info]: Upgrading DB schema to version 4
2026-05-22T11:22:08.911190169+00:00  INFO     ┝━ ｉ [info]: Upgrading DB schema to version 5
2026-05-22T11:22:08.920432759+00:00  INFO     ┝━ ｉ [info]: Upgrading DB schema to version 6
2026-05-22T11:22:08.924048803+00:00  INFO     ┝━ ｉ [info]: Upgrading DB schema to version 7
2026-05-22T11:22:08.926599207+00:00  INFO     ┝━ ｉ [info]: Upgrading DB schema to version 8
2026-05-22T11:22:08.929935281+00:00  INFO     ┝━ ｉ [info]: Upgrading DB schema to version 9
2026-05-22T11:22:08.932995802+00:00  INFO     ┝━ ｉ [info]: Upgrading DB schema to version 10
2026-05-22T11:22:08.936578544+00:00  INFO     ┝━ ｉ [info]: Upgrading DB schema to version 11
2026-05-22T11:22:08.958094127+00:00  WARN     ┝━ 🚧 [warn]: Could not find lldap_admin group, trying to create it
2026-05-22T11:22:08.962619375+00:00  WARN     ┝━ 🚧 [warn]: Could not find lldap_password_manager group, trying to create it
2026-05-22T11:22:08.966186887+00:00  WARN     ┝━ 🚧 [warn]: Could not find lldap_strict_readonly group, trying to create it
2026-05-22T11:22:08.972530602+00:00  WARN     ┝━ 🚧 [warn]: Could not find an admin user, trying to create the user "admin" with the config-provided password
2026-05-22T11:22:09.037294625+00:00  INFO     ┝━ ｉ [info]: Successfully (re)set password for "admin"
2026-05-22T11:22:09.043606679+00:00  INFO     ┝━ ｉ [info]: Starting the LDAP server on port 3890
2026-05-22T11:22:09.045057029+00:00  INFO     ┕━ ｉ [info]: Starting the API/web server on port 17170
2026-05-22T11:22:09.045656976+00:00  INFO     ｉ [info]: starting 1 workers
2026-05-22T11:22:09.045863598+00:00  INFO     ｉ [info]: Actix runtime found; starting in Actix runtime
2026-05-22T11:22:09.045873426+00:00  INFO     ｉ [info]: starting service: "ldap", workers: 1, listening on: 0.0.0.0:3890
2026-05-22T11:22:09.045877023+00:00  INFO     ｉ [info]: starting service: "http", workers: 1, listening on: 0.0.0.0:17170
2026-05-22T11:22:09.052844120+00:00  INFO     ｉ [info]: DB Cleanup Cron started
^C
 --(294)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:22:13 
 󱞩 podman run -d \podman run -d \
  --name authelia \
  --network homelab \
  -v ~/.config/containers/authelia:/config:Z \
  -l 'traefik.enable=true' \
  -l 'traefik.http.routers.authelia.rule=Host(`auth.local.test`)' \
  -l 'traefik.http.routers.authelia.entrypoints=websecure' \
  -l 'traefik.http.routers.authelia.tls=true' \
  -l 'traefik.http.services.authelia.loadbalancer.server.port=9091' \
  docker.io/authelia/authelia:latest
3b2d6fa231762fa3b1a81a0d4b5a8fc686caaba47b0891f21927eab79da9654c

 --(295)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:22:20 
 󱞩 podman logs -f podman logs -f authelia
time="2026-05-22T11:22:20Z" level=debug msg="Loaded Configuration Sources" files="[/config/configuration.yml]" filters="[]"
time="2026-05-22T11:22:20Z" level=debug msg="Logging Initialized" fields.level=debug file= format= keep_stdout=false
time="2026-05-22T11:22:20Z" level=debug msg="Process user information" gid=0 name=root uid=0 username=root
time="2026-05-22T11:22:20Z" level=warning msg="Configuration: access_control: no rules have been specified so the 'default_policy' of 'one_factor' is going to be applied to all requests"
time="2026-05-22T11:22:20Z" level=warning msg="Configuration: identity_providers: oidc: clients: client 'forgejo': option 'client_secret' is plaintext but for clients not using any endpoint authentication method 'client_secret_jwt' it should be a hashed value as plaintext values are deprecated with the exception of 'client_secret_jwt' and will be removed in the near future"
time="2026-05-22T11:22:20Z" level=info msg="Authelia v4.39.19 is starting"
time="2026-05-22T11:22:20Z" level=info msg="Log severity set to debug"
time="2026-05-22T11:22:20Z" level=debug msg="Registering OpenID Connect 1.0 client with client id 'forgejo' and policy 'one_factor'"
time="2026-05-22T11:22:20Z" level=info msg="Storage schema is being checked for updates"
time="2026-05-22T11:22:20Z" level=info msg="Storage schema migration from 0 to 23 is being attempted"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 0 to 1"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 1 to 2"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 2 to 3"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 3 to 4"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 4 to 5"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 5 to 6"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 6 to 7"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 7 to 8"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 8 to 9"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 9 to 10"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 10 to 11"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 11 to 12"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 12 to 13"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 13 to 14"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 14 to 15"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 15 to 16"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 16 to 17"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 17 to 18"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 18 to 19"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 19 to 20"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 20 to 21"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 21 to 22"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 22 to 23"
time="2026-05-22T11:22:21Z" level=info msg="Storage schema migration from 0 to 23 is complete"
time="2026-05-22T11:22:21Z" level=debug msg="LDAP Discovery. LDAP Version: 3; Controls: 1.3.6.1.4.1.4203.1.11.1, 1.3.6.1.4.1.4203.1.11.3; Extensions: none; Features: 1.3.6.1.4.1.4203.1.5.1; SASL Mechanisms: none; Vendor Name: LLDAP; Vendor Version: lldap_0.1.1"
time="2026-05-22T11:22:21Z" level=debug msg="webauthn-metadata provider: startup check skipped as it is disabled"
time="2026-05-22T11:22:21Z" level=info msg="Startup complete"
time="2026-05-22T11:22:21Z" level=info msg="Listening for non-TLS connections on '[::]:9091' path '/'" server=main service=server
^C
 --(296)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:22:25 
 󱞩 curl -k https:/curl -k https://auth.local.test:8999
<!doctype html>
<html lang="en">
    <head>
        <base href="https://auth.local.test:8999/" />
        <meta property="csp-nonce" content="J7foiQeYKCTtVO2kuT9CVLAbIKCXiLTk" />
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="theme-color" content="#000000" />
        <link rel="manifest" href="./manifest.json" />
        <link rel="icon" href="./favicon.ico" />
        <title></title>
      <script type="module" crossorigin src="./static/js/index.BrTK6y2i.js"></script>
      <link rel="modulepreload" crossorigin href="./static/js/chunk.DlVPA22h.js">
      <link rel="modulepreload" crossorigin href="./static/js/jsx-runtime.HaF00pOT.js">
      <link rel="modulepreload" crossorigin href="./static/js/chunk-QFMPRPBF.DPG-QKOQ.js">
      <link rel="modulepreload" crossorigin href="./static/js/utils.Configuration.Ds6pXNZy.js">
      <link rel="modulepreload" crossorigin href="./static/js/mui.CircularProgress.BvN3qeCu.js">
      <link rel="modulepreload" crossorigin href="./static/js/fontawesome-svg-core.8FlSHMxQ.js">
      <link rel="modulepreload" crossorigin href="./static/js/mui.Grow.CCK1Phaa.js">
      <link rel="modulepreload" crossorigin href="./static/js/contexts.NotificationsContext.DrsbCNet.js">
      <link rel="modulepreload" crossorigin href="./static/js/mui.RtlProvider.CwGalZoG.js">
      <link rel="modulepreload" crossorigin href="./static/js/axios.DFSlbVw2.js">
      <link rel="modulepreload" crossorigin href="./static/js/constants.LocalStorage.B8XPN9FL.js">
      <link rel="modulepreload" crossorigin href="./static/js/mui.Grid.C2MuioJD.js">
      <link rel="modulepreload" crossorigin href="./static/js/mui.Typography.l1OmJPrl.js">
      <link rel="modulepreload" crossorigin href="./static/js/views.LoadingPage.C6Kn8YHD.js">
      <link rel="modulepreload" crossorigin href="./static/js/constants.Routes.0nF8LvIB.js">
      <link rel="modulepreload" crossorigin href="./static/js/services.LocalStorage.BQxI78o8.js">
      <link rel="modulepreload" crossorigin href="./static/js/contexts.LanguageContext.D6E5MMoB.js">
      <link rel="modulepreload" crossorigin href="./static/js/services.Client.C4gSbp84.js">
      <link rel="modulepreload" crossorigin href="./static/js/services.UserInfo.B42SdIQp.js">
      <link rel="modulepreload" crossorigin href="./static/js/contexts.LocalStorageMethodContext.CevqyUb7.js">
      <link rel="modulepreload" crossorigin href="./static/js/hooks.RemoteCall.n3Wv5Bzf.js">
      <link rel="modulepreload" crossorigin href="./static/js/hooks.Configuration.BP-ZP1gK.js">
      <link rel="modulepreload" crossorigin href="./static/js/hooks.QueryParam.B_9ram53.js">
      <link rel="modulepreload" crossorigin href="./static/js/hooks.Redirector.arsv2TkH.js">
      <link rel="modulepreload" crossorigin href="./static/js/constants.SearchParams.CVF9qGWV.js">
      <link rel="modulepreload" crossorigin href="./static/js/hooks.RouterNavigate.5D7ThbL3.js">
      <link rel="modulepreload" crossorigin href="./static/js/services.State.CFkWWBpw.js">
      <link rel="modulepreload" crossorigin href="./static/js/hooks.UserInfo.B0zw4WwF.js">
      <link rel="stylesheet" crossorigin href="./static/css/index.Dny_JsW-.css">
    </head>

    <body
        data-basepath=""
        data-duoselfenrollment="false"
        data-logooverride="false"
        data-privacypolicyurl=""
        data-privacypolicyaccept="false"
        data-passkeylogin="false"
        data-rememberme="true"
        data-resetpassword="true"
        data-resetpasswordcustomurl=""
        data-theme="light"
    >
        <noscript>You need to enable JavaScript to run this app.</noscript>
        <div id="root"></div>
    </body>
</html>

 --(297)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:22:40 
 󱞩 curl -k https:/curl -k https://git.local.test:8999
<!DOCTYPE html>
<html lang="en-US" data-theme="forgejo-auto">
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<title>Installation - Forgejo: Beyond coding. We forge.</title>
	<link rel="manifest" href="/manifest.json">
	<meta name="author" content="Forgejo – Beyond coding. We forge.">
	<meta name="description" content="Forgejo is a self-hosted lightweight software forge. Easy to install and low maintenance, it just does the job.">
	<meta name="keywords" content="git,forge,forgejo">
	<meta name="referrer" content="strict-origin">


	<link rel="icon" href="/assets/img/favicon.svg" type="image/svg+xml">
	<link rel="alternate icon" href="/assets/img/favicon.png" type="image/png">
	
<script>
	
	window.addEventListener('error', function(e) {window._globalHandlerErrors=window._globalHandlerErrors||[]; window._globalHandlerErrors.push(e);});
	window.addEventListener('unhandledrejection', function(e) {window._globalHandlerErrors=window._globalHandlerErrors||[]; window._globalHandlerErrors.push(e);});
	window.config = {
		appUrl: 'https:\/\/git.local.test:8999\/',
		appSubUrl: '',
		assetVersionEncoded: encodeURIComponent('15.0.2~gitea-1.22.0'), 
		assetUrlPrefix: '\/assets',
		runModeIsProd:  true ,
		customEmojis: new Set(["git","gitea","codeberg","gitlab","github","gogs","forgejo"]),
		pageData:  null ,
		notificationSettings: {"EventSourceUpdateTime":10000,"MaxTimeout":60000,"MinTimeout":10000,"TimeoutStep":10000}, 
		enableTimeTracking:  true ,
		
		mermaidMaxSourceCharacters:  50000 ,
		
		i18n: {
			copy_success: "Copied!",
			copy_error: "Copy failed",
			error_occurred: "An error occurred",
			network_error: "Network error",
			remove_label_str: "Remove item \"%s\"",
			modal_confirm: "Confirm",
			modal_cancel: "Cancel",
			more_items: "More items",
			incorrect_root_url: "This Forgejo instance is configured to be served on \"https://git.local.test:8999/\". You are currently viewing Forgejo through a different URL, which may cause parts of the application to break. The canonical URL is controlled by Forgejo admins via the ROOT_URL setting in the app.ini.",
		},
	};
	
	window.config.pageData = window.config.pageData || {};
</script>
<script src="/assets/js/webcomponents.js?v=15.0.2~gitea-1.22.0"></script>

	

	
	<meta property="og:title" content="Installation">


	<meta property="og:url" content="https://git.local.test:8999/">


	<meta property="og:type" content="website">


		<meta property="og:image" content="/assets/img/logo.png">

<meta property="og:site_name" content="Forgejo: Beyond coding. We forge.">

	<link rel="stylesheet" href="/assets/css/index.css?v=15.0.2~gitea-1.22.0">
<link rel="stylesheet" href="/assets/css/theme-forgejo-auto.css?v=15.0.2~gitea-1.22.0">

	
</head>
<body class="no-js" hx-swap="outerHTML" hx-ext="morph" hx-push-url="false">
	

	<div class="full height">
		<noscript>
			<div class="tw-ml-2 tw-mr-2 tw-text-center tw-text-text-light-2">This website requires JavaScript.</div>
		</noscript>

		

		



<div role="main" aria-label="Installation" class="page-content install">
	<div class="ui grid install-config-container">
		<div class="sixteen wide center aligned centered column">
			<h3 class="ui top attached header">
				Initial configuration
			</h3>
			<div class="ui attached segment">
				




	<div id="flash-message" hx-swap-oob="true"></div>



				<form class="ui form" action="/" method="post">
					<p class="tw-mt-0">If you run Forgejo inside Docker, please read the <a target="_blank" rel="noopener noreferrer" href="https://forgejo.org/docs/latest/admin/installation-docker/">documentation</a> before changing any settings.</p>

					
					<h4 class="ui dividing header">Database settings</h4>
					<p>Forgejo requires MySQL, PostgreSQL, SQLite3 or TiDB (MySQL protocol).</p>
					<div class="inline required field ">
						<label>Database type</label>
						<div class="ui selection database type dropdown">
							<input type="hidden" id="db_type" name="db_type" value="postgres">
							<div class="text">postgres</div>
							<svg viewBox="0 0 16 16" class="dropdown icon svg octicon-triangle-down" aria-hidden="true" width="14" height="14"><path d="m4.427 7.427 3.396 3.396a.25.25 0 0 0 .354 0l3.396-3.396A.25.25 0 0 0 11.396 7H4.604a.25.25 0 0 0-.177.427"/></svg>
							<div class="menu">
								
									<div class="item" data-value="mysql">MySQL</div>
								
									<div class="item" data-value="postgres">PostgreSQL</div>
								
									<div class="item" data-value="sqlite3">SQLite3</div>
								
							</div>
						</div>
					</div>

					<div class="tw-mt-4 tw-hidden" data-db-setting-for="common-host">
						<div class="inline required field ">
							<label for="db_host">Host</label>
							<input id="db_host" name="db_host" value="postgres:5432">
						</div>
						<div class="inline required field ">
							<label for="db_user">Username</label>
							<input id="db_user" name="db_user" value="forgejo">
						</div>
						<div class="inline required field ">
							<label for="db_passwd">Password</label>
							<input id="db_passwd" name="db_passwd" type="password" value="forgejo123">
						</div>
						<div class="inline required field ">
							<label for="db_name">Database name</label>
							<input id="db_name" name="db_name" value="forgejo">
						</div>
					</div>

					<div class="tw-mt-4 tw-hidden" data-db-setting-for="postgres">
						<div class="inline required field">
							<label>SSL</label>
							<div class="ui selection database type dropdown">
								<input type="hidden" name="ssl_mode" value="disable">
								<div class="default text">disable</div>
								<svg viewBox="0 0 16 16" class="dropdown icon svg octicon-triangle-down" aria-hidden="true" width="14" height="14"><path d="m4.427 7.427 3.396 3.396a.25.25 0 0 0 .354 0l3.396-3.396A.25.25 0 0 0 11.396 7H4.604a.25.25 0 0 0-.177.427"/></svg>
								<div class="menu">
									<div class="item" data-value="disable">Disable</div>
									<div class="item" data-value="require">Require</div>
									<div class="item" data-value="verify-full">Verify Full</div>
								</div>
							</div>
						</div>
						<div class="inline field ">
							<label for="db_schema">Schema</label>
							<input id="db_schema" name="db_schema" value="">
							<span class="help">Leave blank for database default ("public").</span>
						</div>
					</div>

					<div class="tw-mt-4 tw-hidden" data-db-setting-for="sqlite3">
						<div class="inline required field ">
							<label for="db_path">Path</label>
							<input id="db_path" name="db_path" value="/data/gitea/gitea.db">
							<span class="help">File path for the SQLite3 database.<br>Enter an absolute path if you run Forgejo as a service.</span>
						</div>
					</div>

					

					
					<h4 class="ui dividing header">General settings</h4>
					<div class="inline required field ">
						<label for="app_name">Instance title</label>
						<input id="app_name" name="app_name" value="Forgejo" required>
						<span class="help">Enter your instance name here. It will be displayed on every page.</span>
					</div>
					<div class="inline field">
						<label for="app_slogan">Instance slogan</label>
						<input id="app_slogan" name="app_slogan" value="Beyond coding. We Forge.">
						<span class="help">Enter your instance slogan here. Leave empty to disable.</span>
					</div>
					<div class="inline required field ">
						<label for="repo_root_path">Repository root path</label>
						<input id="repo_root_path" name="repo_root_path" value="/data/git/repositories" required>
						<span class="help">Remote Git repositories will be saved to this directory.</span>
					</div>
					<div class="inline field ">
						<label for="lfs_root_path">Git LFS root path</label>
						<input id="lfs_root_path" name="lfs_root_path" value="/data/git/lfs">
						<span class="help">Files tracked by Git LFS will be stored in this directory. Leave empty to disable.</span>
					</div>
					<div class="inline required field ">
						<label for="run_user">User to run as</label>
						<input id="run_user" name="run_user" value="git" readonly>
						<span class="help">The operating system username that Forgejo runs as. Note that this user must have access to the repository root path.</span>
					</div>
					<div class="inline required field">
						<label for="domain">Server domain</label>
						<input id="domain" name="domain" value="git.local.test" placeholder="next.forgejo.org" required>
						<span class="help">Domain or host address for the server.</span>
					</div>
					<div class="inline field">
						<label for="ssh_port">SSH server port</label>
						<input id="ssh_port" name="ssh_port" value="22">
						<span class="help">Port number that will be used by the SSH server. Leave empty to disable SSH server.</span>
					</div>
					<div class="inline required field">
						<label for="http_port">HTTP listen port</label>
						<input id="http_port" name="http_port" value="3000" required>
						<span class="help">Port number that will be used by the Forgejo web server.</span>
					</div>
					<div class="inline required field">
						<label for="app_url">Base URL</label>
						<input id="app_url" name="app_url" value="https://git.local.test:8999/" placeholder="https://next.forgejo.org" required>
						<span class="help">Base address for HTTP(S) clone URLs and email notifications.</span>
					</div>
					<div class="inline required field">
						<label for="log_root_path">Log path</label>
						<input id="log_root_path" name="log_root_path" value="/data/gitea/log" placeholder="log" required>
						<span class="help">Log files will be written to this directory.</span>
					</div>
					<div class="inline field">
						<div class="ui checkbox" id="disable-registration">
							<label class="">Disable self-registration</label>
							<input name="disable_registration" type="checkbox" checked>
						</div>
						<span class="help">Only instance administrators will be able to create new user accounts. It is highly recommended to keep registration disabled unless you intend to host a public instance for everyone and ready to deal with large amounts of spam accounts.</span>
					</div>
					<div class="inline field">
						<div class="ui checkbox">
							<label>Enable update checker</label>
							<input name="enable_update_checker" type="checkbox" checked>
						</div>
						<span class="help">It will periodically check for new Forgejo versions by checking a TXT DNS record at release.forgejo.org.</span>
					</div>

					
					<h4 class="ui dividing header">Optional settings</h4>

					
					<details class="collapsible optional field">
						<summary class="tw-py-2">
							Email settings
						</summary>
						<div class="inline field">
							<label for="smtp_addr">SMTP host</label>
							<input id="smtp_addr" name="smtp_addr" value="">
						</div>
						<div class="inline field">
							<label for="smtp_port">SMTP port</label>
							<input id="smtp_port" name="smtp_port" value="">
						</div>
						<div class="inline field ">
							<label for="smtp_from">Send email as</label>
							<input id="smtp_from" name="smtp_from" value="">
							<span class="help">Email address Forgejo will use. Enter a plain email address or use the &#34;Name&#34; &lt;email@example.com&gt; format.</span>
						</div>
						<div class="inline field ">
							<label for="smtp_user">SMTP username</label>
							<input id="smtp_user" name="smtp_user" value="">
						</div>
						<div class="inline field">
							<label for="smtp_passwd">SMTP password</label>
							<input id="smtp_passwd" name="smtp_passwd" type="password" value="">
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Require email confirmation to register</label>
								<input name="register_confirm" type="checkbox" >
							</div>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Enable email notifications</label>
								<input name="mail_notify" type="checkbox" >
							</div>
						</div>
					</details>

					
					<details class="collapsible optional field">
						<summary class="tw-py-2">
							Server and third-party service settings
						</summary>
						<div class="inline field">
							<div class="ui checkbox" id="offline-mode">
								<label>Enable local mode</label>
								<input name="offline_mode" type="checkbox" checked>
							</div>
							<span class="help">Disable third-party content delivery networks and serve all resources locally.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="disable-gravatar">
								<label>Disable Gravatar</label>
								<input name="disable_gravatar" type="checkbox" checked>
							</div>
							<span class="help">Disable usage of Gravatar or other third-party avatar sources. Default images will be used for user avatars unless they upload their own avatar to the instance.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="federated-avatar-lookup">
								<label>Enable federated avatars</label>
								<input name="enable_federated_avatar" type="checkbox" >
							</div>
							<span class="help">Look up avatars using Libravatar.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="enable-openid-signin">
								<label>Enable OpenID sign-in</label>
								<input name="enable_open_id_sign_in" type="checkbox" checked>
							</div>
							<span class="help">Allow users to sign in via OpenID.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="allow-only-external-registration">
								<label>Allow registration only via external services</label>
								<input name="allow_only_external_registration" type="checkbox" >
							</div>
							<span class="help">Users will only be able to create new accounts by using configured external services.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="enable-openid-signup">
								<label>Enable OpenID self-registration</label>
								<input name="enable_open_id_sign_up" type="checkbox" checked>
							</div>
							<span class="help">Allow users to create accounts via OpenID if self-registration is enabled.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox" id="enable-captcha">
								<label>Enable registration CAPTCHA</label>
								<input name="enable_captcha" type="checkbox" >
							</div>
							<span class="help">Require users to pass CAPTCHA in order to create accounts.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Require to sign-in to view instance content</label>
								<input name="require_sign_in_view" type="checkbox" >
							</div>
							<span class="help">Limit content access to signed-in users. Guests will only be able to visit the authentication pages.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Hide email addresses by default</label>
								<input name="default_keep_email_private" type="checkbox" >
							</div>
							<span class="help">Enable email address hiding for new users by default so that this information is not leaked immediately after signing up.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Allow creation of organizations by default</label>
								<input name="default_allow_create_organization" type="checkbox" checked>
							</div>
							<span class="help">Allow new users to create organizations by default. When this option is disabled, an admin will have to grant a permission for creating organizations to new users.</span>
						</div>
						<div class="inline field">
							<div class="ui checkbox">
								<label>Enable time tracking by default</label>
								<input name="default_enable_timetracking" type="checkbox" checked>
							</div>
							<span class="help">Allow usage of time tracking feature for new repositories by default.</span>
						</div>
						<div class="inline field">
							<label for="no_reply_address">Hidden email domain</label>
							<input id="_no_reply_address" name="no_reply_address" value="noreply.git.local.test">
							<span class="help">Domain name for users with a hidden email address. For example, the username "joe" will be logged in Git as "joe@noreply.example.org" if the hidden email domain is set to "noreply.example.org".</span>
						</div>
						<div class="inline field">
							<label for="password_algorithm">Password hash algorithm</label>
							<div class="ui selection dropdown">
								<input id="password_algorithm" type="hidden" name="password_algorithm" value="pbkdf2_hi">
								<div class="text">pbkdf2_hi</div>
								<svg viewBox="0 0 16 16" class="dropdown icon svg octicon-triangle-down" aria-hidden="true" width="14" height="14"><path d="m4.427 7.427 3.396 3.396a.25.25 0 0 0 .354 0l3.396-3.396A.25.25 0 0 0 11.396 7H4.604a.25.25 0 0 0-.177.427"/></svg>
								<div class="menu">
									
										<div class="item" data-value="pbkdf2">pbkdf2</div>
									
										<div class="item" data-value="argon2">argon2</div>
									
										<div class="item" data-value="bcrypt">bcrypt</div>
									
										<div class="item" data-value="scrypt">scrypt</div>
									
										<div class="item" data-value="pbkdf2_hi">pbkdf2_hi</div>
									
								</div>
							</div>
							<span class="help">Set the password hashing algorithm. Algorithms have differing requirements and strengths. The argon2 algorithm is rather secure but uses a lot of memory and may be inappropriate for small systems.</span>
						</div>
					</details>

					
					<details class="collapsible optional field">
						<summary class="tw-py-2">
							Administrator account settings
						</summary>
						<p class="center">Creating an administrator account is optional. The first registered user will automatically become an administrator.</p>
						<div class="inline field ">
							<label for="admin_name">Administrator username</label>
							<input id="admin_name" name="admin_name" value="">
						</div>
						<div class="inline field ">
							<label for="admin_email">Email address</label>
							<input id="admin_email" name="admin_email" type="email" value="">
						</div>
						<div class="inline field ">
							<label for="admin_passwd">Password</label>
							<input id="admin_passwd" name="admin_passwd" type="password" autocomplete="new-password" value="">
						</div>
						<div class="inline field ">
							<label for="admin_confirm_passwd">Confirm password</label>
							<input id="admin_confirm_passwd" name="admin_confirm_passwd" autocomplete="new-password" type="password" value="">
						</div>
					</details>

					<div class="divider"></div>

					

					<p>These configuration options will be saved in: /data/gitea/conf/app.ini</p>
					<div class="inline field">
						<div class="tw-mt-4 tw-mb-2 tw-text-center">
							<button class="ui primary button">Install Forgejo</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<img class="tw-hidden" src="/assets/img/forgejo-loading.svg" alt="Loading…" width="256" height="256">


	

	</div>

	

	<footer class="page-footer" role="group" aria-label="Footer">
	<div class="left-links" role="contentinfo" aria-label="About this software">
		
			<a target="_blank" rel="noopener noreferrer" href="https://forgejo.org">Powered by Forgejo</a>
		
		
			Version:
			
				15.0.2
			
		
		
			Page: <strong>0ms</strong>
			Template: <strong>0ms</strong>
		
	</div>
	<div class="right-links" role="group" aria-label="Links">
		<div class="ui dropdown upward language">
			<span class="flex-text-inline"><svg viewBox="0 0 16 16" class="svg octicon-globe" aria-hidden="true" width="14" height="14"><path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0M5.78 8.75a9.64 9.64 0 0 0 1.363 4.177q.383.64.857 1.215c.245-.296.551-.705.857-1.215A9.64 9.64 0 0 0 10.22 8.75Zm4.44-1.5a9.64 9.64 0 0 0-1.363-4.177c-.307-.51-.612-.919-.857-1.215a10 10 0 0 0-.857 1.215A9.64 9.64 0 0 0 5.78 7.25Zm-5.944 1.5H1.543a6.51 6.51 0 0 0 4.666 5.5q-.184-.271-.352-.552c-.715-1.192-1.437-2.874-1.581-4.948m-2.733-1.5h2.733c.144-2.074.866-3.756 1.58-4.948q.18-.295.353-.552a6.51 6.51 0 0 0-4.666 5.5m10.181 1.5c-.144 2.074-.866 3.756-1.58 4.948q-.18.296-.353.552a6.51 6.51 0 0 0 4.666-5.5Zm2.733-1.5a6.51 6.51 0 0 0-4.666-5.5q.184.272.353.552c.714 1.192 1.436 2.874 1.58 4.948Z"/></svg> English</span>
			<div class="menu language-menu">
				
					<a lang="id-ID" data-url="/?lang=id-ID" class="item ">Bahasa Indonesia</a>
				
					<a lang="da" data-url="/?lang=da" class="item ">Dansk</a>
				
					<a lang="de-DE" data-url="/?lang=de-DE" class="item ">Deutsch</a>
				
					<a lang="en-US" data-url="/?lang=en-US" class="item active selected">English</a>
				
					<a lang="es-ES" data-url="/?lang=es-ES" class="item ">Español</a>
				
					<a lang="eo" data-url="/?lang=eo" class="item ">Esperanto</a>
				
					<a lang="fil" data-url="/?lang=fil" class="item ">Filipino</a>
				
					<a lang="fr-FR" data-url="/?lang=fr-FR" class="item ">Français</a>
				
					<a lang="it-IT" data-url="/?lang=it-IT" class="item ">Italiano</a>
				
					<a lang="lv-LV" data-url="/?lang=lv-LV" class="item ">Latviešu</a>
				
					<a lang="hu-HU" data-url="/?lang=hu-HU" class="item ">Magyar nyelv</a>
				
					<a lang="nl-NL" data-url="/?lang=nl-NL" class="item ">Nederlands</a>
				
					<a lang="nds" data-url="/?lang=nds" class="item ">Plattdüütsch</a>
				
					<a lang="pl-PL" data-url="/?lang=pl-PL" class="item ">Polski</a>
				
					<a lang="pt-PT" data-url="/?lang=pt-PT" class="item ">Português de Portugal</a>
				
					<a lang="pt-BR" data-url="/?lang=pt-BR" class="item ">Português do Brasil</a>
				
					<a lang="sl" data-url="/?lang=sl" class="item ">Slovenščina</a>
				
					<a lang="fi-FI" data-url="/?lang=fi-FI" class="item ">Suomi</a>
				
					<a lang="sv-SE" data-url="/?lang=sv-SE" class="item ">Svenska</a>
				
					<a lang="tr-TR" data-url="/?lang=tr-TR" class="item ">Türkçe</a>
				
					<a lang="cs-CZ" data-url="/?lang=cs-CZ" class="item ">Čeština</a>
				
					<a lang="el-GR" data-url="/?lang=el-GR" class="item ">Ελληνικά</a>
				
					<a lang="bg" data-url="/?lang=bg" class="item ">Български</a>
				
					<a lang="ru-RU" data-url="/?lang=ru-RU" class="item ">Русский</a>
				
					<a lang="uk-UA" data-url="/?lang=uk-UA" class="item ">Українська</a>
				
					<a lang="fa-IR" data-url="/?lang=fa-IR" class="item ">فارسی</a>
				
					<a lang="ja-JP" data-url="/?lang=ja-JP" class="item ">日本語</a>
				
					<a lang="zh-CN" data-url="/?lang=zh-CN" class="item ">简体中文</a>
				
					<a lang="zh-TW" data-url="/?lang=zh-TW" class="item ">繁體中文（台灣）</a>
				
					<a lang="zh-HK" data-url="/?lang=zh-HK" class="item ">繁體中文（香港）</a>
				
					<a lang="ko-KR" data-url="/?lang=ko-KR" class="item ">한국어</a>
				
			</div>
		</div>
		<a href="/assets/licenses.txt">Licenses</a>
		<a href="/api/swagger">API</a>
		
	</div>
</footer>


	<script src="/assets/js/index.js?v=15.0.2~gitea-1.22.0" onerror="alert('Failed to load asset files from {path}. Please make sure the asset files can be accessed.'.replace('{path}', this.src))"></script>

	
</body>
</html>


 --(298)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:22:45 
 󱞩 cat ~/.config/ccat ~/.config/containers/traefik/dynamic/dynamic.yml
http:
  routers:
    authelia:
      rule: "Host(`auth.local.test`)"
      entryPoints:
        - websecure
      tls: {}
      service: authelia

    forgejo:
      rule: "Host(`git.local.test`)"
      entryPoints:
        - websecure
      tls: {}
      service: forgejo

  services:
    authelia:
      loadBalancer:
        servers:
          - url: "http://authelia:9091"

    forgejo:
      loadBalancer:
        servers:
          - url: "http://forgejo:3000"

tls:
  certificates:
    - certFile: /certs/local.test.crt
      keyFile: /certs/local.test.key

 --(299)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:23:32 
 󱞩 nvim ../dynamic/dynamic.yml 

 --(300)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:23:52 
 󱞩 podman restart podman restart traefik
traefik

 --(301)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:24:07 
 󱞩 podman logs traefik
2026-05-22T11:23:52Z ERR Watcher event error error="invalid argument" providerName=file

 --(302)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:24:10 
 󱞩 podman exec -itpodman exec -it postgres psql -U postgres
psql (17.10 (Debian 17.10-1.pgdg13+1))
Type "help" for help.

postgres=# \c forgejo
You are now connected to database "forgejo" as user "postgres".
forgejo=# GRANT ALL ON SCHEMA public TO forgejo;
GRANT
forgejo=# ALTER SCHEMA public OWNER TO forgejo;
ALTER SCHEMA
forgejo=# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO forgejo;
GRANT
forgejo=# GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO forgejo;
GRANT
forgejo=# ALTER DATABASE forgejo OWNER TO forgejo;
ALTER DATABASE
forgejo=# \q

 --(303)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:46:24 
 󱞩 podman restart podman restart forgejo
forgejo

 --(304)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:46:29 
 󱞩 podman ps -a
CONTAINER ID  IMAGE                               COMMAND               CREATED         STATUS         PORTS                                                  NAMES
d17de8ebe2b9  docker.io/library/postgres:17       postgres              43 minutes ago  Up 43 minutes  5432/tcp                                               postgres
4a2c0a0e8403  codeberg.org/forgejo/forgejo:15     /usr/bin/s6-svsca...  37 minutes ago  Up 4 seconds   22/tcp, 3000/tcp                                       forgejo
4208c9dff451  docker.io/library/traefik:v3        --api.insecure=tr...  35 minutes ago  Up 22 minutes  0.0.0.0:8080->8080/tcp, 0.0.0.0:8999->443/tcp, 80/tcp  traefik
2e774dbe1256  docker.io/lldap/lldap:stable        run --config-file...  24 minutes ago  Up 24 minutes  0.0.0.0:3890->3890/tcp, 0.0.0.0:17170->17170/tcp       lldap
3b2d6fa23176  docker.io/authelia/authelia:latest                        24 minutes ago  Up 24 minutes  9091/tcp                                               authelia

 --(305)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:46:33 
 󱞩 cat ../../authelia/configuration.yml 
server:
  address: tcp://0.0.0.0:9091

log:
  level: debug

identity_validation:
  reset_password:
    jwt_secret: cde3878cbdb245fbcd6248a93c18562cca8d67f5d0b81e3da6ea9224249333a0bf3dc0bccbc5d40661223f1050bf851114a88d25889b93e3f8279b13b5bfe8cc

totp:
  issuer: local.test

authentication_backend:
  ldap:
    implementation: custom

    address: ldap://lldap:3890

    timeout: 5s

    start_tls: false

    base_dn: dc=local,dc=test

    additional_users_dn: ou=people

    users_filter: "(&(objectClass=person)({username_attribute}={input}))"

    additional_groups_dn: ou=groups

    groups_filter: "(member={dn})"

    user: uid=admin,ou=people,dc=local,dc=test

    password: admin123

    attributes:
      username: uid
      display_name: displayName
      mail: mail
      group_name: cn

access_control:
  default_policy: one_factor

session:
  secret: eeaf01cfa65d375cf0572f43a75d1a11a7c1d2b671e159d623ff3c69330fac3cb3b1131e57015eb4a2d7ab59d84f14608cb5b74709a63df49ff2be2976b5b90e

  cookies:
    - domain: local.test
      authelia_url: https://auth.local.test:8999
      default_redirection_url: https://git.local.test:8999

storage:
  encryption_key: 59337659d78ddde63257a1d2b009f006e4e5cf78f9aeca5fc927f8217b923fed3502f8d3fca0af098d456276d8ad74939832a43ea3d53b4250dcb0d0a4a639a7

  postgres:
    address: tcp://postgres:5432
    database: authelia
    username: authelia
    password: authelia123

notifier:
  filesystem:
    filename: /config/notification.txt

identity_providers:
  oidc:
    hmac_secret: 0a8c8f4f6326d1d959456817b2baaeae3f414572d4ac8ea09ed83813d6d91be1ab8ebb4b461d2ee3f860aff72e23fb1f9f5684f2d8815dc682f53f0c9aaca52e

    jwks:
      - key_id: main
        algorithm: RS256
        use: sig
        key: |
          -----BEGIN PRIVATE KEY-----
          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
          tSIakDEwl2puyuXOlIiuWSZR1wao
          -----END PRIVATE KEY-----

    clients:
      - client_id: forgejo

        client_name: Forgejo

        client_secret: forgejo-secret

        public: false

        authorization_policy: one_factor

        redirect_uris:
          - https://git.local.test:8999/user/oauth2/Authelia/callback

        scopes:
          - openid
          - profile
          - email
          - groups

        userinfo_signed_response_alg: none

 --(306)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:48:25 
 󱞩 curl -k https:/curl -k https://auth.local.test:8999/.well-known/openid-configuration
{"issuer":"https://auth.local.test:8999","jwks_uri":"https://auth.local.test:8999/jwks.json","authorization_endpoint":"https://auth.local.test:8999/api/oidc/authorization","token_endpoint":"https://auth.local.test:8999/api/oidc/token","subject_types_supported":["public","pairwise"],"response_types_supported":["code","id_token","token","id_token token","code id_token","code token","code id_token token"],"grant_types_supported":["authorization_code","implicit","client_credentials","refresh_token","urn:ietf:params:oauth:grant-type:device_code"],"response_modes_supported":["form_post","query","fragment","jwt","form_post.jwt","query.jwt","fragment.jwt"],"scopes_supported":["offline_access","openid","profile","email","address","phone","groups"],"claims_supported":["amr","aud","azp","client_id","exp","iat","iss","jti","rat","auth_time","nonce","groups","sub","name","given_name","family_name","middle_name","nickname","preferred_username","profile","picture","website","email","email_verified","alt_emails","gender","birthdate","zoneinfo","locale","phone_number","phone_number_verified","address","updated_at"],"token_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt","none"],"token_endpoint_auth_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"introspection_endpoint":"https://auth.local.test:8999/api/oidc/introspection","revocation_endpoint":"https://auth.local.test:8999/api/oidc/revocation","introspection_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt"],"revocation_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt","none"],"revocation_endpoint_auth_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"code_challenge_methods_supported":["S256"],"device_authorization_endpoint":"https://auth.local.test:8999/api/oidc/device-authorization","authorization_response_iss_parameter_supported":true,"introspection_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"introspection_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"introspection_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"pushed_authorization_request_endpoint":"https://auth.local.test:8999/api/oidc/pushed-authorization-request","require_pushed_authorization_requests":false,"id_token_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"id_token_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"id_token_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"userinfo_endpoint":"https://auth.local.test:8999/api/oidc/userinfo","userinfo_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"userinfo_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"userinfo_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"request_object_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"request_object_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"request_object_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"claim_types_supported":["normal"],"request_parameter_supported":true,"request_uri_parameter_supported":true,"require_request_uri_registration":true,"claims_parameter_supported":true,"prompt_values_supported":["consent","login","none","select_account"],"authorization_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"authorization_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"authorization_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"]}
 --(307)--( user@system )-->  /home/sultan/.config/containers/traefik/certs |-->  18:48:50 
 󱞩 cd ../..

 --(308)--( user@system )-->  /home/sultan/.config/containers |-->  18:50:35 
 󱞩 cd authelia/

 --(309)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:50:37 
 󱞩 nvim configuration.yml 

 --(310)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:51:42 
 󱞩 cat configuration.yml 
server:
  address: tcp://0.0.0.0:9091

log:
  level: debug

identity_validation:
  reset_password:
    jwt_secret: cde3878cbdb245fbcd6248a93c18562cca8d67f5d0b81e3da6ea9224249333a0bf3dc0bccbc5d40661223f1050bf851114a88d25889b93e3f8279b13b5bfe8cc

totp:
  issuer: local.test

authentication_backend:
  ldap:
    implementation: custom

    address: ldap://lldap:3890

    timeout: 5s

    start_tls: false

    base_dn: dc=local,dc=test

    additional_users_dn: ou=people

    users_filter: "(&(objectClass=person)({username_attribute}={input}))"

    additional_groups_dn: ou=groups

    groups_filter: "(member={dn})"

    user: uid=admin,ou=people,dc=local,dc=test

    password: admin123

    attributes:
      username: uid
      display_name: displayName
      mail: mail
      group_name: cn

access_control:
  default_policy: one_factor

session:
  secret: eeaf01cfa65d375cf0572f43a75d1a11a7c1d2b671e159d623ff3c69330fac3cb3b1131e57015eb4a2d7ab59d84f14608cb5b74709a63df49ff2be2976b5b90e

  cookies:
    - domain: local.test
      authelia_url: https://auth.local.test:8999
      default_redirection_url: https://git.local.test:8999

storage:
  encryption_key: 59337659d78ddde63257a1d2b009f006e4e5cf78f9aeca5fc927f8217b923fed3502f8d3fca0af098d456276d8ad74939832a43ea3d53b4250dcb0d0a4a639a7

  postgres:
    address: tcp://postgres:5432
    database: authelia
    username: authelia
    password: authelia123

notifier:
  filesystem:
    filename: /config/notification.txt

identity_providers:
  oidc:
    hmac_secret: 0a8c8f4f6326d1d959456817b2baaeae3f414572d4ac8ea09ed83813d6d91be1ab8ebb4b461d2ee3f860aff72e23fb1f9f5684f2d8815dc682f53f0c9aaca52e

    jwks:
      - key_id: main
        algorithm: RS256
        use: sig
        key: |
          -----BEGIN PRIVATE KEY-----
          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
          tSIakDEwl2puyuXOlIiuWSZR1wao
          -----END PRIVATE KEY-----

    clients:
      - client_id: forgejo

        client_name: Forgejo

        client_secret: forgejo-secret

        public: false

        authorization_policy: one_factor

        redirect_uris:
          - https://git.local.test:8999/user/oauth2/Authelia/callback

        scopes:
          - openid
          - profile
          - email
          - groups

        userinfo_signed_response_alg: none

 --(311)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:51:44 
 󱞩 cat configuratinvimyml 

 --(312)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:54:13 
 󱞩 podman restart podman restart authelia
authelia

 --(313)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:54:20 
 󱞩 curl -k https:/curl -k https://auth.local.test:8999/.well-known/openid-configuration
Bad Gateway
 --(314)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:54:23 
 󱞩 podman logs -f authelia 
time="2026-05-22T11:22:20Z" level=debug msg="Loaded Configuration Sources" files="[/config/configuration.yml]" filters="[]"
time="2026-05-22T11:22:20Z" level=debug msg="Logging Initialized" fields.level=debug file= format= keep_stdout=false
time="2026-05-22T11:22:20Z" level=debug msg="Process user information" gid=0 name=root uid=0 username=root
time="2026-05-22T11:22:20Z" level=warning msg="Configuration: access_control: no rules have been specified so the 'default_policy' of 'one_factor' is going to be applied to all requests"
time="2026-05-22T11:22:20Z" level=warning msg="Configuration: identity_providers: oidc: clients: client 'forgejo': option 'client_secret' is plaintext but for clients not using any endpoint authentication method 'client_secret_jwt' it should be a hashed value as plaintext values are deprecated with the exception of 'client_secret_jwt' and will be removed in the near future"
time="2026-05-22T11:22:20Z" level=info msg="Authelia v4.39.19 is starting"
time="2026-05-22T11:22:20Z" level=info msg="Log severity set to debug"
time="2026-05-22T11:22:20Z" level=debug msg="Registering OpenID Connect 1.0 client with client id 'forgejo' and policy 'one_factor'"
time="2026-05-22T11:22:20Z" level=info msg="Storage schema is being checked for updates"
time="2026-05-22T11:22:20Z" level=info msg="Storage schema migration from 0 to 23 is being attempted"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 0 to 1"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 1 to 2"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 2 to 3"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 3 to 4"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 4 to 5"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 5 to 6"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 6 to 7"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 7 to 8"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 8 to 9"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 9 to 10"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 10 to 11"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 11 to 12"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 12 to 13"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 13 to 14"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 14 to 15"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 15 to 16"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 16 to 17"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 17 to 18"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 18 to 19"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 19 to 20"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 20 to 21"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 21 to 22"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 22 to 23"
time="2026-05-22T11:22:21Z" level=info msg="Storage schema migration from 0 to 23 is complete"
time="2026-05-22T11:22:21Z" level=debug msg="LDAP Discovery. LDAP Version: 3; Controls: 1.3.6.1.4.1.4203.1.11.1, 1.3.6.1.4.1.4203.1.11.3; Extensions: none; Features: 1.3.6.1.4.1.4203.1.5.1; SASL Mechanisms: none; Vendor Name: LLDAP; Vendor Version: lldap_0.1.1"
time="2026-05-22T11:22:21Z" level=debug msg="webauthn-metadata provider: startup check skipped as it is disabled"
time="2026-05-22T11:22:21Z" level=info msg="Startup complete"
time="2026-05-22T11:22:21Z" level=info msg="Listening for non-TLS connections on '[::]:9091' path '/'" server=main service=server
time="2026-05-22T11:26:23Z" level=debug msg="Mark 1FA authentication attempt made by user 'ikhsan'" method=POST path=/api/firstfactor remote_ip=10.89.0.28
time="2026-05-22T11:26:23Z" level=debug msg="Successful 1FA authentication attempt made by user 'ikhsan'" method=POST path=/api/firstfactor remote_ip=10.89.0.28
time="2026-05-22T11:54:20Z" level=debug msg="Shutdown initiated due to process signal" signal=terminated
time="2026-05-22T11:54:20Z" level=info msg="Shutdown initiated"
time="2026-05-22T11:54:20Z" level=info msg="Shutdown complete"
time="2026-05-22T11:54:20Z" level=debug msg="Loaded Configuration Sources" files="[/config/configuration.yml]" filters="[]"
time="2026-05-22T11:54:20Z" level=debug msg="Logging Initialized" fields.level=debug file= format= keep_stdout=false
time="2026-05-22T11:54:20Z" level=debug msg="Process user information" gid=0 name=root uid=0 username=root
time="2026-05-22T11:54:20Z" level=warning msg="Configuration: access_control: no rules have been specified so the 'default_policy' of 'one_factor' is going to be applied to all requests"
time="2026-05-22T11:54:20Z" level=warning msg="Configuration: identity_providers: oidc: clients: client 'forgejo': option 'client_secret' is plaintext but for clients not using any endpoint authentication method 'client_secret_jwt' it should be a hashed value as plaintext values are deprecated with the exception of 'client_secret_jwt' and will be removed in the near future"
time="2026-05-22T11:54:20Z" level=error msg="Configuration: configuration key not expected: identity_providers.oidc.issuer" stack="github.com/authelia/authelia/v4/internal/commands/context.go:201 NewRootCmd.(*CmdCtx).ChainRunE.func1\ngithub.com/spf13/cobra@v1.10.2/command.go:1000                   (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148                   (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071                   (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11          main\ninternal/runtime/atomic/types.go:194                             (*Uint32).Load\nruntime/asm_amd64.s:1771                                         goexit"
time="2026-05-22T11:54:20Z" level=fatal msg="Can't continue due to the errors loading the configuration" stack="github.com/authelia/authelia/v4/internal/commands/context.go:201 NewRootCmd.(*CmdCtx).ChainRunE.func1\ngithub.com/spf13/cobra@v1.10.2/command.go:1000                   (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148                   (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071                   (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11          main\ninternal/runtime/atomic/types.go:194                             (*Uint32).Load\nruntime/asm_amd64.s:1771                                         goexit"

 --(315)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:54:33 
 󱞩 podman logs -f nvim configuration.yml 

 --(316)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:55:16 
 󱞩 podman restart authelia 
authelia

 --(317)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:56:02 
 󱞩 podman logs -f authelia 
time="2026-05-22T11:22:20Z" level=debug msg="Loaded Configuration Sources" files="[/config/configuration.yml]" filters="[]"
time="2026-05-22T11:22:20Z" level=debug msg="Logging Initialized" fields.level=debug file= format= keep_stdout=false
time="2026-05-22T11:22:20Z" level=debug msg="Process user information" gid=0 name=root uid=0 username=root
time="2026-05-22T11:22:20Z" level=warning msg="Configuration: access_control: no rules have been specified so the 'default_policy' of 'one_factor' is going to be applied to all requests"
time="2026-05-22T11:22:20Z" level=warning msg="Configuration: identity_providers: oidc: clients: client 'forgejo': option 'client_secret' is plaintext but for clients not using any endpoint authentication method 'client_secret_jwt' it should be a hashed value as plaintext values are deprecated with the exception of 'client_secret_jwt' and will be removed in the near future"
time="2026-05-22T11:22:20Z" level=info msg="Authelia v4.39.19 is starting"
time="2026-05-22T11:22:20Z" level=info msg="Log severity set to debug"
time="2026-05-22T11:22:20Z" level=debug msg="Registering OpenID Connect 1.0 client with client id 'forgejo' and policy 'one_factor'"
time="2026-05-22T11:22:20Z" level=info msg="Storage schema is being checked for updates"
time="2026-05-22T11:22:20Z" level=info msg="Storage schema migration from 0 to 23 is being attempted"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 0 to 1"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 1 to 2"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 2 to 3"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 3 to 4"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 4 to 5"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 5 to 6"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 6 to 7"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 7 to 8"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 8 to 9"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 9 to 10"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 10 to 11"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 11 to 12"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 12 to 13"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 13 to 14"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 14 to 15"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 15 to 16"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 16 to 17"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 17 to 18"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 18 to 19"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 19 to 20"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 20 to 21"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 21 to 22"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 22 to 23"
time="2026-05-22T11:22:21Z" level=info msg="Storage schema migration from 0 to 23 is complete"
time="2026-05-22T11:22:21Z" level=debug msg="LDAP Discovery. LDAP Version: 3; Controls: 1.3.6.1.4.1.4203.1.11.1, 1.3.6.1.4.1.4203.1.11.3; Extensions: none; Features: 1.3.6.1.4.1.4203.1.5.1; SASL Mechanisms: none; Vendor Name: LLDAP; Vendor Version: lldap_0.1.1"
time="2026-05-22T11:22:21Z" level=debug msg="webauthn-metadata provider: startup check skipped as it is disabled"
time="2026-05-22T11:22:21Z" level=info msg="Startup complete"
time="2026-05-22T11:22:21Z" level=info msg="Listening for non-TLS connections on '[::]:9091' path '/'" server=main service=server
time="2026-05-22T11:26:23Z" level=debug msg="Mark 1FA authentication attempt made by user 'ikhsan'" method=POST path=/api/firstfactor remote_ip=10.89.0.28
time="2026-05-22T11:26:23Z" level=debug msg="Successful 1FA authentication attempt made by user 'ikhsan'" method=POST path=/api/firstfactor remote_ip=10.89.0.28
time="2026-05-22T11:54:20Z" level=debug msg="Shutdown initiated due to process signal" signal=terminated
time="2026-05-22T11:54:20Z" level=info msg="Shutdown initiated"
time="2026-05-22T11:54:20Z" level=info msg="Shutdown complete"
time="2026-05-22T11:54:20Z" level=debug msg="Loaded Configuration Sources" files="[/config/configuration.yml]" filters="[]"
time="2026-05-22T11:54:20Z" level=debug msg="Logging Initialized" fields.level=debug file= format= keep_stdout=false
time="2026-05-22T11:54:20Z" level=debug msg="Process user information" gid=0 name=root uid=0 username=root
time="2026-05-22T11:54:20Z" level=warning msg="Configuration: access_control: no rules have been specified so the 'default_policy' of 'one_factor' is going to be applied to all requests"
time="2026-05-22T11:54:20Z" level=warning msg="Configuration: identity_providers: oidc: clients: client 'forgejo': option 'client_secret' is plaintext but for clients not using any endpoint authentication method 'client_secret_jwt' it should be a hashed value as plaintext values are deprecated with the exception of 'client_secret_jwt' and will be removed in the near future"
time="2026-05-22T11:54:20Z" level=error msg="Configuration: configuration key not expected: identity_providers.oidc.issuer" stack="github.com/authelia/authelia/v4/internal/commands/context.go:201 NewRootCmd.(*CmdCtx).ChainRunE.func1\ngithub.com/spf13/cobra@v1.10.2/command.go:1000                   (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148                   (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071                   (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11          main\ninternal/runtime/atomic/types.go:194                             (*Uint32).Load\nruntime/asm_amd64.s:1771                                         goexit"
time="2026-05-22T11:54:20Z" level=fatal msg="Can't continue due to the errors loading the configuration" stack="github.com/authelia/authelia/v4/internal/commands/context.go:201 NewRootCmd.(*CmdCtx).ChainRunE.func1\ngithub.com/spf13/cobra@v1.10.2/command.go:1000                   (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148                   (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071                   (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11          main\ninternal/runtime/atomic/types.go:194                             (*Uint32).Load\nruntime/asm_amd64.s:1771                                         goexit"
time="2026-05-22T11:56:03Z" level=debug msg="Loaded Configuration Sources" files="[/config/configuration.yml]" filters="[]"
time="2026-05-22T11:56:03Z" level=debug msg="Logging Initialized" fields.level=debug file= format= keep_stdout=false
time="2026-05-22T11:56:03Z" level=debug msg="Process user information" gid=0 name=root uid=0 username=root
time="2026-05-22T11:56:03Z" level=warning msg="Configuration: access_control: no rules have been specified so the 'default_policy' of 'one_factor' is going to be applied to all requests"
time="2026-05-22T11:56:03Z" level=warning msg="Configuration: identity_providers: oidc: clients: client 'forgejo': option 'client_secret' is plaintext but for clients not using any endpoint authentication method 'client_secret_jwt' it should be a hashed value as plaintext values are deprecated with the exception of 'client_secret_jwt' and will be removed in the near future"
time="2026-05-22T11:56:03Z" level=info msg="Authelia v4.39.19 is starting"
time="2026-05-22T11:56:03Z" level=info msg="Log severity set to debug"
time="2026-05-22T11:56:03Z" level=debug msg="Registering OpenID Connect 1.0 client with client id 'forgejo' and policy 'one_factor'"
time="2026-05-22T11:56:03Z" level=info msg="Storage schema is being checked for updates"
time="2026-05-22T11:56:03Z" level=info msg="Storage schema is already up to date"
time="2026-05-22T11:56:03Z" level=debug msg="LDAP Discovery. LDAP Version: 3; Controls: 1.3.6.1.4.1.4203.1.11.1, 1.3.6.1.4.1.4203.1.11.3; Extensions: none; Features: 1.3.6.1.4.1.4203.1.5.1; SASL Mechanisms: none; Vendor Name: LLDAP; Vendor Version: lldap_0.1.1"
time="2026-05-22T11:56:03Z" level=debug msg="webauthn-metadata provider: startup check skipped as it is disabled"
time="2026-05-22T11:56:03Z" level=info msg="Startup complete"
time="2026-05-22T11:56:03Z" level=info msg="Listening for non-TLS connections on '[::]:9091' path '/'" server=main service=server
^C
 --(318)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:56:10 
 󱞩 nvim 
configuration.yml  notification.txt   private.pem        

 --(318)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:56:10 
 󱞩 nvim 
configuration.yml  notification.txt   private.pem        

 --(318)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:56:10 
 󱞩 nvim 
configuration.yml  notification.txt   private.pem        

 --(318)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:56:10 
 󱞩 nvim 
configuration.yml  notification.txt   private.pem        

 --(318)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:56:10 
 󱞩 curl -k https:/curl -k https://auth.local.test:8999/api/health
{"status":"OK"}
 --(319)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:57:27 
 󱞩 curl -k https:/curl -k https://auth.local.test:8999/.well-known/openid-configuration
{"issuer":"https://auth.local.test:8999","jwks_uri":"https://auth.local.test:8999/jwks.json","authorization_endpoint":"https://auth.local.test:8999/api/oidc/authorization","token_endpoint":"https://auth.local.test:8999/api/oidc/token","subject_types_supported":["public","pairwise"],"response_types_supported":["code","id_token","token","id_token token","code id_token","code token","code id_token token"],"grant_types_supported":["authorization_code","implicit","client_credentials","refresh_token","urn:ietf:params:oauth:grant-type:device_code"],"response_modes_supported":["form_post","query","fragment","jwt","form_post.jwt","query.jwt","fragment.jwt"],"scopes_supported":["offline_access","openid","profile","email","address","phone","groups"],"claims_supported":["amr","aud","azp","client_id","exp","iat","iss","jti","rat","auth_time","nonce","groups","sub","name","given_name","family_name","middle_name","nickname","preferred_username","profile","picture","website","email","email_verified","alt_emails","gender","birthdate","zoneinfo","locale","phone_number","phone_number_verified","address","updated_at"],"token_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt","none"],"token_endpoint_auth_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"introspection_endpoint":"https://auth.local.test:8999/api/oidc/introspection","revocation_endpoint":"https://auth.local.test:8999/api/oidc/revocation","introspection_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt"],"revocation_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt","none"],"revocation_endpoint_auth_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"code_challenge_methods_supported":["S256"],"device_authorization_endpoint":"https://auth.local.test:8999/api/oidc/device-authorization","authorization_response_iss_parameter_supported":true,"introspection_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"introspection_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"introspection_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"pushed_authorization_request_endpoint":"https://auth.local.test:8999/api/oidc/pushed-authorization-request","require_pushed_authorization_requests":false,"id_token_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"id_token_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"id_token_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"userinfo_endpoint":"https://auth.local.test:8999/api/oidc/userinfo","userinfo_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"userinfo_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"userinfo_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"request_object_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"request_object_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"request_object_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"claim_types_supported":["normal"],"request_parameter_supported":true,"request_uri_parameter_supported":true,"require_request_uri_registration":true,"claims_parameter_supported":true,"prompt_values_supported":["consent","login","none","select_account"],"authorization_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"authorization_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"authorization_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"]}
 --(320)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  18:57:34 
 󱞩 podman logs -f podman logs -f authelia
time="2026-05-22T11:22:20Z" level=debug msg="Loaded Configuration Sources" files="[/config/configuration.yml]" filters="[]"
time="2026-05-22T11:22:20Z" level=debug msg="Logging Initialized" fields.level=debug file= format= keep_stdout=false
time="2026-05-22T11:22:20Z" level=debug msg="Process user information" gid=0 name=root uid=0 username=root
time="2026-05-22T11:22:20Z" level=warning msg="Configuration: access_control: no rules have been specified so the 'default_policy' of 'one_factor' is going to be applied to all requests"
time="2026-05-22T11:22:20Z" level=warning msg="Configuration: identity_providers: oidc: clients: client 'forgejo': option 'client_secret' is plaintext but for clients not using any endpoint authentication method 'client_secret_jwt' it should be a hashed value as plaintext values are deprecated with the exception of 'client_secret_jwt' and will be removed in the near future"
time="2026-05-22T11:22:20Z" level=info msg="Authelia v4.39.19 is starting"
time="2026-05-22T11:22:20Z" level=info msg="Log severity set to debug"
time="2026-05-22T11:22:20Z" level=debug msg="Registering OpenID Connect 1.0 client with client id 'forgejo' and policy 'one_factor'"
time="2026-05-22T11:22:20Z" level=info msg="Storage schema is being checked for updates"
time="2026-05-22T11:22:20Z" level=info msg="Storage schema migration from 0 to 23 is being attempted"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 0 to 1"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 1 to 2"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 2 to 3"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 3 to 4"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 4 to 5"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 5 to 6"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 6 to 7"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 7 to 8"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 8 to 9"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 9 to 10"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 10 to 11"
time="2026-05-22T11:22:20Z" level=debug msg="Storage schema migrated from version 11 to 12"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 12 to 13"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 13 to 14"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 14 to 15"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 15 to 16"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 16 to 17"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 17 to 18"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 18 to 19"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 19 to 20"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 20 to 21"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 21 to 22"
time="2026-05-22T11:22:21Z" level=debug msg="Storage schema migrated from version 22 to 23"
time="2026-05-22T11:22:21Z" level=info msg="Storage schema migration from 0 to 23 is complete"
time="2026-05-22T11:22:21Z" level=debug msg="LDAP Discovery. LDAP Version: 3; Controls: 1.3.6.1.4.1.4203.1.11.1, 1.3.6.1.4.1.4203.1.11.3; Extensions: none; Features: 1.3.6.1.4.1.4203.1.5.1; SASL Mechanisms: none; Vendor Name: LLDAP; Vendor Version: lldap_0.1.1"
time="2026-05-22T11:22:21Z" level=debug msg="webauthn-metadata provider: startup check skipped as it is disabled"
time="2026-05-22T11:22:21Z" level=info msg="Startup complete"
time="2026-05-22T11:22:21Z" level=info msg="Listening for non-TLS connections on '[::]:9091' path '/'" server=main service=server
time="2026-05-22T11:26:23Z" level=debug msg="Mark 1FA authentication attempt made by user 'ikhsan'" method=POST path=/api/firstfactor remote_ip=10.89.0.28
time="2026-05-22T11:26:23Z" level=debug msg="Successful 1FA authentication attempt made by user 'ikhsan'" method=POST path=/api/firstfactor remote_ip=10.89.0.28
time="2026-05-22T11:54:20Z" level=debug msg="Shutdown initiated due to process signal" signal=terminated
time="2026-05-22T11:54:20Z" level=info msg="Shutdown initiated"
time="2026-05-22T11:54:20Z" level=info msg="Shutdown complete"
time="2026-05-22T11:54:20Z" level=debug msg="Loaded Configuration Sources" files="[/config/configuration.yml]" filters="[]"
time="2026-05-22T11:54:20Z" level=debug msg="Logging Initialized" fields.level=debug file= format= keep_stdout=false
time="2026-05-22T11:54:20Z" level=debug msg="Process user information" gid=0 name=root uid=0 username=root
time="2026-05-22T11:54:20Z" level=warning msg="Configuration: access_control: no rules have been specified so the 'default_policy' of 'one_factor' is going to be applied to all requests"
time="2026-05-22T11:54:20Z" level=warning msg="Configuration: identity_providers: oidc: clients: client 'forgejo': option 'client_secret' is plaintext but for clients not using any endpoint authentication method 'client_secret_jwt' it should be a hashed value as plaintext values are deprecated with the exception of 'client_secret_jwt' and will be removed in the near future"
time="2026-05-22T11:54:20Z" level=error msg="Configuration: configuration key not expected: identity_providers.oidc.issuer" stack="github.com/authelia/authelia/v4/internal/commands/context.go:201 NewRootCmd.(*CmdCtx).ChainRunE.func1\ngithub.com/spf13/cobra@v1.10.2/command.go:1000                   (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148                   (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071                   (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11          main\ninternal/runtime/atomic/types.go:194                             (*Uint32).Load\nruntime/asm_amd64.s:1771                                         goexit"
time="2026-05-22T11:54:20Z" level=fatal msg="Can't continue due to the errors loading the configuration" stack="github.com/authelia/authelia/v4/internal/commands/context.go:201 NewRootCmd.(*CmdCtx).ChainRunE.func1\ngithub.com/spf13/cobra@v1.10.2/command.go:1000                   (*Command).execute\ngithub.com/spf13/cobra@v1.10.2/command.go:1148                   (*Command).ExecuteC\ngithub.com/spf13/cobra@v1.10.2/command.go:1071                   (*Command).Execute\ngithub.com/authelia/authelia/v4/cmd/authelia/main.go:11          main\ninternal/runtime/atomic/types.go:194                             (*Uint32).Load\nruntime/asm_amd64.s:1771                                         goexit"
time="2026-05-22T11:56:03Z" level=debug msg="Loaded Configuration Sources" files="[/config/configuration.yml]" filters="[]"
time="2026-05-22T11:56:03Z" level=debug msg="Logging Initialized" fields.level=debug file= format= keep_stdout=false
time="2026-05-22T11:56:03Z" level=debug msg="Process user information" gid=0 name=root uid=0 username=root
time="2026-05-22T11:56:03Z" level=warning msg="Configuration: access_control: no rules have been specified so the 'default_policy' of 'one_factor' is going to be applied to all requests"
time="2026-05-22T11:56:03Z" level=warning msg="Configuration: identity_providers: oidc: clients: client 'forgejo': option 'client_secret' is plaintext but for clients not using any endpoint authentication method 'client_secret_jwt' it should be a hashed value as plaintext values are deprecated with the exception of 'client_secret_jwt' and will be removed in the near future"
time="2026-05-22T11:56:03Z" level=info msg="Authelia v4.39.19 is starting"
time="2026-05-22T11:56:03Z" level=info msg="Log severity set to debug"
time="2026-05-22T11:56:03Z" level=debug msg="Registering OpenID Connect 1.0 client with client id 'forgejo' and policy 'one_factor'"
time="2026-05-22T11:56:03Z" level=info msg="Storage schema is being checked for updates"
time="2026-05-22T11:56:03Z" level=info msg="Storage schema is already up to date"
time="2026-05-22T11:56:03Z" level=debug msg="LDAP Discovery. LDAP Version: 3; Controls: 1.3.6.1.4.1.4203.1.11.1, 1.3.6.1.4.1.4203.1.11.3; Extensions: none; Features: 1.3.6.1.4.1.4203.1.5.1; SASL Mechanisms: none; Vendor Name: LLDAP; Vendor Version: lldap_0.1.1"
time="2026-05-22T11:56:03Z" level=debug msg="webauthn-metadata provider: startup check skipped as it is disabled"
time="2026-05-22T11:56:03Z" level=info msg="Startup complete"
time="2026-05-22T11:56:03Z" level=info msg="Listening for non-TLS connections on '[::]:9091' path '/'" server=main service=server
time="2026-05-22T12:00:21Z" level=error msg="OpenID Connect 1.0 Discovery Request could not be processed: error occurred determining the effective issuer for the given request" error="invalid X-Forwarded-Proto header value 'http'" method=GET path=/.well-known/openid-configuration remote_ip=10.89.0.29 stack="github.com/authelia/authelia/v4/internal/handlers/handler_oauth2_oidc_wellknown.go:27 WellKnownOpenIDConfigurationGET\ngithub.com/authelia/authelia/v4/internal/middlewares/bridge.go:66                     RegisterOpenIDConnectRoutes.(*BridgeBuilder).Build.func2.1\ngithub.com/authelia/authelia/v4/internal/middlewares/headers.go:105                   SecurityHeadersNoStore.func1\ngithub.com/valyala/fasthttp@v1.70.0/server.go:779                                     (*RequestCtx).UserValue\ngithub.com/authelia/authelia/v4/internal/middlewares/headers.go:30                    SecurityHeadersBase.func1\ngithub.com/authelia/authelia/v4/internal/middlewares/cors.go:216                      RegisterOpenIDConnectRoutes.(*CORSPolicy).Middleware.func5\ngithub.com/fasthttp/router@v1.5.4/router.go:441                                       (*Router).Handler\ngithub.com/authelia/authelia/v4/internal/middlewares/log_request.go:14                handlerMain.LogRequest.func30\ngithub.com/authelia/authelia/v4/internal/middlewares/errors.go:38                     RecoverPanic.func1\ngithub.com/valyala/fasthttp@v1.70.0/server.go:2513                                    (*Server).serveConn\ngithub.com/valyala/fasthttp@v1.70.0/workerpool.go:225                                 (*workerPool).workerFunc\ngithub.com/valyala/fasthttp@v1.70.0/workerpool.go:197                                 (*workerPool).getCh.func1\nruntime/asm_amd64.s:1771                                                              goexit"
^C
 --(321)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  19:00:56 
 󱞩 curl http://loccurl http://localhost:9091/.well-known/openid-configuration
curl: (7) Failed to connect to localhost port 9091 after 0 ms: Could not connect to server

 --(322)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  19:01:00 
 󱞩 podman exec -itpodman exec -it forgejo sh
/ # wget -qO- http://authelia:9091/api/health
{"status":"OK"}/ # wget -qO- http://authelia:9091/.well-known/openid-configuration
wget: server returned error: HTTP/1.1 500 Internal Server Error
/ # wget -qO- http://authelia:9091/.well-known/openid-configuration
wget: server returned error: HTTP/1.1 500 Internal Server Error
/ # exit

 --(323)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  19:02:30 
 󱞩 podman rm -f fopodman rm -f forgejo
forgejo

 --(324)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  19:02:32 
 󱞩 podman run -d \podman run -d \
  --name forgejo \
  --network homelab \
  --add-host auth.local.test:10.89.0.1 \
  --add-host git.local.test:10.89.0.1 \
  -v ~/.config/containers/forgejo:/data:Z \
  -e USER_UID=1000 \
  -e USER_GID=1000 \
  -e FORGEJO__database__DB_TYPE=postgres \
  -e FORGEJO__database__HOST=postgres:5432 \
  -e FORGEJO__database__NAME=forgejo \
  -e FORGEJO__database__USER=forgejo \
  -e FORGEJO__database__PASSWD=forgejo123 \
  -e FORGEJO__server__ROOT_URL=https://git.local.test:8999/ \
  -e FORGEJO__server__DOMAIN=git.local.test \
  -e FORGEJO__server__PROTOCOL=http \
  -e FORGEJO__server__HTTP_PORT=3000 \
  -l 'traefik.enable=true' \
  -l 'traefik.http.routers.forgejo.rule=Host(`git.local.test`)' \
  -l 'traefik.http.routers.forgejo.entrypoints=websecure' \
  -l 'traefik.http.routers.forgejo.tls=true' \
  -l 'traefik.http.services.forgejo.loadbalancer.server.port=3000' \
  codeberg.org/forgejo/forgejo:15
e9a7fb51ec26555df601baad6d94ff8103e2657470c5ae386dccc1d9e28eb715

 --(325)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  19:02:37 
 󱞩 podman exec -itpodman exec -it forgejo sh
/ # wget -qO- https://auth.local.test:8999/api/health --no-check-certificate
{"status":"OK"}/ # wget -qO- https://auth.local.test:8999/.well-known/openid-configuration --
no-check-certificate
{"issuer":"https://auth.local.test:8999","jwks_uri":"https://auth.local.test:8999/jwks.json","authorization_endpoint":"https://auth.local.test:8999/api/oidc/authorization","token_endpoint":"https://auth.local.test:8999/api/oidc/token","subject_types_supported":["public","pairwise"],"response_types_supported":["code","id_token","token","id_token token","code id_token","code token","code id_token token"],"grant_types_supported":["authorization_code","implicit","client_credentials","refresh_token","urn:ietf:params:oauth:grant-type:device_code"],"response_modes_supported":["form_post","query","fragment","jwt","form_post.jwt","query.jwt","fragment.jwt"],"scopes_supported":["offline_access","openid","profile","email","address","phone","groups"],"claims_supported":["amr","aud","azp","client_id","exp","iat","iss","jti","rat","auth_time","nonce","groups","sub","name","given_name","family_name","middle_name","nickname","preferred_username","profile","picture","website","email","email_verified","alt_emails","gender","birthdate","zoneinfo","locale","phone_number","phone_number_verified","address","updated_at"],"token_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt","none"],"token_endpoint_auth_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"introspection_endpoint":"https://auth.local.test:8999/api/oidc/introspection","revocation_endpoint":"https://auth.local.test:8999/api/oidc/revocation","introspection_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt"],"revocation_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt","none"],"revocation_endpoint_auth_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"code_challenge_methods_supported":["S256"],"device_authorization_endpoint":"https://auth.local.test:8999/api/oidc/device-authorization","authorization_response_iss_parameter_supported":true,"introspection_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"introspection_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"introspection_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"pushed_authorization_request_endpoint":"https://auth.local.test:8999/api/oidc/pushed-authorization-request","require_pushed_authorization_requests":false,"id_token_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"id_token_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"id_token_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"userinfo_endpoint":"https://auth.local.test:8999/api/oidc/userinfo","userinfo_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"userinfo_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"userinfo_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"request_object_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"request_object_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"request_object_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"claim_types_supported":["normal"],"request_parameter_supported":true,"request_uri_parameter_supported":true,"require_request_uri_registration":true,"claims_parameter_supported":true,"prompt_values_supported":["consent","login","none","select_account"],"authorization_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"authorization_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"authorization_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"]}/ # exit

 󱞩 podman cp $(mkcert -CAROOT)/rootCA.pem forgejo:/usr/local/share/ca-certificates/mkcert.crt
 󱞩 podman cp $(mkcert -CAROOT)/rootCA.pem forgejo:/usr/local/share/ca-certificates/mkcert.crt
 --(327)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  19:17:19 
 󱞩 podman exec -itpodman exec -it forgejo sh
/ # update-ca-certificates
/ # exit

 --(328)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  19:17:39 
 󱞩 podman restart podman restart forgejo
forgejo

 --(329)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  19:17:44 
 󱞩 podman exec -itpodman exec -it forgejo sh
/ # wget -qO- https://auth.local.test:8999/.well-known/openid-configuration
{"issuer":"https://auth.local.test:8999","jwks_uri":"https://auth.local.test:8999/jwks.json","authorization_endpoint":"https://auth.local.test:8999/api/oidc/authorization","token_endpoint":"https://auth.local.test:8999/api/oidc/token","subject_types_supported":["public","pairwise"],"response_types_supported":["code","id_token","token","id_token token","code id_token","code token","code id_token token"],"grant_types_supported":["authorization_code","implicit","client_credentials","refresh_token","urn:ietf:params:oauth:grant-type:device_code"],"response_modes_supported":["form_post","query","fragment","jwt","form_post.jwt","query.jwt","fragment.jwt"],"scopes_supported":["offline_access","openid","profile","email","address","phone","groups"],"claims_supported":["amr","aud","azp","client_id","exp","iat","iss","jti","rat","auth_time","nonce","groups","sub","name","given_name","family_name","middle_name","nickname","preferred_username","profile","picture","website","email","email_verified","alt_emails","gender","birthdate","zoneinfo","locale","phone_number","phone_number_verified","address","updated_at"],"token_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt","none"],"token_endpoint_auth_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"introspection_endpoint":"https://auth.local.test:8999/api/oidc/introspection","revocation_endpoint":"https://auth.local.test:8999/api/oidc/revocation","introspection_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt"],"revocation_endpoint_auth_methods_supported":["client_secret_basic","client_secret_post","client_secret_jwt","private_key_jwt","none"],"revocation_endpoint_auth_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"code_challenge_methods_supported":["S256"],"device_authorization_endpoint":"https://auth.local.test:8999/api/oidc/device-authorization","authorization_response_iss_parameter_supported":true,"introspection_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"introspection_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"introspection_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"pushed_authorization_request_endpoint":"https://auth.local.test:8999/api/oidc/pushed-authorization-request","require_pushed_authorization_requests":false,"id_token_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"id_token_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"id_token_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"userinfo_endpoint":"https://auth.local.test:8999/api/oidc/userinfo","userinfo_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"userinfo_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"userinfo_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"request_object_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512","none"],"request_object_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"request_object_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"],"claim_types_supported":["normal"],"request_parameter_supported":true,"request_uri_parameter_supported":true,"require_request_uri_registration":true,"claims_parameter_supported":true,"prompt_values_supported":["consent","login","none","select_account"],"authorization_signing_alg_values_supported":["HS256","HS384","HS512","RS256","RS384","RS512","ES256","ES384","ES512","PS256","PS384","PS512"],"authorization_encryption_alg_values_supported":["RSA1_5","RSA-OAEP","RSA-OAEP-256","A128KW","A192KW","A256KW","dir","ECDH-ES","ECDH-ES+A128KW","ECDH-ES+A192KW","ECDH-ES+A256KW","A128GCMKW","A192GCMKW","A256GCMKW","PBES2-HS256+A128KW","PBES2-HS384+A192KW","PBES2-HS512+A256KW"],"authorization_encryption_enc_values_supported":["A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"]}/ # ^C

/ # exit

 --(330)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  19:17:55 
 󱞩 podman exec -itpodman exec -it forgejo sh
/ # find / -name app.ini 2>/dev/null
/etc/templates/app.ini
/data/gitea/conf/app.ini
/ # vi /data/gitea/conf/app.ini
/ # exit

 --(331)--( user@system )-->  /home/sultan/.config/containers/authelia |-->  19:41:31 
 󱞩 podman restart forgejo 
forgejo
```
