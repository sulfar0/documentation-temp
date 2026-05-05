# 1. Partitioning

## physical volume

### disk layout
| disk | partition | type              | luks  | lvm   | label    | size      | format | mount                      |
| ---- | --------- | ----------------- | ----- | ----- | -------- | --------- | ------ | -------------------------- |
| 0    | 1         | efi                | false | false | boot     | 320M      | fat 32 | /boot                      |
| 0    | 2         | linux server data | true  | false | keys     | 512M      | luks   | none                       |
| 0    | 3         | linux file system  | true  | true  | proc     | 88166MiB  | luks   | see logical layout point 1 |
| 0    | 4         | linux server data | true  | true  | data     | 100% Free | luks   | see logical layout point 1 |

gunakan cfdisk untuk membuat physical volume sesuai dengan guide line

### disk encryption
```
cryptsetup luksFormat --sector-size=4096 /dev/nvme0n1p2
```

```
cryptsetup luksFormat --sector-size=4096 /dev/nvme0n1p3
```

```
cryptsetup luksFormat --sector-size=4096 /dev/nvme0n1p4
```

```
cryptsetup luksOpen /dev/nvme0n1p3 proc
```

```
cryptsetup luksOpen /dev/nvme0n1p4 data
```

## logical volume proc

### disk layout
| partition | list | group  | name | size  | mount                 | format |
| --------- | ---- | ------ | ---- | ----- | --------------------- | ------ |
| 2         | 1    | proc   | root | 10G   | /mnt                  | ext4   |
| 2         | 2    | proc   | vars | 10G   | /mnt/var              | ext4   |
| 2         | 3    | proc   | game | 2G    | /mnt/var/games/       | ext4   |
| 2         | 4    | proc   | vlog | 5G    | /mnt/var/log/         | ext4   |
| 2         | 5    | proc   | vaud | 1G    | /mnt/var/log/audit    | ext4   |
| 2         | 6    | proc   | vtmp | 2.5G  | /mnt/var/tmp/         | ext4   |
| 2         | 7    | proc   | vpac | 5G    | /mnt/var/cache/pacman | ext4   |
| 2         | 8    | proc   | home | 5G    | /mnt/home             | ext4   |
| 2         | 9    | proc   | swap | 4G    | swapon                | swap   |

```
pvcreate /dev/mapper/proc
```
```
vgcreate proc /dev/mapper/proc
```
```
pvcreate /dev/mapper/data
```
```
vgcreate data /dev/mapper/data
```
### root
```
lvcreate -L 10G proc -n root
```
```
mkfs.ext4 -b 4096 /dev/proc/root
```
```
mount /dev/proc/root /mnt
```

### boot
```
mkfs.vfat -F32 -S 4096 -n BOOT /dev/nvme0n1p1
```
```
mkdir /mnt/boot
```
```
mount -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/nvme0n1p1 /mnt/boot
```

### vars
```
lvcreate -L 10G proc -n vars
```
```
mkfs.ext4 -b 4096 /dev/proc/vars
```
```
mkdir /mnt/var
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vars /mnt/var
```

### game
```
lvcreate -L 2G proc -n game
```
```
mkfs.ext4 -b 4096 /dev/proc/game
```
```
mkdir /mnt/var/games
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/game /mnt/var/games
```

### vlog
```
lvcreate -L 5G proc -n vlog
```
```
mkfs.ext4 -b 4096 /dev/proc/vlog
```
```
mkdir /mnt/var/log
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vlog /mnt/var/log
```

### vaud
```
lvcreate -L 1G proc -n vaud
```
```
mkfs.ext4 -b 4096 /dev/proc/vaud
```
```
mkdir /mnt/var/log/audit
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vaud /mnt/var/log/audit
```
### vtmp
```
lvcreate -L 2.5G proc -n vtmp
```
```
mkfs.ext4 -b 4096 /dev/proc/vtmp
```
```
mkdir /mnt/var/tmp
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vtmp /mnt/var/tmp
```
### vpac
```
lvcreate -L 5G proc -n vpac
```
```
mkfs.ext4 -b 4096 /dev/proc/vpac
```
```
mkdir -p /mnt/var/cache /mnt/var/cache/pacman
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vpac /mnt/var/cache/pacman
```
### home
```
lvcreate -L 5G proc -n home
```
```
mkfs.ext4 -b 4096 /dev/proc/home
```
```
mkdir /mnt/home
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/home /mnt/home
```

### swap
```
lvcreate -L 4G proc -n swap
```
```
mkswap /dev/proc/swap
```
```
swapon /dev/proc/swap
```



# 2.installation


## intel server
```
pacstrap /mnt linux-hardened linux-hardened-headers linux-firmware-realtek linux-firmware-intel linux-firmware-other mkinitcpio intel-ucode tang clevis mkinitcpio-nfs-utils luksmeta libpwquality cracklib git base neovim lvm2 btrfs-progs openssh polkit ethtool iptables-nft firewalld apparmor rsync sudo debugedit fakeroot pkgconf bison gcc pcre flex wget make gcc curl nginx irqbalance tuned which sof-firmware --noconfirm
```
## amd server
```
pacstrap /mnt linux-hardened linux-firmware mkinitcpio amd-ucode tang clevis mkinitcpio-nfs-utils luksmeta libpwquality cracklib git base neovim lvm2 btrfs-progs openssh polkit ethtool iptables-nft firewalld apparmor rsync sudo debugedit fakeroot pkgconf bison gcc pcre flex wget make gcc curl irqbalance tuned which sof-firmware --noconfirm
```
```
mkdir -p /mnt/etc/backup
```
## network configuration
```
cp /etc/systemd/network/* /mnt/etc/systemd/network/
```

## generate partition layout
```
genfstab -U /mnt > /mnt/etc/fstab
```


# 3. chrooting


```
arch-chroot /mnt
```

## hostname

```
echo 'nama_hostname' > /etc/hostname
```


## local time

```
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
```

```
hwclock --systohc
```
```
mkdir /etc/systemd/timesyncd.conf.d
```
```
nvim /etc/systemd/timesyncd.conf.d/local.conf
```
```
[Time]
NTP=0.id.pool.ntp.org 1.id.pool.ntp.org 2.id.pool.ntp.org 3.id.pool.ntp.org
FallbackNTP=time.cloudflare.com time.google.com time.aws.com
```
```
timedatectl set-ntp true
```
```
timedatectl set-timezone Asia/Jakarta
```
```
timedatectl status
```
```
timedatectl show-timesync --all
```
```
systemctl enable systemd-timesyncd.service
```

### locale

```
nvim /etc/locale.gen
```
uncommenting
```
en_US.UTF-8 UTF-8
en_US ISO-8859-1
```
```
locale-gen && locale > /etc/locale.conf
```
```
sed -i '1s/.*/LANG=en_US.UTF-8/' /etc/locale.conf
```
```
cat /etc/locale.conf
```
```
touch /etc/vconsole.conf
```
```
nvim /etc/vconsole.conf
```
```
FONT=lat2-16
FONT_MAP=8859-2
```

### user
```
rm /etc/skel/.bash_profile
```
```
rm /etc/skel/.bashrc
```
```
rm /etc/skel/.bash_logout
```
> tambahkan http pada sudoers
```
nvim /etc/sudoers
```
```
chown -R http:http /srv/http
```
> lakukan perubahan /etc/passwd baru lakukan passwd
```
nvim /etc/passwd
```
```
http:x:33:33::/srv/http:/usr/bin/bash
```
```
passwd http
```
```
su http
```
```
sudo su
```

### firewelld

```
nvim /usr/lib/firewalld/zones/block.xml
```
```
nvim /usr/lib/firewalld/zones/external.xml
```
```
nvim /usr/lib/firewalld/zones/home.xml
```
```
nvim /usr/lib/firewalld/zones/internal.xml 
```
 
delete semua service 

```
nvim /usr/lib/firewalld/zones/public.xml 
```

sisakan
```
<service name="ssh"/>
```

## os release

```
echo '' > /usr/lib/os-release
```
```
nvim /usr/lib/os-release
```
```
NAME="Blackbird"
PRETTY_NAME="Blackbird"
ID=blackbird
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://blackbird.lektor.co.id/"
DOCUMENTATION_URL="https://blackbird.lektor.co.id/"
SUPPORT_URL="https://blackbird.lektor.co.id/support/"
BUG_REPORT_URL="https://gitlab.blackbird.org/groups/issues"
PRIVACY_POLICY_URL="https://blackbird.lektor.co.id/privacy-policy/"
LOGO=blackbird-logo
```

## package manager

```
nvim /etc/pacman.conf
```
```
SigLevel = Required DatabaseOptional TrustedOnly
```
uncomment
```
UseSysLog
Color
VerbosePkgLists
```

## apparmor 

```
systemctl enable apparmor.service
```

## sshd
```
systemctl enable ssh
```


## kernels harden

```
nvim /etc/sysctl.d/30-secs.conf
```

```/etc/sysctl.d/30-secs.conf
kernel.unprivileged_userns_clone=1
```

## loging config
```
mkdir -p /etc/systemd/journald.conf.d/
```
```
nvim /etc/systemd/journald.conf.d/01-default.conf
```
```
[Journal]
SystemMaxUse=1G
SystemKeepFree=500M
RuntimeMaxUse=200M
RuntimeKeepFree=50M
MaxFileSec=1month
Storage=persistent
```

## sleep config
```
mkdir -p /etc/systemd/sleep.conf.d/
```
```
nvim /etc/systemd/sleep.conf.d/01-blackbird.conf
```
```
[Sleep]
AllowSuspend=no
AllowHibernation=no
AllowHybridSleep=no
AllowSuspendThenHibernate=no
```

## coredump config
```
nvim /etc/systemd/coredump.conf
```
comment "[coredum]" dan tambah di akhir document
```
[Coredump]
Storage=none
ProcessSizeMax=0
```

## login sudoers
```
nvim /etc/sudo.conf
```
tambahkan pada bagian paling bawah
```
## Config Log
Defaults logfile="/var/log/sudo.log"
```
#### nginx
```
systemctl enable nginx
```
### network
```
nvim /etc/systemd/network/20-ethernet.network
```
```
[Network]
Address=[IP]/24
Gateway=10.10.1.1
DNS=1.1.1.1 8.8.8.8
MulticastDNS=yes
```
```
systemctl enable systemd-networkd
```
```
systemctl enable systemd-resolved
```


### boot directory
#### intel server
```
rm /boot/initramfs-linux-hardened*
```

```
mkdir -p /boot/efi /boot/efi/linux /boot/efi/systemd /boot/efi/rescue /boot/efi/boot
```

```
mkdir /boot/kernel
```

```
mv /boot/intel-ucode.img /boot/vmlinuz-linux-hardened /boot/kernel
```


#### amd server
```
rm /boot/initramfs-linux-hardened*
```

```
mkdir -p /boot/efi /boot/efi/linux /boot/efi/systemd /boot/efi/rescue /boot/efi/boot
```

```
mkdir /boot/kernel
```

```
mv /boot/amd-ucode.img /boot/vmlinuz-linux-hardened /boot/kernel
```
### kernel parameter

```
mkdir /etc/cmdline.d
```
```
touch /etc/cmdline.d/{01-boot.conf,02-mods.conf,03-secs.conf,04-perf.conf,05-nets.conf,06-misc.conf}
```
### 01-boot
```
echo "cryptdevice=UUID=$(blkid -s UUID -o value /dev/nvme0n1p3):proc root=/dev/proc/root" > /etc/cmdline.d/01-boot.conf
```

### 03-secs
```
echo "lsm=landlock,lockdown,yama,integrity,apparmor,bpf lockdown=integrity init_on_alloc=1 init_on_free=1 page_alloc.shuffle=1 slab_nomerge vsyscall=none randomize_kstack_offset=1" > /etc/cmdline.d/03-secs.conf
```

### 04-perf
```
echo "ipv6.disable=1" > /etc/cmdline.d/04-perf.conf
```
### 05-nets
```
echo "ip=(ip address)::10.10.1.1:255.255.255.0::eth0:none nameserver=10.10.1.1 nameserver=1.1.1.1 nameserver=8.8.8.8 nameserver=1.0.0.1 nameserver=8.8.4.4 nameserver=9.9.9.9 nameserver=149.112.112.112 " > /etc/cmdline.d/05-nets.conf
```
```
nvim /etc/cmdline.d/05-nets.conf
```
lalu ubah ip address

### 06-misc

```
echo "rw quiet" > /etc/cmdline.d/06-misc.conf
```

## cryptab
```
echo "data UUID=$(blkid -s UUID -o value /dev/nvme0n1p4) none" >> /etc/crypttab
```


### initram directory

```
rm -fr /etc/mkinitcpio.conf.d
```
```
mv /etc/mkinitcpio.conf /etc/mkinitcpio.d/default.conf
```
```
nvim /etc/mkinitcpio.d/default.conf
```
cari lalu commenting
```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)
```
tambahkan
```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont net clevis encrypt lvm2 block filesystems fsck)
```
tambahkan pada bagian binaries
```
/usr/bin/curl
```
#### configure linux preset

```
nvim /etc/mkinitcpio.d/linux-hardened.preset
```
uncommenting 

```
#ALL_config="/etc/mkinitcpio.conf"
```
lalu ubah
```
ALL_config="/etc/mkinitcpio.d/default.conf"
```
edit
```
ALL_kver="/boot/vmlinuz-linux-hardened"
```
menjadi
```
ALL_kver="/boot/kernel/vmlinuz-linux-hardened" 
```
edit
```
PRESETS=('default' 'fallback')
```
lalu menjadi
```
PRESETS=('default')
```
uncommenting
```
#default_uki="/efi/EFI/Linux/arch-linux-hardened.efi"
```
lalu ubah
```
default_uki="/boot/efi/linux/blackbird-hardened.efi"
```
commenting
```
fallback_image="/boot/initramfs-linux-hardened-fallback.img"
```
```
fallback_options="-S autodetect"
```
```
bootctl --path=/boot install
```
```
mkinitcpio -P
```

### recovery
```
curl --output /boot/efi/rescue/recovery.efi https://boot.netboot.xyz/ipxe/netboot.xyz.efi
```
```
printf "title recovery\nefi /efi/rescue/recovery.efi" > /boot/loader/entries/recovery.conf
```
```
cat /boot/loader/entries/recovery.conf
```

### instrusion detection

```
cd /tmp
```
```
pkg-config --libs --cflags glib-2.0
```
```
cd /dev/swap
```
```
wget https://github.com/aide/aide/releases/download/v0.19.2/aide-0.19.2.tar.gz
```
```
tar xf aide-0.19.2.tar.gz
```
```
cd aide-0.19.2
```
```
./configure --with-zlib --with-posix-acl --with-xattr --with-curl --with-locale --with-syslog-ident --with-config-file=/etc/aide.conf
```
```
make && make install
```
```
nvim /etc/systemd/system/aide.service
```
```
[Unit]
Description=Aide Check
ConditionACPower=true

[Service]
Type=simple
ExecStart=/usr/local/bin/aide --check

[Install]
WantedBy=multi-user.target
```
```
nvim /etc/systemd/system/aide.timer
```
```
[Unit]
Description=Aide check every 8 Hours

[Timer]
OnCalendar=*:0/8:00
Unit=aidecheck.service

[Install]
WantedBy=multi-user.target
```
```
systemctl enable aide.timer
```
```
mkdir -p /var/log/aide
```
```
mkdir -p /var/lib/aide
```
```
touch /var/log/aide/aide.log 
```
```
nvim /etc/aide.conf 
```
```
# Example configuration file for AIDE.
# More information about configuration options available in the aide.conf manpage.
# Inspired from https://src.fedoraproject.org/rpms/aide/raw/rawhide/f/aide.conf

# ┌───────────────────────────────────────────────────────────────┐
# │ CONTENTS OF aide.conf                                         │
# ├───────────────────────────────────────────────────────────────┘
# │
# ├──┐VARIABLES
# │  ├── DATABASE
# │  └── REPORT
# ├──┐RULES
# │  ├── LIST OF ATTRIBUTES
# │  ├── LIST OF CHECKSUMS
# │  └── AVAILABLE RULES
# ├──┐PATHS
# │  ├──┐EXCLUDED
# │  │  ├── ETC
# │  │  ├── USR
# │  │  └── VAR
# │  └──┐INCLUDED
# │     ├── ETC
# │     ├── USR
# │     ├── VAR
# │     └── OTHERS
# │
# └───────────────────────────────────────────────────────────────

# ################################################################ VARIABLES

# ################################ DATABASE

@@define DBDIR /var/lib/aide
@@define LOGDIR /var/log/aide

# The location of the database to be read.
database_in=file:@@{DBDIR}/aide.db.gz

# The location of the database to be written.
#database_out=sql:host:port:database:login_name:passwd:table
#database_out=file:aide.db.new
database_out=file:@@{DBDIR}/aide.db.new.gz

# Whether to gzip the output to database
gzip_dbout=yes

# ################################ REPORT

# Default.
log_level=warning
report_level=changed_attributes

report_url=file:@@{LOGDIR}/aide.log
report_url=stdout
#report_url=stderr
#NOT IMPLEMENTED report_url=mailto:root@foo.com
#NOT IMPLEMENTED report_url=syslog:LOG_AUTH

# ################################################################ RULES

# ################################ LIST OF ATTRIBUTES

# These are the default parameters we can check against.
#p:             permissions
#i:             inode:
#n:             number of links
#u:             user
#g:             group
#s:             size
#b:             block count
#m:             mtime
#a:             atime
#c:             ctime
#S:             check for growing size
#acl:           Access Control Lists
#selinux        SELinux security context (must be enabled at compilation time)
#xattrs:        Extended file attributes

# ################################ LIST OF CHECKSUMS

#md5:           md5 checksum
#sha1:          sha1 checksum
#sha256:        sha256 checksum
#sha512:        sha512 checksum
#rmd160:        rmd160 checksum
#tiger:         tiger checksum
#haval:         haval checksum (MHASH only)
#gost:          gost checksum (MHASH only)
#crc32:         crc32 checksum (MHASH only)
#whirlpool:     whirlpool checksum (MHASH only)

# ################################ AVAILABLE RULES

# These are the default rules
#R:             p+i+l+n+u+g+s+m+c+md5
#L:             p+i+l+n+u+g
#E:             Empty group
#>:             Growing logfile p+l+u+g+i+n+S

# You can create custom rules - my home made rule definition goes like this 
ALLXTRAHASHES = sha1+rmd160+sha256+sha512+whirlpool+tiger+haval+gost+crc32
ALLXTRAHASHES = sha1+rmd160+sha256+sha512+tiger
# Everything but access time (Ie. all changes)
EVERYTHING = R+ALLXTRAHASHES

# Sane, with multiple hashes
# NORMAL = R+rmd160+sha256+whirlpool
# NORMAL = R+sha256+sha512
NORMAL = p+i+l+n+u+g+s+m+c+sha256

# For directories, don't bother doing hashes
DIR = p+i+n+u+g+acl+xattrs

# Access control only
PERMS = p+i+u+g+acl

# Logfile are special, in that they often change
LOG = >

# Just do sha256 and sha512 hashes
FIPSR = p+i+n+u+g+s+m+c+acl+xattrs+sha256
LSPP = FIPSR+sha512

# Some files get updated automatically, so the inode/ctime/mtime change
# but we want to know when the data inside them changes
DATAONLY = p+n+u+g+s+acl+xattrs+sha256

# ################################################################ PATHS

# Next decide what directories/files you want in the database.

# ################################ EXCLUDED

# ################ ETC

# Ignore backup files
!/etc/.*~

# Ignore mtab
!/etc/mtab

# ################ USR

# These are too volatile
!/usr/src
!/usr/tmp

# ################ VAR

# Ignore logs
!/var/lib/pacman/.*
!/var/cache/.*
!/var/log/.*  
!/var/log/aide.log
!/var/run/.*  
!/var/spool/.*

# ################################ INCLUDED

# ################ ETC

# Check only permissions, inode, user and group for /etc, but cover some important files closely.
/etc                               PERMS
/etc/aliases                       FIPSR
/etc/at.allow                      FIPSR
/etc/at.deny                       FIPSR
/etc/audit/                        FIPSR
/etc/bash_completion.d/            NORMAL
/etc/bashrc                        NORMAL
/etc/cron.allow                    FIPSR
/etc/cron.daily/                   FIPSR
/etc/cron.deny                     FIPSR
/etc/cron.d/                       FIPSR
/etc/cron.hourly/                  FIPSR
/etc/cron.monthly/                 FIPSR
/etc/crontab                       FIPSR
/etc/cron.weekly/                  FIPSR
/etc/cups                          FIPSR
/etc/exports                       NORMAL
/etc/fstab                         NORMAL
/etc/group                         NORMAL
/etc/grub/                         FIPSR
/etc/gshadow                       NORMAL
/etc/hosts.allow                   NORMAL
/etc/hosts.deny                    NORMAL
/etc/hosts                         FIPSR
/etc/inittab                       FIPSR
/etc/issue                         FIPSR
/etc/issue.net                     FIPSR
/etc/ld.so.conf                    FIPSR
/etc/libaudit.conf                 FIPSR
/etc/localtime                     FIPSR
/etc/login.defs                    FIPSR
/etc/login.defs                    NORMAL
/etc/logrotate.d                   NORMAL
/etc/modprobe.conf                 FIPSR
/etc/nscd.conf                     NORMAL
/etc/pam.d                         FIPSR
/etc/passwd                        NORMAL
/etc/postfix                       FIPSR
/etc/profile.d/                    NORMAL
/etc/profile                       NORMAL
/etc/rc.d                          FIPSR
/etc/resolv.conf                   DATAONLY
/etc/securetty                     FIPSR
/etc/securetty                     NORMAL
/etc/security                      FIPSR
/etc/security/opasswd              NORMAL
/etc/shadow                        NORMAL
/etc/skel                          NORMAL
/etc/ssh/ssh_config                FIPSR
/etc/ssh/sshd_config               FIPSR
/etc/stunnel                       FIPSR
/etc/sudoers                       NORMAL
/etc/sysconfig                     FIPSR
/etc/sysctl.conf                   FIPSR
/etc/vsftpd.ftpusers               FIPSR
/etc/vsftpd                        FIPSR
/etc/X11/                          NORMAL
/etc/zlogin                        NORMAL
/etc/zlogout                       NORMAL
/etc/zprofile                      NORMAL
/etc/zshrc                         NORMAL

# ################ USR

/usr                               NORMAL
/usr/sbin/stunnel                  FIPSR

# ################ VAR

/var/log/faillog                   FIPSR
/var/log/lastlog                   FIPSR
/var/spool/at                      FIPSR
/var/spool/cron/root               FIPSR

# ################ OTHERS

/boot                              NORMAL
/bin                               NORMAL
/lib                               NORMAL
/lib64                             NORMAL
/opt                               NORMAL
/root                              NORMAL
```
```
aide --init
```
```
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
```
```
exit
```
```
umount -R /mnt
```
```
reboot
```
# 3. post instalation
```
passwd -l root
```
