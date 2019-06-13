FROM ubuntu:18.10

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

ADD . /opt/ravikiranj/dotfiles
WORKDIR /opt/ravikiranj/dotfiles

CMD ["bash", "/opt/ravikiranj/dotfiles/install.sh"]
