# mongodb using docker

## research

1. Pull image

```
docker pull mongo:8.3.0-rc5-windowsservercore-ltsc2025
```

or 

```
docker pull mongo:latest
```

2. Environment Variabel

| Environment                | Variabel       |
| -------------------------- | -------------- |
| MONGO_INITDB_ROOT_USERNAME | 'youruser'     |
| MONGO_INITDB_ROOT_PASSWORD | 'yourpassword' |

to set a root username in mongodb using environment MONGO_INITDB_ROOT_USERNAME, and set a password using environment MONGO_INITDB_ROOT_PASSWORD.

3. docker compose

```
sudo pacman -S docker-compose
```

```docker-compose.yml
services:
  mongo:
    image: mongo:latest
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

1. pull and run

```
docker run -d \
  --name my-mongodb \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password_anda \
  -v mongodb_data:/data/db \
  mongo:latest
```

2. using docker compose

```
services:
  mongo:
    image: mongo:latest
    port: 27017:27017
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
2. 