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
# Rebuild and run docker image
docker build -t dotfiles . && docker stop dotfiles && docker rm dotfiles && docker run -t -d --name dotfiles dotfiles

# Tail docker container logs
docker logs -ft dotfiles

# Login to docker container to inspect files
docker exec -it dotfiles bash
```
