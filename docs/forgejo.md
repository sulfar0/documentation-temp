## podman compose

```
sudo pacman -S overlayfs podman podman-compose
```

```
systemctl --user enable --now podman
```

## creating database for forgejo

```
sudo nvim /etc/sysctl.conf
```

```/etc/sysctl.conf
user.max_user_namespaces=15000
```

```
sudo sysctl --system
```

```
podman run -d --restart always --name forgejo -e USER_UID="1000" -e USER_GID="1000" -e USER_GID="1000" -e FORGEJO__database__DB_TYPE="postgres" -e FORGEJO__database__HOST="blaksaw.srv:10002" -e FORGEJO__database__USER="testing" -e FORGEJO__database__PASSWD="1511" -v /home/sulfar/forgejo:/data codeberg.org/forgejo/forgejo:14
```

```
podman exec -it <nama_kontainer> createdb -U <username> forgejo
```

```compose.yaml
services:
  server:
    image: codeberg.org/forgejo/forgejo:14-rootless # WAJIB pakai -rootless
    container_name: forgejo
    restart: always
    environment:
      - USER_UID=1000 # disesuaikan dengan UID user 
      - USER_GID=1000 # disesuaikan dengan GID user
      - FORGEJO__database__DB_TYPE=postgres
      - FORGEJO__database__HOST=[ip address server]:5432
      - FORGEJO__database__NAME=forgejo
      - FORGEJO__database__USER=forgejo
      - FORGEJO__database__PASSWD=forgejo
    volumes:
      - /var/lib/forgejo:/var/lib/gitea:z       # Tambahkan :z
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "[port yang diinginkan]:3000"
      - "222:2222" # SSH dalam rootless ada di 2222
 
```

```
podman unshare chown -R 1000:1000 ./forgejo
```

```
podman unshare chown -R 999:999 ./postgres
```

```
podman compose up -d
```

```
podman exec -it <nama_kontainer_forgejo> forgejo admin user create --username admin_saya --password password_kuat --email admin@example.com --admin
```

database = gitrock
user = testing
pass = 1511
