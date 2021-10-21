## dotfiles
Customized config files for vim, tmux, screen etc.,

### Docker Validation

```bash
# Rebuild and run docker image
docker build -t dotfiles . && docker stop dotfiles && docker rm dotfiles && docker run -t -d --name dotfiles dotfiles

# View logs
docker logs -ft dotfiles
```
