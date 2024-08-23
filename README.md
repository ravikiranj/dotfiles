# dotfiles
Customized config files for vim, tmux, screen etc.,

## Installation

```bash
# Run install script
./install.sh
```

## Development
### Docker Validation

```bash
# Change to finch (https://github.com/runfinch/finch) if docker is not available
DOCKER_BIN="docker"
# For AL2, change to Dockerfile.al2 and dotfiles.al2 for testing 
DOCKER_FILE="Dockerfile.ubuntu"
DOCKER_NAME="dotfiles.ubuntu"

# Rebuild and run docker image
$DOCKER_BIN build -f $DOCKER_FILE -t $DOCKER_NAME . && $DOCKER_BIN stop $DOCKER_NAME && $DOCKER_BIN rm $DOCKER_NAME && $DOCKER_BIN run -t -d --name $DOCKER_NAME $DOCKER_NAME

# Tail docker container logs
$DOCKER_BIN logs -ft $DOCKER_NAME

# Login to docker container to inspect files
$DOCKER_BIN exec -it $DOCKER_NAME zsh
```
