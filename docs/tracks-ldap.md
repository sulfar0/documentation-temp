```
[root@system sultan]# nvim /etc/pam.d/system-auth 
[root@system sultan]# cp /etc/pam.d/system-auth /etc/pam.d/system-auth.bak
[root@system sultan]# nvim /etc/pam.d/system-auth 
[root@system sultan]# nvim /etc/pam.d/system-auth 
[root@system sultan]# nvim /etc/pam.d/system-auth 
[root@system sultan]# cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
[root@system sultan]# nvim /etc/nsswitch.conf
[root@system sultan]# nvim /etc/sssd/sssd.conf
[root@system sultan]# cp /etc/openldap/ldap.conf /etc/openldap/ldap.conf.bak
[root@system sultan]# sudo nvim /etc/openldap/ldap.conf
[root@system sultan]# sudo chown -R sssd:sssd /var/lib/sss/db/ /var/log/sssd/
[root@system sultan]# sudo chown root:root /etc/sssd/sssd.conf
[root@system sultan]# sudo chmod 600 /etc/sssd/sssd.conf
[root@system sultan]# sudo systemctl enable --now sssd
Created symlink '/etc/systemd/system/multi-user.target.wants/sssd.service' → '/usr/lib/systemd/system/sssd.service'.
[root@system sultan]# systemctl status sssd
● sssd.service - System Security Services Daemon
     Loaded: loaded (/usr/lib/systemd/system/sssd.service; enabled; preset: disabled)
     Active: active (running) since Wed 2026-05-13 13:16:35 WIB; 7s ago
 Invocation: f58712115060450b8848b66bbf068544
    Process: 335380 ExecStartPre=/bin/chown -f -R -H root:sssd /etc/sssd (code=exited, status=0/SUCCESS)
    Process: 335382 ExecStartPre=/bin/chmod -f -R g+r /etc/sssd (code=exited, status=0/SUCCESS)
    Process: 335384 ExecStartPre=/bin/chmod -f g+x /etc/sssd (code=exited, status=0/SUCCESS)
    Process: 335386 ExecStartPre=/bin/chmod -f g+x /etc/sssd/conf.d (code=exited, status=0/SUCCESS)
    Process: 335388 ExecStartPre=/bin/chmod -f g+x /etc/sssd/pki (code=exited, status=0/SUCCESS)
    Process: 335390 ExecStartPre=/bin/sh -c /bin/chown -f -h sssd:sssd /var/lib/sss/db/*.ldb (code=exited, status=1/FAILURE)
    Process: 335392 ExecStartPre=/bin/chown -f -R -h sssd:sssd /var/lib/sss/gpo_cache (code=exited, status=0/SUCCESS)
    Process: 335394 ExecStartPre=/bin/sh -c /bin/chown -f -h sssd:sssd /var/log/sssd/*.log* (code=exited, status=1/FAILURE)
   Main PID: 335395 (sssd)
      Tasks: 4 (limit: 8628)
     Memory: 57.6M (peak: 58M)
        CPU: 324ms
     CGroup: /system.slice/sssd.service
             ├─335395 /usr/bin/sssd -i --logger=files
             ├─335397 /usr/lib/sssd/sssd/sssd_be --domain office.local --logger=files
             ├─335398 /usr/lib/sssd/sssd/sssd_nss --logger=files
             └─335399 /usr/lib/sssd/sssd/sssd_pam --logger=files

May 13 13:16:35 system systemd[1]: Starting System Security Services Daemon...
May 13 13:16:35 system sssd[335395]: Starting up
May 13 13:16:35 system sssd_be[335397]: Starting up
May 13 13:16:35 system sssd_nss[335398]: Starting up
May 13 13:16:35 system sssd_pam[335399]: Starting up
May 13 13:16:35 system systemd[1]: Started System Security Services Daemon.
[root@system sultan]# id ikhsan
id: ‘ikhsan’: no such user
[root@system sultan]# sudo systemctl stop sssd
[root@system sultan]# sudo rm -rf /var/lib/sss/db/*
[root@system sultan]# sudo systemctl start sssd
[root@system sultan]# systemctl status sssd
● sssd.service - System Security Services Daemon
     Loaded: loaded (/usr/lib/systemd/system/sssd.service; enabled; preset: disabled)
     Active: active (running) since Wed 2026-05-13 13:20:21 WIB; 5s ago
 Invocation: 059134a00f0d451a989efc80f10805f5
    Process: 336338 ExecStartPre=/bin/chown -f -R -H root:sssd /etc/sssd (code=exited, status=0/SUCCESS)
    Process: 336340 ExecStartPre=/bin/chmod -f -R g+r /etc/sssd (code=exited, status=0/SUCCESS)
    Process: 336342 ExecStartPre=/bin/chmod -f g+x /etc/sssd (code=exited, status=0/SUCCESS)
    Process: 336344 ExecStartPre=/bin/chmod -f g+x /etc/sssd/conf.d (code=exited, status=0/SUCCESS)
    Process: 336346 ExecStartPre=/bin/chmod -f g+x /etc/sssd/pki (code=exited, status=0/SUCCESS)
    Process: 336348 ExecStartPre=/bin/sh -c /bin/chown -f -h sssd:sssd /var/lib/sss/db/*.ldb (code=exited, status=1/FAILURE)
    Process: 336350 ExecStartPre=/bin/chown -f -R -h sssd:sssd /var/lib/sss/gpo_cache (code=exited, status=0/SUCCESS)
    Process: 336352 ExecStartPre=/bin/sh -c /bin/chown -f -h sssd:sssd /var/log/sssd/*.log* (code=exited, status=0/SUCCESS)
   Main PID: 336354 (sssd)
      Tasks: 4 (limit: 8628)
     Memory: 54.5M (peak: 54.5M)
        CPU: 336ms
     CGroup: /system.slice/sssd.service
             ├─336354 /usr/bin/sssd -i --logger=files
             ├─336356 /usr/lib/sssd/sssd/sssd_be --domain office.local --logger=files
             ├─336357 /usr/lib/sssd/sssd/sssd_nss --logger=files
             └─336358 /usr/lib/sssd/sssd/sssd_pam --logger=files

May 13 13:20:20 system systemd[1]: Starting System Security Services Daemon...
May 13 13:20:20 system sssd[336354]: Starting up
May 13 13:20:21 system sssd_be[336356]: Starting up
May 13 13:20:21 system sssd_nss[336357]: Starting up
May 13 13:20:21 system sssd_pam[336358]: Starting up
May 13 13:20:21 system systemd[1]: Started System Security Services Daemon.
[root@system sultan]# id ikhsan
id: ‘ikhsan’: no such user
[root@system sultan]# sudo systemctl stop sssd
[root@system sultan]# sudo rm -rf /var/lib/sss/db/*
[root@system sultan]# nvim /etc/nsswitch.conf
[root@system sultan]# systemctl start sssd
[root@system sultan]# systemctl status sssd
● sssd.service - System Security Services Daemon
     Loaded: loaded (/usr/lib/systemd/system/sssd.service; enabled; preset: disabled)
     Active: active (running) since Wed 2026-05-13 13:23:06 WIB; 4s ago
 Invocation: 6a05c69f5c7e494e9476be23e135a585
    Process: 336682 ExecStartPre=/bin/chown -f -R -H root:sssd /etc/sssd (code=exited, status=0/SUCCESS)
    Process: 336684 ExecStartPre=/bin/chmod -f -R g+r /etc/sssd (code=exited, status=0/SUCCESS)
    Process: 336686 ExecStartPre=/bin/chmod -f g+x /etc/sssd (code=exited, status=0/SUCCESS)
    Process: 336688 ExecStartPre=/bin/chmod -f g+x /etc/sssd/conf.d (code=exited, status=0/SUCCESS)
    Process: 336690 ExecStartPre=/bin/chmod -f g+x /etc/sssd/pki (code=exited, status=0/SUCCESS)
    Process: 336692 ExecStartPre=/bin/sh -c /bin/chown -f -h sssd:sssd /var/lib/sss/db/*.ldb (code=exited, status=1/FAILURE)
    Process: 336694 ExecStartPre=/bin/chown -f -R -h sssd:sssd /var/lib/sss/gpo_cache (code=exited, status=0/SUCCESS)
    Process: 336696 ExecStartPre=/bin/sh -c /bin/chown -f -h sssd:sssd /var/log/sssd/*.log* (code=exited, status=0/SUCCESS)
   Main PID: 336698 (sssd)
      Tasks: 4 (limit: 8628)
     Memory: 54.2M (peak: 54.6M)
        CPU: 337ms
     CGroup: /system.slice/sssd.service
             ├─336698 /usr/bin/sssd -i --logger=files
             ├─336699 /usr/lib/sssd/sssd/sssd_be --domain office.local --logger=files
             ├─336700 /usr/lib/sssd/sssd/sssd_nss --logger=files
             └─336701 /usr/lib/sssd/sssd/sssd_pam --logger=files

May 13 13:23:06 system systemd[1]: Starting System Security Services Daemon...
May 13 13:23:06 system sssd[336698]: Starting up
May 13 13:23:06 system sssd_be[336699]: Starting up
May 13 13:23:06 system sssd_nss[336700]: Starting up
May 13 13:23:06 system sssd_pam[336701]: Starting up
May 13 13:23:06 system systemd[1]: Started System Security Services Daemon.
[root@system sultan]# id ikhsan
id: ‘ikhsan’: no such user
[root@system sultan]# sudo systemctl stop sssd
[root@system sultan]# sudo rm -rf /var/lib/sss/db/*
[root@system sultan]# nvim /etc/sssd/sssd.conf 
[root@system sultan]# systemctl start sssd
[root@system sultan]# id ikhsan
id: ‘ikhsan’: no such user
[root@system sultan]# su uikhsan
su: user uikhsan does not exist or the user entry does not contain all the required fields
[root@system sultan]# su ikhsan
su: user ikhsan does not exist or the user entry does not contain all the required fields
[root@system sultan]# mv /etc/openldap/ldap.conf.bak /etc/openldap/ldap.conf
[root@system sultan]# mv /etc/hosts.bak /etc/hosts
mv: cannot stat '/etc/hosts.bak': No such file or directory
[root@system sultan]# sudo systemctl stop sssd
[root@system sultan]# sudo rm -rf /var/lib/sss/db/*
[root@system sultan]# echo "" > /etc/sssd/sssd.conf
[root@system sultan]# mv /etc/nsswitch.conf.bak /etc/nsswitch.conf
[root@system sultan]# mv /etc/pam.d/system-auth.bak /etc/pam.d/system-auth
[root@system sultan]# ldapsearch -Y EXTERNAL -H ldapi:/// -b cn=schema,cn=config dn
ldap_sasl_interactive_bind: Can't contact LDAP server (-1)
[root@system sultan]# nvim auth       sufficient   pam_sss.so
account    sufficient   pam_sss.so
password   sufficient   pam_sss.so
session    optional     pam_sss.so^C
[root@system sultan]# nvim /etc/pam.d/sshd 
[root@system sultan]# nvim /etc/pam.d/sshd 
[root@system sultan]# nvim /etc/ssh/sshd_config
[root@system sultan]# systemctl restart sshd
[root@system sultan]# nvim /etc/pam.d/sshd 
[root@system sultan]# cat /etc/ssh/sshd_config
# Include drop-in configurations
Include /etc/ssh/sshd_config.d/*.conf

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/sbin:/usr/local/bin:/usr/bin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to "no" here!
PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to "no" to disable keyboard-interactive authentication.  Depending on
# the system's configuration, this may involve passwords, challenge-response,
# one-time passwords or some combination of these and other methods.
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin prohibit-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem	sftp	/usr/lib/ssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server
[root@system sultan]# cat /etc/pam.d/system-auth 
#%PAM-1.0

auth       required                    pam_faillock.so      preauth
# Optionally use requisite above if you do not want to prompt for the password
# on locked accounts.
-auth      [success=2 default=ignore]  pam_systemd_home.so
auth       [success=1 default=bad]     pam_unix.so          try_first_pass nullok
auth       [default=die]               pam_faillock.so      authfail
auth       optional                    pam_permit.so
auth       required                    pam_env.so
auth       required                    pam_faillock.so      authsucc
# If you drop the above call to pam_faillock.so the lock will be done also
# on non-consecutive authentication failures.

-account   [success=1 default=ignore]  pam_systemd_home.so
account    required                    pam_unix.so
account    optional                    pam_permit.so
account    required                    pam_time.so

-password  [success=1 default=ignore]  pam_systemd_home.so
password   required                    pam_unix.so          try_first_pass nullok shadow
password   optional                    pam_permit.so

-session   optional                    pam_systemd_home.so
session    required                    pam_limits.so
session    required                    pam_unix.so
session    optional                    pam_permit.so
[root@system sultan]# cat /etc/pam.d/sshd 
#%PAM-1.0

auth       sufficient   system-auth
account    sufficient   system-auth
password   sufficient   system-auth
session    optional     system-auth
[root@system sultan]# nvim /etc/pam.d/system-
[root@system sultan]# nvim /etc/pam.d/system-auth 
[root@system sultan]# sudo systemctl restart sssd
Job for sssd.service failed because the control process exited with error code.
See "systemctl status sssd.service" and "journalctl -xeu sssd.service" for details.
[root@system sultan]# systemctl status sshd
● sshd.service - OpenSSH Daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: disabled)
     Active: active (running) since Wed 2026-05-13 14:49:45 WIB; 4min 13s ago
 Invocation: 606fa51b4ade40199d65960238c0aa66
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 352241 (sshd)
      Tasks: 1 (limit: 8628)
     Memory: 1.3M (peak: 5.7M)
        CPU: 84ms
     CGroup: /system.slice/sshd.service
             └─352241 "sshd: /usr/bin/sshd -D [listener] 0 of 10-100 startups"

May 13 14:50:21 system sshd-session[352317]: PAM unable to dlopen(/usr/lib/security/system-auth): /usr/lib/security/system-auth: cannot open shared object file: No such file or directory
May 13 14:50:21 system sshd-session[352317]: PAM adding faulty module: /usr/lib/security/system-auth
May 13 14:50:22 system sshd-session[352317]: Failed password for invalid user budi from 127.0.0.1 port 56852 ssh2
May 13 14:50:23 system sshd-session[352317]: Connection closed by invalid user budi 127.0.0.1 port 56852 [preauth]
May 13 14:53:37 system sshd-session[352846]: Invalid user budi from 127.0.0.1 port 44996
May 13 14:53:37 system sshd-session[352846]: PAM unable to dlopen(/usr/lib/security/system-auth): /usr/lib/security/system-auth: cannot open shared object file: No such file or directory
May 13 14:53:37 system sshd-session[352846]: PAM adding faulty module: /usr/lib/security/system-auth
May 13 14:53:39 system sshd-session[352846]: Failed password for invalid user budi from 127.0.0.1 port 44996 ssh2
May 13 14:53:41 system sshd-session[352846]: Failed password for invalid user budi from 127.0.0.1 port 44996 ssh2
May 13 14:53:42 system sshd-session[352846]: Connection closed by invalid user budi 127.0.0.1 port 44996 [preauth]
[root@system sultan]# nivm /etc/pam.d/sshd 
bash: nivm: command not found
[root@system sultan]# nvim /etc/pam.d/sshd 
[root@system sultan]# systemctl restart sshd
[root@system sultan]# cd /etc/pam.d/
[root@system pam.d]# ls
chfn	  hyprlock  passwd	sshd		 sudo		     system-remote-login
chpasswd   login     remote	sssd-shadowutils  system-auth	     system-services
chsh	  newusers  runuser	su		 system-local-login  vlock
groupmems  other     runuser-l	su-l		 system-login
[root@system pam.d]#
```

```
 --(16)--( user@system )-->  /home/sultan |-->  02:11:52 
 󱞩 podman run -d \podman run -d \
 --name ldap \
 --network podman \
 -p 0.0.0.0:1389:389 \
 -p 0.0.0.0:1636:636 \
 -v ldap-data:/var/lib/ldap:Z \
 -v ldap-config:/etc/ldap/slapd.d:Z \
 -e LDAP_ORGANISATION="yuros" \
 -e LDAP_DOMAIN="office.local" \
 -e LDAP_ADMIN_PASSWORD="1511" \
 -e LDAP_TLS="true" \
 -e LDAP_TLS_ENFORCE="true" \
 --restart always \
 osixia/openldap:latest
899258bf95389b1cefb01fe4c0686d4545fa79f98d805f9a126a4383f11d8ece

 --(17)--( user@system )-->  /home/sultan |-->  02:11:58 
 󱞩 podman exec -i podman exec -i ldap env LDAPTLS_REQCERT=never ldapadd -x -H ldaps://127.0.0.1:636 -D "cn=admin,dc=office,dc=local" -w 1511 < base.ldif
ldap_result: Can't contact LDAP server (-1)

 --(18)--( user@system )-->  /home/sultan |-->  02:12:06 
 󱞩 podman exec -i ldap enlogs ldap
***  INFO   | 2026-05-12 19:11:58 | CONTAINER_LOG_LEVEL = 3 (info)
***  INFO   | 2026-05-12 19:11:58 | Search service in CONTAINER_SERVICE_DIR = /container/service :
***  INFO   | 2026-05-12 19:11:58 | link /container/service/:ssl-tools/startup.sh to /container/run/startup/:ssl-tools
***  INFO   | 2026-05-12 19:11:58 | link /container/service/slapd/startup.sh to /container/run/startup/slapd
***  INFO   | 2026-05-12 19:11:58 | link /container/service/slapd/process.sh to /container/run/process/slapd/run
***  INFO   | 2026-05-12 19:11:58 | Environment files will be proccessed in this order : 
Caution: previously defined variables will not be overriden.
/container/environment/99-default/default.startup.yaml
/container/environment/99-default/default.yaml

To see how this files are processed and environment variables values,
run this container with '--loglevel debug'
***  INFO   | 2026-05-12 19:11:58 | Running /container/run/startup/:ssl-tools...
***  INFO   | 2026-05-12 19:11:58 | Running /container/run/startup/slapd...
***  INFO   | 2026-05-12 19:11:58 | openldap user and group adjustments
***  INFO   | 2026-05-12 19:11:58 | get current openldap uid/gid info inside container
***  INFO   | 2026-05-12 19:11:58 | -------------------------------------
***  INFO   | 2026-05-12 19:11:58 | openldap GID/UID
***  INFO   | 2026-05-12 19:11:58 | -------------------------------------
***  INFO   | 2026-05-12 19:11:58 | User uid: 911
***  INFO   | 2026-05-12 19:11:58 | User gid: 911
***  INFO   | 2026-05-12 19:11:58 | uid/gid changed: false
***  INFO   | 2026-05-12 19:11:58 | -------------------------------------
***  INFO   | 2026-05-12 19:11:58 | updating file uid/gid ownership
***  INFO   | 2026-05-12 19:11:58 | Database and config directory are empty...
***  INFO   | 2026-05-12 19:11:58 | Init new ldap server...
  Backing up /etc/ldap/slapd.d in /var/backups/slapd-2.4.57+dfsg-1~bpo10+1... done.
  Creating initial configuration... done.
  Creating LDAP directory... done.
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of restart.
***  INFO   | 2026-05-12 19:11:58 | Start OpenLDAP...
***  INFO   | 2026-05-12 19:11:58 | Waiting for OpenLDAP to start...
***  INFO   | 2026-05-12 19:11:58 | Add bootstrap schemas...
config file testing succeeded
***  INFO   | 2026-05-12 19:11:59 | Add image bootstrap ldif...
***  INFO   | 2026-05-12 19:11:59 | Add custom bootstrap ldif...
***  INFO   | 2026-05-12 19:11:59 | Add TLS config...
***  INFO   | 2026-05-12 19:11:59 | No certificate file and certificate key provided, generate:
***  INFO   | 2026-05-12 19:11:59 | /container/service/slapd/assets/certs/ldap.crt and /container/service/slapd/assets/certs/ldap.key
2026/05/12 19:11:59 [INFO] generate received request
2026/05/12 19:11:59 [INFO] received CSR
2026/05/12 19:11:59 [INFO] generating key: ecdsa-384
2026/05/12 19:11:59 [INFO] encoded CSR
2026/05/12 19:11:59 [INFO] signed certificate with serial number 726843971258162583521439516723172405222706519050
***  INFO   | 2026-05-12 19:11:59 | Link /container/service/:ssl-tools/assets/default-ca/default-ca.pem to /container/service/slapd/assets/certs/ca.crt
***  INFO   | 2026-05-12 19:11:59 | Add enforce TLS...
***  INFO   | 2026-05-12 19:11:59 | Disable replication config...
***  INFO   | 2026-05-12 19:11:59 | Stop OpenLDAP...
***  INFO   | 2026-05-12 19:11:59 | Configure ldap client TLS configuration...
***  INFO   | 2026-05-12 19:11:59 | Remove config files...
***  INFO   | 2026-05-12 19:11:59 | First start is done...
***  INFO   | 2026-05-12 19:11:59 | Remove file /container/environment/99-default/default.startup.yaml
***  INFO   | 2026-05-12 19:11:59 | Environment files will be proccessed in this order : 
Caution: previously defined variables will not be overriden.
/container/environment/99-default/default.yaml

To see how this files are processed and environment variables values,
run this container with '--loglevel debug'
***  INFO   | 2026-05-12 19:11:59 | Running /container/run/process/slapd/run...
6a037b7f @(#) $OpenLDAP: slapd 2.4.57+dfsg-1~bpo10+1 (Jan 30 2021 06:59:51) $
	Debian OpenLDAP Maintainers <pkg-openldap-devel@lists.alioth.debian.org>
6a037b7f slapd starting
6a037b86 conn=1000 fd=12 ACCEPT from IP=127.0.0.1:33742 (IP=0.0.0.0:636)
TLS: can't accept: (unknown error code).
6a037b86 conn=1000 fd=12 closed (TLS negotiation failure)

 --(19)--( user@system )-->  /home/sultan |-->  02:12:12 
 󱞩 podman exec -i podman exec -i ldap ldapadd -Y EXTERNAL -H ldapi:/// < base.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "ou=people,dc=office,dc=local"


 --(20)--( user@system )-->  /home/sultan |-->  02:12:49 
 󱞩 podman exec -itpodman exec -it ldap slappasswd
New password: 
Re-enter new password: 
{SSHA}JEMKkKEumeFIhjtz2uHK+3/casvxvgQz

 --(21)--( user@system )-->  /home/sultan |-->  02:13:42 
 󱞩 nvim karyawan.ldif 

 --(22)--( user@system )-->  /home/sultan |-->  02:13:57 
 󱞩 podman exec -i podman exec -i ldap ldapadd -Y EXTERNAL -H ldapi:/// < karyawan.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "uid=ikhsan,ou=people,dc=office,dc=local"


 --(23)--( user@system )-->  /home/sultan |-->  02:14:11 
 󱞩 ^C

 --(23)--( user@system )-->  /home/sultan |-->  02:17:58 
 󱞩 cat karyawan.ldif 
dn: uid=ikhsan,ou=people,dc=office,dc=local
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: ikhsan
uid: ikhsan
uidNumber: 10001
gidNumber: 10001
homeDirectory: /home/ikhsan
loginShell: /usr/bin/bash
userPassword: {SSHA}JEMKkKEumeFIhjtz2uHK+3/casvxvgQz 
shadowLastChange: 0
shadowMax: 365
shadowWarning: 7

 --(24)--( user@system )-->  /home/sultan |-->  02:18:13 
 󱞩 podman cp ldap:podman cp ldap:/container/service/slapd/assets/certs/ca.crt /tmp/ca.crt

 --(25)--( user@system )-->  /home/sultan |-->  02:53:36 
 󱞩 cd /tmp/

 --(26)--( user@system )-->  /tmp |-->  02:53:40 
 󱞩 ls
69e1204e-5f22-4900-93d7-092717bad3d7.zip
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-10171
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-10179
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-1969
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-1988
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-2440
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-2450
bd9ccae75ce72a4ddb4260b3c0743e13-{87A94AB0-E370-4cde-98D3-ACC110C5967D}
ca.crt
nvim.root
systemd-private-14962ccda51e487bb4bffea8a111b500-iwd.service-ii40Oh
systemd-private-14962ccda51e487bb4bffea8a111b500-polkit.service-KbISK8
systemd-private-14962ccda51e487bb4bffea8a111b500-systemd-logind.service-xs5DkM
systemd-private-14962ccda51e487bb4bffea8a111b500-upower.service-7xmlwF

 --(27)--( user@system )-->  /tmp |-->  02:53:42 
 󱞩 scp ca.crt user@172.26.1.16

 --(28)--( user@system )-->  /tmp |-->  02:54:16 
 󱞩 ls
69e1204e-5f22-4900-93d7-092717bad3d7.zip
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-10171
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-10179
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-1969
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-1988
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-2440
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-2450
bd9ccae75ce72a4ddb4260b3c0743e13-{87A94AB0-E370-4cde-98D3-ACC110C5967D}
ca.crt
nvim.root
systemd-private-14962ccda51e487bb4bffea8a111b500-iwd.service-ii40Oh
systemd-private-14962ccda51e487bb4bffea8a111b500-polkit.service-KbISK8
systemd-private-14962ccda51e487bb4bffea8a111b500-systemd-logind.service-xs5DkM
systemd-private-14962ccda51e487bb4bffea8a111b500-upower.service-7xmlwF
user@172.26.1.16

 --(29)--( user@system )-->  /tmp |-->  02:54:19 
 󱞩 ls ca.crt 
.ICE-unix/
.X0-lock
.X11-unix/
.XIM-unix/
.font-unix/
69e1204e-5f22-4900-93d7-092717bad3d7.zip
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-10171
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-10179
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-1969
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-1988
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-2440
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-2450
bd9ccae75ce72a4ddb4260b3c0743e13-{87A94AB0-E370-4cde-98D3-ACC110C5967D}
ca.crt
nvim.root/
systemd-private-14962ccda51e487bb4bffea8a111b500-iwd.service-ii40Oh/
systemd-private-14962ccda51e487bb4bffea8a111b500-polkit.service-KbISK8/
systemd-private-14962ccda51e487bb4bffea8a111b500-systemd-logind.service-xs5DkM/
systemd-private-14962ccda51e487bb4bffea8a111b500-upower.service-7xmlwF/
user@172.26.1.16

 --(29)--( user@system )-->  /tmp |-->  02:54:19 
 󱞩 scp ca.crt user@172.26.1.16:/home/mirja
user@172.26.1.16's password: 
ca.crt                                                     100%  989     9.7KB/s   00:00    

 --(30)--( user@system )-->  /tmp |-->  02:55:07 
 󱞩 podman logs ldap
***  INFO   | 2026-05-12 19:11:58 | CONTAINER_LOG_LEVEL = 3 (info)
***  INFO   | 2026-05-12 19:11:58 | Search service in CONTAINER_SERVICE_DIR = /container/service :
***  INFO   | 2026-05-12 19:11:58 | link /container/service/:ssl-tools/startup.sh to /container/run/startup/:ssl-tools
***  INFO   | 2026-05-12 19:11:58 | link /container/service/slapd/startup.sh to /container/run/startup/slapd
***  INFO   | 2026-05-12 19:11:58 | link /container/service/slapd/process.sh to /container/run/process/slapd/run
***  INFO   | 2026-05-12 19:11:58 | Environment files will be proccessed in this order : 
Caution: previously defined variables will not be overriden.
/container/environment/99-default/default.startup.yaml
/container/environment/99-default/default.yaml

To see how this files are processed and environment variables values,
run this container with '--loglevel debug'
***  INFO   | 2026-05-12 19:11:58 | Running /container/run/startup/:ssl-tools...
***  INFO   | 2026-05-12 19:11:58 | Running /container/run/startup/slapd...
***  INFO   | 2026-05-12 19:11:58 | openldap user and group adjustments
***  INFO   | 2026-05-12 19:11:58 | get current openldap uid/gid info inside container
***  INFO   | 2026-05-12 19:11:58 | -------------------------------------
***  INFO   | 2026-05-12 19:11:58 | openldap GID/UID
***  INFO   | 2026-05-12 19:11:58 | -------------------------------------
***  INFO   | 2026-05-12 19:11:58 | User uid: 911
***  INFO   | 2026-05-12 19:11:58 | User gid: 911
***  INFO   | 2026-05-12 19:11:58 | uid/gid changed: false
***  INFO   | 2026-05-12 19:11:58 | -------------------------------------
***  INFO   | 2026-05-12 19:11:58 | updating file uid/gid ownership
***  INFO   | 2026-05-12 19:11:58 | Database and config directory are empty...
***  INFO   | 2026-05-12 19:11:58 | Init new ldap server...
  Backing up /etc/ldap/slapd.d in /var/backups/slapd-2.4.57+dfsg-1~bpo10+1... done.
  Creating initial configuration... done.
  Creating LDAP directory... done.
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of restart.
***  INFO   | 2026-05-12 19:11:58 | Start OpenLDAP...
***  INFO   | 2026-05-12 19:11:58 | Waiting for OpenLDAP to start...
***  INFO   | 2026-05-12 19:11:58 | Add bootstrap schemas...
config file testing succeeded
***  INFO   | 2026-05-12 19:11:59 | Add image bootstrap ldif...
***  INFO   | 2026-05-12 19:11:59 | Add custom bootstrap ldif...
***  INFO   | 2026-05-12 19:11:59 | Add TLS config...
***  INFO   | 2026-05-12 19:11:59 | No certificate file and certificate key provided, generate:
***  INFO   | 2026-05-12 19:11:59 | /container/service/slapd/assets/certs/ldap.crt and /container/service/slapd/assets/certs/ldap.key
2026/05/12 19:11:59 [INFO] generate received request
2026/05/12 19:11:59 [INFO] received CSR
2026/05/12 19:11:59 [INFO] generating key: ecdsa-384
2026/05/12 19:11:59 [INFO] encoded CSR
2026/05/12 19:11:59 [INFO] signed certificate with serial number 726843971258162583521439516723172405222706519050
***  INFO   | 2026-05-12 19:11:59 | Link /container/service/:ssl-tools/assets/default-ca/default-ca.pem to /container/service/slapd/assets/certs/ca.crt
***  INFO   | 2026-05-12 19:11:59 | Add enforce TLS...
***  INFO   | 2026-05-12 19:11:59 | Disable replication config...
***  INFO   | 2026-05-12 19:11:59 | Stop OpenLDAP...
***  INFO   | 2026-05-12 19:11:59 | Configure ldap client TLS configuration...
***  INFO   | 2026-05-12 19:11:59 | Remove config files...
***  INFO   | 2026-05-12 19:11:59 | First start is done...
***  INFO   | 2026-05-12 19:11:59 | Remove file /container/environment/99-default/default.startup.yaml
***  INFO   | 2026-05-12 19:11:59 | Environment files will be proccessed in this order : 
Caution: previously defined variables will not be overriden.
/container/environment/99-default/default.yaml

To see how this files are processed and environment variables values,
run this container with '--loglevel debug'
***  INFO   | 2026-05-12 19:11:59 | Running /container/run/process/slapd/run...
6a037b7f @(#) $OpenLDAP: slapd 2.4.57+dfsg-1~bpo10+1 (Jan 30 2021 06:59:51) $
	Debian OpenLDAP Maintainers <pkg-openldap-devel@lists.alioth.debian.org>
6a037b7f slapd starting
6a037b86 conn=1000 fd=12 ACCEPT from IP=127.0.0.1:33742 (IP=0.0.0.0:636)
TLS: can't accept: (unknown error code).
6a037b86 conn=1000 fd=12 closed (TLS negotiation failure)
6a037bb1 conn=1001 fd=12 ACCEPT from PATH=/var/run/slapd/ldapi (PATH=/var/run/slapd/ldapi)
6a037bb1 conn=1001 op=0 BIND dn="" method=163
6a037bb1 conn=1001 op=0 BIND authcid="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" authzid="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth"
6a037bb1 conn=1001 op=0 BIND dn="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" mech=EXTERNAL sasl_ssf=0 ssf=128
6a037bb1 conn=1001 op=0 RESULT tag=97 err=0 text=
6a037bb1 conn=1001 op=1 ADD dn="ou=people,dc=office,dc=local"
6a037bb1 conn=1001 op=1 RESULT tag=105 err=0 text=
6a037bb1 conn=1001 op=2 UNBIND
6a037bb1 conn=1001 fd=12 closed
6a037c03 conn=1002 fd=12 ACCEPT from PATH=/var/run/slapd/ldapi (PATH=/var/run/slapd/ldapi)
6a037c03 conn=1002 op=0 BIND dn="" method=163
6a037c03 conn=1002 op=0 BIND authcid="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" authzid="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth"
6a037c03 conn=1002 op=0 BIND dn="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" mech=EXTERNAL sasl_ssf=0 ssf=128
6a037c03 conn=1002 op=0 RESULT tag=97 err=0 text=
6a037c03 conn=1002 op=1 ADD dn="uid=ikhsan,ou=people,dc=office,dc=local"
6a037c03 conn=1002 op=1 RESULT tag=105 err=0 text=
6a037c03 conn=1002 op=2 UNBIND
6a037c03 conn=1002 fd=12 closed
6a037c54 conn=1003 fd=12 ACCEPT from IP=10.88.0.4:46218 (IP=0.0.0.0:389)
6a037c54 conn=1003 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037c54 conn=1003 op=0 STARTTLS
6a037c54 conn=1003 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037c54 conn=1003 fd=12 closed (TLS negotiation failure)
6a037c55 conn=1004 fd=12 ACCEPT from IP=10.88.0.4:46230 (IP=0.0.0.0:389)
6a037c55 conn=1004 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037c55 conn=1004 op=0 STARTTLS
6a037c55 conn=1004 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037c55 conn=1004 fd=12 closed (TLS negotiation failure)
6a037c57 conn=1005 fd=12 ACCEPT from IP=10.88.0.4:46234 (IP=0.0.0.0:389)
6a037c57 conn=1005 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037c57 conn=1005 op=0 STARTTLS
6a037c57 conn=1005 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037c57 conn=1005 fd=12 closed (TLS negotiation failure)
6a037c5b conn=1006 fd=12 ACCEPT from IP=10.88.0.4:54012 (IP=0.0.0.0:389)
6a037c5b conn=1006 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037c5b conn=1006 op=0 STARTTLS
6a037c5b conn=1006 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037c5b conn=1006 fd=12 closed (TLS negotiation failure)
6a037c9a conn=1007 fd=12 ACCEPT from IP=10.88.0.4:47470 (IP=0.0.0.0:389)
6a037c9a conn=1007 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037c9a conn=1007 op=0 STARTTLS
6a037c9a conn=1007 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037c9a conn=1007 fd=12 closed (TLS negotiation failure)
6a037c9c conn=1008 fd=12 ACCEPT from IP=10.88.0.4:47472 (IP=0.0.0.0:389)
6a037c9c conn=1008 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037c9c conn=1008 op=0 STARTTLS
6a037c9c conn=1008 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037c9c conn=1008 fd=12 closed (TLS negotiation failure)
6a037ca1 conn=1009 fd=12 ACCEPT from IP=10.88.0.4:43440 (IP=0.0.0.0:389)
6a037ca1 conn=1009 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037ca1 conn=1009 op=0 STARTTLS
6a037ca1 conn=1009 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037ca1 conn=1009 fd=12 closed (TLS negotiation failure)
6a037d02 conn=1010 fd=12 ACCEPT from IP=10.88.0.4:51674 (IP=0.0.0.0:389)
6a037d02 conn=1010 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037d02 conn=1010 op=0 STARTTLS
6a037d02 conn=1010 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037d02 conn=1010 fd=12 closed (TLS negotiation failure)
6a037d03 conn=1011 fd=12 ACCEPT from IP=10.88.0.4:44148 (IP=0.0.0.0:389)
6a037d03 conn=1011 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037d03 conn=1011 op=0 STARTTLS
6a037d03 conn=1011 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037d03 conn=1011 fd=12 closed (TLS negotiation failure)
6a037d06 conn=1012 fd=12 ACCEPT from IP=10.88.0.4:44154 (IP=0.0.0.0:389)
6a037d06 conn=1012 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037d06 conn=1012 op=0 STARTTLS
6a037d06 conn=1012 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037d06 conn=1012 fd=12 closed (TLS negotiation failure)
6a037d0a conn=1013 fd=12 ACCEPT from IP=10.88.0.4:44168 (IP=0.0.0.0:389)
6a037d0a conn=1013 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037d0a conn=1013 op=0 STARTTLS
6a037d0a conn=1013 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037d0a conn=1013 fd=12 closed (TLS negotiation failure)
6a037d58 conn=1014 fd=12 ACCEPT from IP=10.88.0.4:51678 (IP=0.0.0.0:389)
6a037d58 conn=1014 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037d58 conn=1014 op=0 STARTTLS
6a037d58 conn=1014 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037d58 conn=1014 fd=12 closed (TLS negotiation failure)
6a037d5b conn=1015 fd=12 ACCEPT from IP=10.88.0.4:51682 (IP=0.0.0.0:389)
6a037d5b conn=1015 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037d5b conn=1015 op=0 STARTTLS
6a037d5b conn=1015 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037d5b conn=1015 fd=12 closed (TLS negotiation failure)
6a037d5f conn=1016 fd=12 ACCEPT from IP=10.88.0.4:36198 (IP=0.0.0.0:389)
6a037d5f conn=1016 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037d5f conn=1016 op=0 STARTTLS
6a037d5f conn=1016 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037d5f conn=1016 fd=12 closed (TLS negotiation failure)
6a037dde conn=1017 fd=12 ACCEPT from IP=10.88.0.4:55176 (IP=0.0.0.0:389)
6a037dde conn=1017 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037dde conn=1017 op=0 STARTTLS
6a037dde conn=1017 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037dde conn=1017 fd=12 closed (TLS negotiation failure)
6a037de0 conn=1018 fd=12 ACCEPT from IP=10.88.0.4:42012 (IP=0.0.0.0:389)
6a037de0 conn=1018 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037de0 conn=1018 op=0 STARTTLS
6a037de0 conn=1018 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037de0 conn=1018 fd=12 closed (TLS negotiation failure)
6a037de4 conn=1019 fd=12 ACCEPT from IP=10.88.0.4:42024 (IP=0.0.0.0:389)
6a037de4 conn=1019 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037de4 conn=1019 op=0 STARTTLS
6a037de4 conn=1019 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037de4 conn=1019 fd=12 closed (TLS negotiation failure)
6a037ee4 conn=1020 fd=12 ACCEPT from IP=10.88.0.4:35004 (IP=0.0.0.0:389)
6a037ee4 conn=1020 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037ee4 conn=1020 op=0 STARTTLS
6a037ee4 conn=1020 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037ee4 conn=1020 fd=12 closed (TLS negotiation failure)
6a037ee6 conn=1021 fd=12 ACCEPT from IP=10.88.0.4:35006 (IP=0.0.0.0:389)
6a037ee6 conn=1021 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037ee6 conn=1021 op=0 STARTTLS
6a037ee6 conn=1021 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037ee6 conn=1021 fd=12 closed (TLS negotiation failure)
6a037eea conn=1022 fd=12 ACCEPT from IP=10.88.0.4:35010 (IP=0.0.0.0:389)
6a037eea conn=1022 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a037eea conn=1022 op=0 STARTTLS
6a037eea conn=1022 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a037eea conn=1022 fd=12 closed (TLS negotiation failure)
6a0380d5 conn=1023 fd=12 ACCEPT from IP=10.88.0.4:39804 (IP=0.0.0.0:389)
6a0380d5 conn=1023 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a0380d5 conn=1023 op=0 STARTTLS
6a0380d5 conn=1023 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a0380d5 conn=1023 fd=12 closed (TLS negotiation failure)
6a0380d7 conn=1024 fd=12 ACCEPT from IP=10.88.0.4:59564 (IP=0.0.0.0:389)
6a0380d7 conn=1024 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a0380d7 conn=1024 op=0 STARTTLS
6a0380d7 conn=1024 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a0380d7 conn=1024 fd=12 closed (TLS negotiation failure)
6a0380db conn=1025 fd=12 ACCEPT from IP=10.88.0.4:59572 (IP=0.0.0.0:389)
6a0380db conn=1025 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a0380db conn=1025 op=0 STARTTLS
6a0380db conn=1025 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a0380db conn=1025 fd=12 closed (TLS negotiation failure)
6a0384a2 conn=1026 fd=12 ACCEPT from IP=10.88.0.4:43312 (IP=0.0.0.0:389)
6a0384a2 conn=1026 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a0384a2 conn=1026 op=0 STARTTLS
6a0384a2 conn=1026 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a0384a2 conn=1026 fd=12 closed (TLS negotiation failure)
6a0384a4 conn=1027 fd=12 ACCEPT from IP=10.88.0.4:43326 (IP=0.0.0.0:389)
6a0384a4 conn=1027 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a0384a4 conn=1027 op=0 STARTTLS
6a0384a4 conn=1027 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a0384a5 conn=1027 fd=12 closed (TLS negotiation failure)
6a0384a9 conn=1028 fd=12 ACCEPT from IP=10.88.0.4:43334 (IP=0.0.0.0:389)
6a0384a9 conn=1028 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a0384a9 conn=1028 op=0 STARTTLS
6a0384a9 conn=1028 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a0384a9 conn=1028 fd=12 closed (TLS negotiation failure)
6a03860e conn=1029 fd=12 ACCEPT from IP=10.88.0.4:39918 (IP=0.0.0.0:389)
6a03860e conn=1029 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a03860e conn=1029 op=0 STARTTLS
6a03860e conn=1029 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a03860e conn=1029 fd=12 closed (TLS negotiation failure)
6a03860f conn=1030 fd=12 ACCEPT from IP=10.88.0.4:39932 (IP=0.0.0.0:389)
6a03860f conn=1030 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a03860f conn=1030 op=0 STARTTLS
6a03860f conn=1030 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a03860f conn=1030 fd=12 closed (TLS negotiation failure)
6a038611 conn=1031 fd=12 ACCEPT from IP=10.88.0.4:39944 (IP=0.0.0.0:389)
6a038611 conn=1031 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a038611 conn=1031 op=0 STARTTLS
6a038611 conn=1031 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a038611 conn=1031 fd=12 closed (TLS negotiation failure)
6a038615 conn=1032 fd=12 ACCEPT from IP=10.88.0.4:52658 (IP=0.0.0.0:389)
6a038615 conn=1032 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a038615 conn=1032 op=0 STARTTLS
6a038615 conn=1032 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a038615 conn=1032 fd=12 closed (TLS negotiation failure)
6a038661 conn=1033 fd=12 ACCEPT from IP=10.88.0.4:56410 (IP=0.0.0.0:389)
6a038661 conn=1033 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a038661 conn=1033 op=0 STARTTLS
6a038661 conn=1033 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a038661 conn=1033 fd=12 closed (TLS negotiation failure)
6a038663 conn=1034 fd=12 ACCEPT from IP=10.88.0.4:55508 (IP=0.0.0.0:389)
6a038663 conn=1034 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a038663 conn=1034 op=0 STARTTLS
6a038663 conn=1034 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a038663 conn=1034 fd=12 closed (TLS negotiation failure)
6a038667 conn=1035 fd=12 ACCEPT from IP=10.88.0.4:55518 (IP=0.0.0.0:389)
6a038667 conn=1035 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a038667 conn=1035 op=0 STARTTLS
6a038667 conn=1035 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a038667 conn=1035 fd=12 closed (TLS negotiation failure)
6a0386ab conn=1036 fd=12 ACCEPT from IP=10.88.0.4:55050 (IP=0.0.0.0:389)
6a0386ab conn=1036 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a0386ab conn=1036 op=0 STARTTLS
6a0386ab conn=1036 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a0386ab conn=1036 fd=12 closed (TLS negotiation failure)
6a0386ac conn=1037 fd=12 ACCEPT from IP=10.88.0.4:55060 (IP=0.0.0.0:389)
6a0386ac conn=1037 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a0386ac conn=1037 op=0 STARTTLS
6a0386ac conn=1037 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a0386ac conn=1037 fd=12 closed (TLS negotiation failure)
6a0386ae conn=1038 fd=12 ACCEPT from IP=10.88.0.4:55066 (IP=0.0.0.0:389)
6a0386ae conn=1038 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a0386ae conn=1038 op=0 STARTTLS
6a0386ae conn=1038 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a0386af conn=1038 fd=12 closed (TLS negotiation failure)
6a0386b3 conn=1039 fd=12 ACCEPT from IP=10.88.0.4:55070 (IP=0.0.0.0:389)
6a0386b3 conn=1039 op=0 EXT oid=1.3.6.1.4.1.1466.20037
6a0386b3 conn=1039 op=0 STARTTLS
6a0386b3 conn=1039 op=0 RESULT oid= err=0 text=
TLS: can't accept: No certificate was found..
6a0386b3 conn=1039 fd=12 closed (TLS negotiation failure)

 --(31)--( user@system )-->  /tmp |-->  02:59:51 
 󱞩 cat ka
cat: ka: No such file or directory

 --(32)--( user@system )-->  /tmp |-->  03:11:23 
 󱞩 cd ~

 --(33)--( user@system )-->  /home/sultan |-->  03:11:29 
 󱞩 cat karyawan.ldif 
dn: uid=ikhsan,ou=people,dc=office,dc=local
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: ikhsan
uid: ikhsan
uidNumber: 10001
gidNumber: 10001
homeDirectory: /home/ikhsan
loginShell: /usr/bin/bash
userPassword: {SSHA}JEMKkKEumeFIhjtz2uHK+3/casvxvgQz 
shadowLastChange: 0
shadowMax: 365
shadowWarning: 7

 --(34)--( user@system )-->  /home/sultan |-->  03:11:32 
 󱞩 ^C

 --(34)--( user@system )-->  /home/sultan |-->  03:16:24 
 󱞩 podman stop ldap
ldap

 --(35)--( user@system )-->  /home/sultan |-->  03:16:33 
 󱞩 podman rm ldap
ldap

 --(36)--( user@system )-->  /home/sultan |-->  03:16:37 
 󱞩 podman volume rm ldap-data ldap-config
ldap-data
ldap-config

 --(37)--( user@system )-->  /home/sultan |-->  03:16:44 
 󱞩 podman run -d \podman run -d \
 --name ldap \
 --network podman \
 -p 0.0.0.0:1389:389 \
 -p 0.0.0.0:1636:636 \
 -v ldap-data:/var/lib/ldap:Z \
 -v ldap-config:/etc/ldap/slapd.d:Z \
 -e LDAP_ORGANISATION="yuros" \
 -e LDAP_DOMAIN="office.local" \
 -e LDAP_ADMIN_PASSWORD="1511" \
 -e LDAP_TLS="true" \
 -e LDAP_TLS_ENFORCE="true" \
 --restart always \
 osixia/openldap:latest
435b1621fa19d68edb72d9bdf08d8ad4af4b56b59deb0a6c60ae677ffe6c30fa

 --(38)--( user@system )-->  /home/sultan |-->  03:18:04 
 󱞩 podman exec -i podman exec -i ldap ldapadd -Y EXTERNAL -H ldapi:/// < base.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "ou=people,dc=office,dc=local"


 --(39)--( user@system )-->  /home/sultan |-->  03:18:14 
 󱞩 podman exec -itpodman exec -it ldap slappasswd
New password: 
Re-enter new password: 
{SSHA}VfVivcbPtoAT76nAQ+D1OfGglACJM6t4

 --(40)--( user@system )-->  /home/sultan |-->  03:18:31 
 󱞩 nvim karyawan.ldif 

 --(41)--( user@system )-->  /home/sultan |-->  03:19:01 
 󱞩 nvim karyawan.ldif 

 --(42)--( user@system )-->  /home/sultan |-->  03:19:15 
 󱞩 podman exec -i podman exec -i ldap ldapadd -Y EXTERNAL -H ldapi:/// < karyawan.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "uid=ikhsan,ou=people,dc=office,dc=local"


 --(43)--( user@system )-->  /home/sultan |-->  03:19:36 
 󱞩 podman cp ldap:podman cp ldap:/container/service/slapd/assets/certs/ca.crt /tmp/ca.crt

 --(44)--( user@system )-->  /home/sultan |-->  03:19:44 
 󱞩 cd /tmp/

 --(45)--( user@system )-->  /tmp |-->  03:19:47 
 󱞩 ls
69e1204e-5f22-4900-93d7-092717bad3d7.zip
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-10171
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-10179
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-1969
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-1988
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-2440
HByt5dqXy_-TiXIWjzY3B2tU-TD-webview-2450
bd9ccae75ce72a4ddb4260b3c0743e13-{87A94AB0-E370-4cde-98D3-ACC110C5967D}
ca.crt
nvim.root
systemd-private-14962ccda51e487bb4bffea8a111b500-iwd.service-ii40Oh
systemd-private-14962ccda51e487bb4bffea8a111b500-polkit.service-KbISK8
systemd-private-14962ccda51e487bb4bffea8a111b500-systemd-logind.service-xs5DkM
systemd-private-14962ccda51e487bb4bffea8a111b500-upower.service-7xmlwF
user@172.26.1.16

 --(46)--( user@system )-->  /tmp |-->  03:19:49 
 󱞩 cat ca.crt 
-----BEGIN CERTIFICATE-----
MIICrjCCAjWgAwIBAgIUcun3KuyYiVryQCfOcWz7gNP0x/AwCgYIKoZIzj0EAwMw
gZYxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgTWV4aWNvMRQwEgYDVQQHEwtB
bGJ1cXVlcnF1ZTEVMBMGA1UEChMMQTFBIENhciBXYXNoMSQwIgYDVQQLExtJbmZv
cm1hdGlvbiBUZWNobm9sb2d5IERlcC4xHzAdBgNVBAMTFmRvY2tlci1saWdodC1i
YXNlaW1hZ2UwHhcNMjEwMTE2MTE0MjAwWhcNMjYwMTE1MTE0MjAwWjCBljELMAkG
A1UEBhMCVVMxEzARBgNVBAgTCk5ldyBNZXhpY28xFDASBgNVBAcTC0FsYnVxdWVy
cXVlMRUwEwYDVQQKEwxBMUEgQ2FyIFdhc2gxJDAiBgNVBAsTG0luZm9ybWF0aW9u
IFRlY2hub2xvZ3kgRGVwLjEfMB0GA1UEAxMWZG9ja2VyLWxpZ2h0LWJhc2VpbWFn
ZTB2MBAGByqGSM49AgEGBSuBBAAiA2IABNa9OyYrVwTPLjvXW2/mhFFMmQAZSFiy
go9hXqnwz/NDy0ZuQKsUFzSed6UXNu1eQgMHTSuwWi2TdbgSX8paz+w2QGzm2QWh
QFkcA96pzTUzjQanDvuqgVUhTWsmI04U2aNCMEAwDgYDVR0PAQH/BAQDAgEGMA8G
A1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFNcSeGQ+1u3nsr2BcYY2jVecyBQlMAoG
CCqGSM49BAMDA2cAMGQCMBHppmoY8E2fv0PIg8lR3Xq4bKNTH7cG3WEbR10NHPeJ
NHtBrXWsnjAouXKFGS+1vgIwAVP1gZCPOTvChfTF8uOHW7RZ3UnC3xcJlGaOrC7s
uElSBnLT7DIT3uBSxmIegHNH
-----END CERTIFICATE-----

 --(47)--( user@system )-->  /tmp |-->  03:19:55 
 󱞩 scp ca.crt user@172.26.1.16:/home/mirja
user@172.26.1.16's password: 
ca.crt                                                     100%  989     4.6KB/s   00:00    

 --(48)--( user@system )-->  /tmp |-->  03:20:19 
 󱞩 uname -a
Linux system 6.18.29-1-lts #1 SMP PREEMPT_DYNAMIC Mon, 11 May 2026 07:46:10 +0000 x86_64 GNU/Linux

 --(49)--( user@system )-->  /tmp |-->  13:09:54 
 󱞩 sudo pacman -Sysudo pacman -Syu sssd openldap
[sudo] password for user: 
Sorry, try again.
[sudo] password for user: 
:: Synchronizing package databases...
 core is up to date
 extra                        8.2 MiB  4.35 MiB/s 00:02 [##############################] 100%
:: Starting full system upgrade...
resolving dependencies...
looking for conflicting packages...

Package (20)             New Version  Net Change  Download Size

extra/bind               9.20.22-1      7.00 MiB       2.07 MiB
extra/c-ares             1.34.6-1       0.51 MiB       0.22 MiB
extra/cifs-utils         7.5-1          0.28 MiB       0.10 MiB
extra/cyrus-sasl-gssapi  2.1.28-4       0.08 MiB       0.03 MiB
core/ding-libs           0.7.0-1        0.28 MiB       0.07 MiB
core/dnssec-anchors      20250524-1     0.00 MiB       0.00 MiB
extra/jemalloc           1:5.3.1-2      1.26 MiB       0.36 MiB
extra/jose               14-1           0.30 MiB       0.12 MiB
extra/ldb                2:4.24.1-1     2.14 MiB       0.45 MiB
extra/libcbor            0.14.0-1       0.18 MiB       0.05 MiB
extra/libfido2           1.17.0-1       0.47 MiB       0.19 MiB
extra/libmaxminddb       1.13.3-1       0.04 MiB       0.02 MiB
extra/libwbclient        2:4.24.1-1     0.12 MiB       0.04 MiB
core/nfsidmap            2.9.1-1        0.17 MiB       0.05 MiB
extra/smbclient          2:4.24.1-1    28.42 MiB       7.08 MiB
extra/talloc             2.4.4-1        0.17 MiB       0.05 MiB
extra/tevent             1:0.17.1-2     0.21 MiB       0.06 MiB
core/unixodbc            2.3.14-1       0.86 MiB       0.25 MiB
core/openldap            2.6.13-1       4.67 MiB       1.54 MiB
extra/sssd               2.13.0-1       9.51 MiB       2.69 MiB

Total Download Size:   15.44 MiB
Total Installed Size:  56.69 MiB

:: Proceed with installation? [Y/n] 
:: Retrieving packages...
 ldb-2:4.24.1-1-x86_64      463.3 KiB  1620 KiB/s 00:00 [##############################] 100%
 openldap-2.6.13-1-x86_64  1578.6 KiB  2.64 MiB/s 00:01 [##############################] 100%
 jemalloc-1:5.3.1-2-x86_64  371.5 KiB  1548 KiB/s 00:00 [##############################] 100%
 c-ares-1.34.6-1-x86_64     227.3 KiB  1578 KiB/s 00:00 [##############################] 100%
 bind-9.20.22-1-x86_64        2.1 MiB  2.54 MiB/s 00:01 [##############################] 100%
 unixodbc-2.3.14-1-x86_64   257.6 KiB   930 KiB/s 00:00 [##############################] 100%
 libfido2-1.17.0-1-x86_64   197.2 KiB  1409 KiB/s 00:00 [##############################] 100%
 jose-14-1-x86_64           122.6 KiB  1319 KiB/s 00:00 [##############################] 100%
 cifs-utils-7.5-1-x86_64     98.7 KiB  1473 KiB/s 00:00 [##############################] 100%
 tevent-1:0.17.1-2-x86_64    58.2 KiB   832 KiB/s 00:00 [##############################] 100%
 libcbor-0.14.0-1-x86_64     49.1 KiB   702 KiB/s 00:00 [##############################] 100%
 sssd-2.13.0-1-x86_64         2.7 MiB  2.16 MiB/s 00:01 [##############################] 100%
 ding-libs-0.7.0-1-x86_64    73.8 KiB   331 KiB/s 00:00 [##############################] 100%
 talloc-2.4.4-1-x86_64       48.6 KiB   853 KiB/s 00:00 [##############################] 100%
 libwbclient-2:4.24.1-...    36.6 KiB   733 KiB/s 00:00 [##############################] 100%
 cyrus-sasl-gssapi-2.1...    25.7 KiB   547 KiB/s 00:00 [##############################] 100%
 libmaxminddb-1.13.3-1...    24.5 KiB   408 KiB/s 00:00 [##############################] 100%
 smbclient-2:4.24.1-1-...     7.1 MiB  4.83 MiB/s 00:01 [##############################] 100%
 nfsidmap-2.9.1-1-x86_64     46.4 KiB   252 KiB/s 00:00 [##############################] 100%
 dnssec-anchors-202505...     3.2 KiB  16.7 KiB/s 00:00 [##############################] 100%
 Total (20/20)               15.4 MiB  8.50 MiB/s 00:02 [##############################] 100%
(20/20) checking keys in keyring                        [##############################] 100%
(20/20) checking package integrity                      [##############################] 100%
(20/20) loading package files                           [##############################] 100%
(20/20) checking for file conflicts                     [##############################] 100%
(20/20) checking available disk space                   [##############################] 100%
:: Processing package changes...
( 1/20) installing dnssec-anchors                       [##############################] 100%
( 2/20) installing libmaxminddb                         [##############################] 100%
Optional dependencies for libmaxminddb
    geoip2-database: IP geolocation databases
( 3/20) installing jemalloc                             [##############################] 100%
Optional dependencies for jemalloc
    perl: for jeprof [installed]
( 4/20) installing bind                                 [##############################] 100%
( 5/20) installing c-ares                               [##############################] 100%
( 6/20) installing cyrus-sasl-gssapi                    [##############################] 100%
( 7/20) installing ding-libs                            [##############################] 100%
( 8/20) installing libwbclient                          [##############################] 100%
Optional dependencies for libwbclient
    python-dnspython: samba_dnsupdate and samba_upgradedns in AD setup
    python-markdown: for samba-tool domain schemeupgrade
    glusterfs: for vfs_glusterfs support
( 9/20) installing talloc                               [##############################] 100%
Optional dependencies for talloc
    python: for python bindings [installed]
(10/20) installing cifs-utils                           [##############################] 100%
Optional dependencies for cifs-utils
    python: for smb2-quota and smbinfo script [installed]
(11/20) installing tevent                               [##############################] 100%
Optional dependencies for tevent
    python: for python bindings [installed]
(12/20) installing ldb                                  [##############################] 100%
Optional dependencies for ldb
    python: for python bindings [installed]
(13/20) installing smbclient                            [##############################] 100%
Optional dependencies for smbclient
    python-dnspython: samba_dnsupdate and samba_upgradedns in AD setup
    python-markdown: for samba-tool domain schemeupgrade
    glusterfs: for vfs_glusterfs support
(14/20) installing nfsidmap                             [##############################] 100%
(15/20) installing jose                                 [##############################] 100%
(16/20) installing libcbor                              [##############################] 100%
(17/20) installing libfido2                             [##############################] 100%
(18/20) installing sssd                                 [##############################] 100%
Creating group 'sssd' with GID 965.
Creating user 'sssd' (User for sssd) with UID 965 and GID 965.
(19/20) installing unixodbc                             [##############################] 100%
(20/20) installing openldap                             [##############################] 100%
:: Running post-transaction hooks...
(1/5) Creating system user accounts...
Creating group 'named' with GID 40.
Creating user 'named' (BIND DNS Server) with UID 40 and GID 40.
Creating group 'ldap' with GID 439.
Creating user 'ldap' (LDAP Server) with UID 439 and GID 439.
(2/5) Creating temporary files...
(3/5) Reloading system manager configuration...
(4/5) Arming ConditionNeedsUpdate...
(5/5) Reloading system bus configuration...

 --(50)--( user@system )-->  /tmp |-->  13:10:34 
 󱞩 sudo su
[root@system tmp]# exit
exit

 --(51)--( user@system )-->  /tmp |-->  13:11:21 
 󱞩 cd ~

 --(52)--( user@system )-->  /home/sultan |-->  13:11:23 
 󱞩 ls
base.ldif  engine  karyawan.ldif  pooler  project

 --(53)--( user@system )-->  /home/sultan |-->  13:11:23 
 󱞩 cat karyawan.ldif 
dn: uid=ikhsan,ou=people,dc=office,dc=local
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: ikhsan
uid: ikhsan
uidNumber: 10001
gidNumber: 10001
homeDirectory: /home/ikhsan
loginShell: /usr/bin/bash
userPassword: {SSHA}VfVivcbPtoAT76nAQ+D1OfGglACJM6t4 
shadowLastChange: 0
shadowMax: 365
shadowWarning: 7

 --(54)--( user@system )-->  /home/sultan |-->  13:20:38 
 󱞩 podman cp ldap:podman cp ldap:/container/service/slapd/assets/certs/ca.crt /tmp/ca.crt

 --(55)--( user@system )-->  /home/sultan |-->  13:25:27 
 󱞩 sudo mkdir -p /sudo mkdir -p /etc/sssd/pki
[sudo] password for user: 

 --(56)--( user@system )-->  /home/sultan |-->  13:25:43 
 󱞩 sudo cp ~/ca.crsudo cp ~/ca.crt /etc/sssd/pki/sssd_ca.crt
cp: cannot stat '/home/sultan//ca.crt': No such file or directory

 --(57)--( user@system )-->  /home/sultan |-->  13:25:47 
 󱞩 sudo cp /tmp/ca.crt /etc/sssd/pki/sssd_ca.crt

 --(58)--( user@system )-->  /home/sultan |-->  13:26:07 
 󱞩 sudo chown rootsudo chown root:sssd /etc/sssd/pki/sssd_ca.crt

 --(59)--( user@system )-->  /home/sultan |-->  13:26:13 
 󱞩 sudo chmod 640 sudo chmod 640 /etc/sssd/pki/sssd_ca.crt

 --(60)--( user@system )-->  /home/sultan |-->  13:26:16 
 󱞩 podman stop ldap
ldap

 --(61)--( user@system )-->  /home/sultan |-->  13:36:31 
 󱞩 podman rm ldap
ldap

 --(62)--( user@system )-->  /home/sultan |-->  13:36:35 
 󱞩 podman volume rm ldap-data ldap-config
ldap-data
ldap-config

 --(63)--( user@system )-->  /home/sultan |-->  13:36:43 
 󱞩 podman ps
CONTAINER ID  IMAGE       COMMAND     CREATED     STATUS      PORTS       NAMES

 --(64)--( user@system )-->  /home/sultan |-->  13:36:45 
 󱞩 podman ps -a
CONTAINER ID  IMAGE       COMMAND     CREATED     STATUS      PORTS       NAMES

 --(65)--( user@system )-->  /home/sultan |-->  13:36:50 
 󱞩 podman run -d \podman run -d \
--name openldap \
-p 1389:389 \
-p 1636:636 \
-e LDAP_ORGANISATION="Lab Local" \
-e LDAP_DOMAIN="lab.local" \
-e LDAP_ADMIN_PASSWORD="SuperPassword123" \
-v ~/ldap/data:/var/lib/ldap:Z \
-v ~/ldap/config:/etc/ldap/slapd.d:Z \
docker.io/osixia/openldap:1.5.0
Error: statfs /home/sultan/ldap/config: no such file or directory

 --(66)--( user@system )-->  /home/sultan |-->  13:42:12 
 󱞩 mkdir -p ~/ldap/data ~/ldap/config

 --(67)--( user@system )-->  /home/sultan |-->  13:42:35 
 󱞩 mkdir -p ~/ldappodman run -d --name openldap -p 1389:389 -p 1636:636 -e LDAP_ORGANISATION="Lab Local" -e LDAP_DOMAIN="lab.local" -e LDAP_ADMIN_PASSWORD="SuperPassword123" -v ~/ldap/data:/var/lib/ldap:Z -v ~/ldap/config:/etc/ldap/slapd.d:Z docker.io/osixia/openldap:1.5.0
e4aa2716243cd56a5a392032aa5c477f6e3984fbf86cc0c82a99b0872df81543

 --(68)--( user@system )-->  /home/sultan |-->  13:42:37 
 󱞩 ldapsearch -x \ldapsearch -x \
-H ldap://127.0.0.1:1389 \
-b dc=lab,dc=local
# extended LDIF
#
# LDAPv3
# base <dc=lab,dc=local> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# search result
search: 2
result: 32 No such object

# numResponses: 1

 --(69)--( user@system )-->  /home/sultan |-->  13:42:44 
 󱞩 nano base.ldif
bash: nano: command not found

 --(70)--( user@system )-->  /home/sultan |-->  13:42:55 
 󱞩 nvim base.ldif

 --(71)--( user@system )-->  /home/sultan |-->  13:43:08 
 󱞩 ldapadd -x \
-D "cn=admin,dc=lab,dc=local" \
-w SuperPassword123 \
-H ldap://127.0.0.1:1389 \
-f base.ldif
adding new entry "ou=people,dc=lab,dc=local"

adding new entry "ou=groups,dc=lab,dc=local"


 --(72)--( user@system )-->  /home/sultan |-->  13:43:15 
 󱞩 slappasswd
New password: 
Re-enter new password: 
{SSHA}rqYpzuXe6L8+IbyA7gSPhRgTDTJPFwyJ

 --(73)--( user@system )-->  /home/sultan |-->  13:43:32 
 󱞩 nvim user.ldi

 --(74)--( user@system )-->  /home/sultan |-->  13:43:46 
 󱞩 nvim user.ldi

 --(75)--( user@system )-->  /home/sultan |-->  13:44:03 
 󱞩 ldapadd -x \
-D "cn=admin,dc=lab,dc=local" \
-w SuperPassword123 \
-H ldap://127.0.0.1:1389 \
-f user.ldif
user.ldif: No such file or directory

 --(76)--( user@system )-->  /home/sultan |-->  13:44:09 
 󱞩 mv user.ldi user.ldif

 --(77)--( user@system )-->  /home/sultan |-->  13:44:30 
 󱞩 ldapadd -x \
-D "cn=admin,dc=lab,dc=local" \
-w SuperPassword123 \
-H ldap://127.0.0.1:1389 \
-f user.ldif
adding new entry "cn=users,ou=groups,dc=lab,dc=local"

adding new entry "uid=budi,ou=people,dc=lab,dc=local"


 --(78)--( user@system )-->  /home/sultan |-->  13:44:31 
 󱞩 ldapsearch -x \ldapsearch -x \
-H ldap://127.0.0.1:1389 \
-b dc=lab,dc=local "(uid=budi)"
# extended LDIF
#
# LDAPv3
# base <dc=lab,dc=local> with scope subtree
# filter: (uid=budi)
# requesting: ALL
#

# search result
search: 2
result: 32 No such object

# numResponses: 1

 --(79)--( user@system )-->  /home/sultan |-->  13:44:51 
 󱞩 ldapsearch -x \ldapsearch -x \
-D "cn=admin,dc=lab,dc=local" \
-w SuperPassword123 \
-H ldap://127.0.0.1:1389 \
-b dc=lab,dc=local
# extended LDIF
#
# LDAPv3
# base <dc=lab,dc=local> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# lab.local
dn: dc=lab,dc=local
objectClass: top
objectClass: dcObject
objectClass: organization
o: Lab Local
dc: lab

# people, lab.local
dn: ou=people,dc=lab,dc=local
objectClass: organizationalUnit
ou: people

# groups, lab.local
dn: ou=groups,dc=lab,dc=local
objectClass: organizationalUnit
ou: groups

# users, groups, lab.local
dn: cn=users,ou=groups,dc=lab,dc=local
objectClass: posixGroup
cn: users
gidNumber: 10000

# budi, people, lab.local
dn: uid=budi,ou=people,dc=lab,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
cn: Budi
sn: Budi
uid: budi
uidNumber: 10000
gidNumber: 10000
homeDirectory: /home/budi
loginShell: /bin/bash
userPassword:: e1NTSEF9cnFZcHp1WGU2TDgrSWJ5QTdnU1BoUmdURFRKUEZ3eUo=

# search result
search: 2
result: 0 Success

# numResponses: 6
# numEntries: 5

 --(80)--( user@system )-->  /home/sultan |-->  14:15:13 
 󱞩 ldapsearch -x \ldapsearch -x \
-D "cn=admin,dc=lab,dc=local" \
-w SuperPassword123 \
-H ldap://127.0.0.1:1389 \
-b dc=lab,dc=local
# extended LDIF
#
# LDAPv3
# base <dc=lab,dc=local> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# lab.local
dn: dc=lab,dc=local
objectClass: top
objectClass: dcObject
objectClass: organization
o: Lab Local
dc: lab

# people, lab.local
dn: ou=people,dc=lab,dc=local
objectClass: organizationalUnit
ou: people

# groups, lab.local
dn: ou=groups,dc=lab,dc=local
objectClass: organizationalUnit
ou: groups

# users, groups, lab.local
dn: cn=users,ou=groups,dc=lab,dc=local
objectClass: posixGroup
cn: users
gidNumber: 10000

# budi, people, lab.local
dn: uid=budi,ou=people,dc=lab,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
cn: Budi
sn: Budi
uid: budi
uidNumber: 10000
gidNumber: 10000
homeDirectory: /home/budi
loginShell: /bin/bash
userPassword:: e1NTSEF9cnFZcHp1WGU2TDgrSWJ5QTdnU1BoUmdURFRKUEZ3eUo=

# search result
search: 2
result: 0 Success

# numResponses: 6
# numEntries: 5

 --(81)--( user@system )-->  /home/sultan |-->  14:15:24 
 󱞩 ldapsearch -Y Eldapsearch -Y EXTERNAL -H ldapi:/// -b cn=schema,cn=config dn
ldap_sasl_interactive_bind: Can't contact LDAP server (-1)

 --(82)--( user@system )-->  /home/sultan |-->  14:18:22 
 󱞩 ssh budi@localhost
The authenticity of host 'localhost (127.0.0.1)' can't be established.
ED25519 key fingerprint is: SHA256:ZN1NlvexSye2THI8VTCd9uquV8N6lBXoMtnFHENtKDk
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'localhost' (ED25519) to the list of known hosts.
budi@localhost's password: 
Permission denied, please try again.
budi@localhost's password: 
Permission denied, please try again.
budi@localhost's password: 


 --(83)--( user@system )-->  /home/sultan |-->  14:45:51 
 󱞩 grep -i usepam grep -i usepam /etc/ssh/sshd_config
#UsePAM no

 --(84)--( user@system )-->  /home/sultan |-->  14:45:52 
 󱞩 sudo nvim /etc/sudo nano /etc/ssh/sshd_config
[sudo] password for user: 

 --(85)--( user@system )-->  /home/sultan |-->  14:46:35 
 󱞩 sudo nvim /etc/grep -i usepa_config
UsePAM yes

 --(86)--( user@system )-->  /home/sultan |-->  14:46:38 
 󱞩 sudo systemctl sudo systemctl restart sshd

 --(87)--( user@system )-->  /home/sultan |-->  14:46:43 
 󱞩 sudo systemctl ssh budi@localhost
budi@localhost's password: 
Permission denied, please try again.
budi@localhost's password: 


 --(88)--( user@system )-->  /home/sultan |-->  14:46:58 
 󱞩 grep sss /etc/pgrep sss /etc/pam.d/sshd

 --(89)--( user@system )-->  /home/sultan |-->  14:47:00 
 󱞩 sudo systemctl restart sshd

 --(90)--( user@system )-->  /home/sultan |-->  14:48:45 
 󱞩 ssh budi@localhost
budi@localhost's password: 
Permission denied, please try again.
budi@localhost's password: 


 --(91)--( user@system )-->  /home/sultan |-->  14:48:51 
 󱞩 ssh budi@localhost
budi@localhost's password: 
Permission denied, please try again.
budi@localhost's password: 


 --(92)--( user@system )-->  /home/sultan |-->  14:49:51 
 󱞩 ssh budi@localhost
budi@localhost's password: 
Permission denied, please try again.
budi@localhost's password: 


 --(93)--( user@system )-->  /home/sultan |-->  14:50:23 
 󱞩 ssh budi@localhost
budi@localhost's password: 
Permission denied, please try again.
budi@localhost's password: 
Permission denied, please try again.
budi@localhost's password: 


 --(94)--( user@system )-->  /home/sultan |-->  14:53:42 
 󱞩 ssh budi@localhost
budi@localhost's password: 
Permission denied, please try again.
budi@localhost's password: 
Permission denied, please try again.
budi@localhost's password:
```
