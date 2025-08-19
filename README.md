# How to delete all Docker containers

```shell
docker rm -vf $(docker ps -aq)
```

# How to delete all Docker images

```shell
docker rmi -f $(docker images -aq)
```

# How to delete everything from Docker

```shell
docker system prune -a --volumes
```

# How to run a Laravel project in Docker

