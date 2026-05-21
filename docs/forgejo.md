## podman compose

```
sudo pacman -S podman
```

```
systemctl --user enable --now podman
```

## create network

```
podman network create [network name]
```

## install database forgejo using podman

```
mkdir ~/.config/containers/postgre
```

```
podman run -d \
  --name [container name] \
  --restart always \
  --network [network name] \
  -e POSTGRES_DB=forgejo \
  -e POSTGRES_USER=forgejo \
  -e POSTGRES_PASSWORD=SuperPasswordDatabase \
  -v ~/.config/containers/postgres:/var/lib/postgresql/data:Z \
  docker.io/library/postgres:16
```

## image forgejo root


```
mkdir ~/.config/containers/forgejo
```

```
podman run -d \                                                                                                                                                  --name [container name] \                                                                                   
  --restart always \
  --network [network name] \
  -p 3000:3000 \
  -p 2222:22 \
  -e USER_UID=1000 \
  -e USER_GID=1000 \
  -e FORGEJO__database__DB_TYPE=postgres \
  -e FORGEJO__database__HOST=[postgres container name]:5432 \
  -e FORGEJO__database__NAME=forgejo \
  -e FORGEJO__database__USER=forgejo \
  -e FORGEJO__database__PASSWD=SuperPasswordDatabase \
  -e FORGEJO__server__DOMAIN=localhost \
  -e FORGEJO__server__ROOT_URL=http://localhost:3000/ \
  -v ~/.config/containers/forgejo:/data:Z \
  codeberg.org/forgejo/forgejo:15
```

> access = http://localhost:3000


| Field         | Value                   |
| ------------- | ----------------------- |
| Host          | `[container postgres name ]:5432`       |
| Username      | `forgejo`               |
| Password      | `SuperPasswordDatabase` |
| Database Name | `forgejo`               |
