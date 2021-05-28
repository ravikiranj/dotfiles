FROM ubuntu:20.04

RUN apt-get update && apt-get install -y sudo locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ADD . /opt/ravikiranj/dotfiles
WORKDIR /opt/ravikiranj/dotfiles

CMD bash /opt/ravikiranj/dotfiles/install.sh 2>&1 | tee /opt/ravikiranj/dotfiles/install.log
