# Laravel Hello Docker

A simple project that focuses on learning how to use Docker inside a Laravel project.

## Docker basic commands

### Stop all running  Docker containers

```shell
docker ps -q | xargs -r docker kill
```

### Delete all Docker containers

```shell
docker ps -aq | xargs -r docker rm -vf
```

### Delete all Docker images

```shell
docker images -aq | xargs -r docker rmi -f
```

### Delete all Docker volumes

```shell
docker volume ls -q --filter dangling=true | xargs -r docker volume rm
```

### Delete (almost) everything

```shell
docker system prune -a --volumes
```

### Download Docker image from registry

Pulling `ubuntu` image from Docker Hub

```shell
docker pull ubuntu
```

### Build Docker image from Dockerfile in the current directory

```shell
docker build .
```

### Authenticate Docker

```shell
docker login
```

### Give Docker image a new name

```shell
docker tag image-name username/image-name
```

### Push Docker image to Docker Hub

```shell
docker push username/image-name
```

### Pull Docker image from Docker Hub

```shell
docker pull username/image-name
```

### Create a new Docker volume

```shell
docker volume create volume-name
```

### Start a container with a volume mount

```shell
docker run --mount type=volume,src=volume-name,target=/path/on/the/container image-name
```

### Start a container with a bind mount

```shell
docker run --mount type=bind,src=.path/to/data/on/host/filesystem,target=/path/on/the/container image-name
```

### Check information about a Docker volume

```shell
docker volume inspect todo-db
```

### Create a new Docker network

```shell
docker network create network-name
```

### Run the application stack

```shell
docker compose up -d
```

### Stop the application stack

```shell
docker compose down
```

### Show Docker Compose logs

```shell
docker compose logs -f
```

## Dockerfile file structure

Docker can build images automatically by reading the instructions from a Dockerfile. A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image.

### Comments

BuildKit treats lines that begin with # as a comment, unless the line is a valid parser directive. A # marker anywhere else in a line is treated as an argument.

Example:

```Dockerfile
# This is a comment
RUN echo '# This is not a comment'
```

### FROM

```Dockerfile
FROM [--platform=<platform>] <image>[:<tag>][@<digest>] [AS <name>]
```

The `FROM` instruction initializes a new build stage and sets the base image for subsequent instructions. As such, a valid Dockerfile must start with a `FROM` instruction. `ARG` is the only instruction that may precede FROM in the Dockerfile. The image can be any valid image.

**Example:**

```Dockerfile
FROM node:22
```

**Using with ARG:**

```Dockerfile
ARG VERSION=22
FROM node:${VERSION}
```

Or

```Dockerfile
ARG VERSION=22
FROM node:$VERSION
```

### RUN

The `RUN` instruction will execute any commands to create a new layer on top of the current image. The added layer is used in the next step in the Dockerfile. `RUN` has two forms:

```Dockerfile
# Shell form:
RUN [OPTIONS] <command> ...
# Exec form:
RUN [OPTIONS] [ "<command>", ... ]
```

**Examples:**

One line command:

```Dockerfile
RUN apt update && apt install -y curl
```

Multiline command:

```Dockerfile
RUN <<EOF
apt update
apt install -y curl
EOF
```

Also multiline command:

```Dockerfile
RUN apt update \
apt install -y curl
```

### CMD and ENTRYPOINT

Both `CMD` and `ENTRYPOINT` define what runs when a container starts. They can be used with either exec or shell form. Only the last `CMD` and `ENTRYPOINT` in the Dockerfile takes effect.

`ENTRYPOINT` sets the main executable (what always runs). Prefer exec form: `ENTRYPOINT ["executable", "arg"]`.

If `ENTRYPOINT` is not set, then CMD provides a default command. If not, it provides default arguments to the command from `ENTRYPOINT`.

What gets executed in different scenarios:
- `docker run image` - if ENTRYPOINT set: ENTRYPOINT + CMD; else: CMD
- `docker run image args...` - ENTRYPOINT + args (replaces CMD)
- `docker run --entrypoint ... image` - Replaces the image's ENTRYPOINT

**Examples:**

```Dockerfile
# Appliance-style image with overridable defaults
ENTRYPOINT ["myapp"]
CMD ["--port", "8080"]

# docker run image -> myapp --port 8080
# docker run image --port 9090 -> myapp --port 9090
# docker run --entrypoint sh image -c 'echo hi' -> replaces ENTRYPOINT
```

### Shell form vs exec form

The `RUN`, `CMD`, and `ENTRYPOINT` instructions all have two possible forms:

- `INSTRUCTION ["executable","param1","param2"]` (exec form)
- `INSTRUCTION command param1 param2` (shell form)

The exec form makes it possible to avoid shell string munging, and to invoke commands using a specific command shell, or any other executable. It uses a JSON array syntax, where each element in the array is a command, flag, or argument. This also means you have to use double-quotes instead of single-quotes.

The shell form is more relaxed, and emphasizes ease of use, flexibility, and readability. The shell form automatically uses a command shell, whereas the exec form does not.

**Shell form examples:**

```Dockerfile
RUN echo $HOME
```

Or

```Dockerfile
SHELL ["/bin/bash", "-c"]
RUN echo $HOME
```

**Exec form examples:**

```Dockerfile
RUN ["sh", "-c", "echo $HOME"]
```

Or

```Dockerfile
RUN ["/bin/bash", "-c", "echo $HOME"]
```

### WORKDIR

The `WORKDIR` instruction sets the working directory for any `RUN`, `CMD`, `ENTRYPOINT`, `COPY` and `ADD` instructions that follow it in the Dockerfile. If the `WORKDIR` doesn't exist, it will be created even if it's not used in any subsequent Dockerfile instruction.

The `WORKDIR` instruction can be used multiple times in a Dockerfile. If a relative path is provided, it will be relative to the path of the previous `WORKDIR` instruction. For example:

```Dockerfile
WORKDIR /a
WORKDIR b
WORKDIR c
RUN pwd
```

The output of the final pwd command in this Dockerfile would be /a/b/c.

### COPY

`COPY` has two forms. The latter form is required for paths containing whitespace.

```Dockerfile
COPY [OPTIONS] <src> ... <dest>
COPY [OPTIONS] ["<src>", ... "<dest>"]
```

The `COPY` instruction copies new files or directories from `<src>` and adds them to the filesystem of the image in the `<dest>` directory path. Files and directories can be copied from the build context, build stage, named context, or an image.

**Examples:**

```Dockerfile
# Copy all files from a directory to the destination path
COPY ./src /usr/src/things
# Copy files into the directory
COPY file1.txt file2.txt /usr/src/things/
```

### EXPOSE

```Dockerfile
EXPOSE <port> [<port>/<protocol>...]
```

The `EXPOSE` instruction informs Docker that the container listens on the specified network ports at runtime. You can specify whether the port listens on TCP or UDP, and the default is TCP if you don't specify a protocol.

Regardless of the `EXPOSE` settings, you can override them at runtime by using the -p flag. For example

```shell
docker run -p 80:80/tcp -p 80:80/udp ...
```

## Docker volumes

Volumes provide the ability to connect specific filesystem paths of the container back to the host machine. If you mount a directory in the container, changes in that directory are also seen on the host machine. If you mount that same directory across container restarts, you'd see the same files.

There are two main types of volumes: volume mounts and bind mounts.

Volume mounts allow to persist data on the specified directory in the container. When you exit the container, all changes get lost. However when you specify a volume mount, the files in the specified directory will stay saved. Then when you run the container again, these files will be there still.

Bind mounts allow the container to access a specified directory on hosts filesystem. For example you can bind mount source code of your application and the container will see all changes to these files immediately after saving them.

## Docker Compose