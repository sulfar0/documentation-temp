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
