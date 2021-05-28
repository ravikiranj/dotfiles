## dotfiles
Customized config files for vim, tmux, screen etc.,

### Docker Validation

```bash
# Rebuild and run docker image
docker build -t dotfiles . && docker stop dotfiles && docker rm dotfiles && docker run -t -d --name dotfiles dotfiles

# View logs and exit status code
docker exec -it dotfiles bash -c "tail -F install.log" || docker container ls -a | grep dotfiles
```
