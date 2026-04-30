## podman compose

```
sudo pacman -S overlayfs podman podman-compose
```

```
systemctl --user enable --now podman
```

```compose.yaml
networks:
  forgejo:
    external: false

services:
  server:
    image: codeberg.org/forgejo/forgejo:14-rootless # WAJIB pakai -rootless
    container_name: forgejo
    restart: always
    networks:
      - forgejo
    environment:
      - FORGEJO__database__DB_TYPE=postgres
      - FORGEJO__database__HOST=db:5432
      - FORGEJO__database__NAME=forgejo
      - FORGEJO__database__USER=forgejo
      - FORGEJO__database__PASSWD=forgejo
    volumes:
      - ./forgejo:/var/lib/gitea:z       # Tambahkan :z
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "3000:3000"
      - "222:2222" # SSH dalam rootless ada di 2222
    depends_on:
      - db

  db:
    image: postgres:14
    restart: always
    environment:
      - POSTGRES_USER=forgejo
      - POSTGRES_PASSWORD=forgejo
      - POSTGRES_DB=forgejo
    networks:
      - forgejo
    volumes:
      - ./postgres:/var/lib/postgresql/data:z # Tambahkan :z
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
