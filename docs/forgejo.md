## podman compose

```
sudo pacman -S overlayfs podman podman-compose
```

```
systemctl --user enable --now podman
```

```
sudo nvim /etc/sysctl.conf
```

```/etc/sysctl.conf
user.max_user_namespaces=15000
```

```
sudo sysctl --system
```

## database for forgejo

| field          | value   |
| ------------- | ------- |
| Database name | gitrock | 
| Database user | testing |
| Database pass | 1511    |

```
podman run -d --restart always --name forgejo -e USER_UID="1000" -e USER_GID="1000" -e FORGEJO__database__DB_TYPE="postgres" -e FORGEJO__database__HOST="blacksaw.srv:10002" -e FORGEJO__database__NAME="gitrock" -e FORGEJO__database__USER="testing" -e FORGEJO__database__PASSWD="1511" -p 3000:3000 -v /home/sulfar/gitea:/var/lib/gitea:z -v /etc/localtime:/etc/localtime:ro codeberg.org/forgejo/forgejo:15
```

## rootless image

```
podman run -d --restart always --name forgejo -e FORGEJO__database__DB_TYPE="postgres" -e FORGEJO__database__HOST="blacksaw.srv:10002" -e FORGEJO__database__NAME="gitrock" -e FORGEJO__database__USER="testing" -e FORGEJO__database__PASSWD="1511" -p 3000:3000 -v /home/sulfar/.config/gitea:/var/lib/gitea:z -v /etc/localtime:/etc/localtime:ro codeberg.org/forgejo/forgejo:15-rootless
```

```
podman unshare chown -R 1000:1000 /home/sulfar/.config/gitea
```

> output akan seperti dibawah
```
drwxrwxr-x 17 100999 100999 4096 May  1 19:01  gitea
```

```
chmod -R 775 /home/sulfar/.config/gitea
```
