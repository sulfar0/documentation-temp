# mongodb using podman

## research

1. Install Podman, Docker, and Docker Compose

```
pacman -S podman docker docker-compose
```

2. rootless

```
nvim /etc/subuid
```

```/etc/subuid
'user' 100000:65536
```

```
nvim /etc/subgid
```

```/etc/subgid
'user' 100000:65536
```

3. Configure registries

```
nvim /etc/containers/registries.conf
```

> in very bottom add
```
unqualified-search-registries = ["docker.io", "quay.io"]
```

4. Pull image

```
docker pull mongo:8.3.0-rc5-windowsservercore-ltsc2025
```

or 

```
docker pull mongo:latest
```

```
docker pull mongodb/mongodb-community-server:latest
```

> if using podman then change docker with podman

2. Environment variabel

| Environment                | Variabel       |
| -------------------------- | -------------- |
| MONGO_INITDB_ROOT_USERNAME | 'youruser'     |
| MONGO_INITDB_ROOT_PASSWORD | 'yourpassword' |

to set a root username in mongodb using environment MONGO_INITDB_ROOT_USERNAME, and set a password using environment MONGO_INITDB_ROOT_PASSWORD.

3. Store data

```
mkdir /my/own/datadir
```

```
docker run --name my-mongodb -v /my/own/datadir:/data/db -d mongodb/mongodb-community-server:latest
```

| Field             | Description                     |
| ----------------- | ------------------------------- |
| docker run        | to start and pull               |
| --name my-mongodb | container name                  |
| -v                | to set path                     |
| /my/own/datadir   | directory data in local         |
| /data/db          | directory data in container     |
| -d                | container running in background |

> note: the path you can custom anything you name it.

4. Connecting container

```
docker run -it --network some-network --rm mongodb/mongodb-community-server:latest mongosh --host my-mongodb test
```

| Field                  | Description                      |
| ---------------------- | -------------------------------- |
| docker run             | to start and pull                |
| --network some-network | container network name           |
| -rm                    | to remove client when exit       |
| mongo                  | using image mongo as a client    |
| mongosh                | run shell                        |
| --host my-mongodb      | bridging to container my-mongodb |
| test                   | use database test                |

5. docker compose

```
sudo pacman -S docker-compose
```

```docker-compose.yml
services:
  mongo:
    image: mongodb/mongodb-community-server:latest
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: example

  mongo-express:
    image: mongo-express
    restart: always
    ports:
      - 8081:8081
    environment:
      ME_CONFIG_MONGODB_URL: mongodb://root:example@mongo:27017/
      ME_CONFIG_BASICAUTH_ENABLED: true
      ME_CONFIG_BASICAUTH_USERNAME: mongoexpressuser
      ME_CONFIG_BASICAUTH_PASSWORD: mongoexpresspass
```

## documentation

1. pull and run in terminal

```
docker run -d \
  --name my-mongodb \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password_anda \
  -v mongodb_data:/data/db \
  mongodb/mongodb-community-server:latest
```

2. access trough terminal

```
docker exec my-mongodb mongosh -u admin -p password_anda
```

3. using docker compose

```
services:
  mongo:
    image: mongodb/mongodb-community-server:latest
    ports: 
      - 27017:27017
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: example

  mongo-express:
    image: mongo-express
    restart: always
    ports:
      - 8081:8081
    environment:
      ME_CONFIG_MONGODB_URL: mongodb://root:example@mongo:27017/
      ME_CONFIG_BASICAUTH_ENABLED: true
      ME_CONFIG_BASICAUTH_USERNAME: mongoexpressuser
      ME_CONFIG_BASICAUTH_PASSWORD: mongoexpresspass
```

## reference

1. [Docker](https://hub.docker.com/_/mongo)
2. [Baeldung](https://www.baeldung.com/linux/mongodb-as-docker-container)
3. [Mongodb](https://www.mongodb.com/docs/manual/administration/install-community/?operating-system=docker&search-docker=with-search-docker)
4. [Wiki](https://wiki.archlinux.org/title/Linux_Containers#Enable_support_to_run_unprivileged_containers_(optional))
