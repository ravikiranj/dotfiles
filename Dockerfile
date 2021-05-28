FROM ubuntu:20.04

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

ADD . /opt/ravikiranj/dotfiles
WORKDIR /opt/ravikiranj/dotfiles

CMD bash /opt/ravikiranj/dotfiles/install.sh 2>&1 | tee /opt/ravikiranj/dotfiles/install.log
