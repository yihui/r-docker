FROM ubuntu:latest
MAINTAINER Yihui Xie <xie@yihui.name>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get install -y software-properties-common libgdal1-dev libproj-dev > /dev/null
RUN add-apt-repository -y "deb http://cran.rstudio.com/bin/linux/ubuntu `lsb_release -cs`/"
RUN add-apt-repository -y ppa:marutter/c2d4u
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get -qq update
RUN apt-get install -y wget dpkg libgmp10 > /dev/null

RUN wget -q -O - https://github.com/yihui/crandalf/raw/master/inst/scripts/install-texlive | bash
RUN for i in $HOME/texlive/bin/x86_64-linux/*; do ln -s $i /usr/local/bin/; done
RUN ls -l /usr/local/bin
RUN which pdflatex
RUN wget -q https://github.com/yihui/ubuntu-bin/releases/download/latest/texlive-local.deb
RUN dpkg -i texlive-local.deb && rm texlive-local.deb
RUN wget -q https://github.com/jgm/pandoc/releases/download/1.15.0.6/pandoc-1.15.0.6-1-amd64.deb
RUN dpkg -i pandoc-*.deb && rm pandoc-*.deb

RUN apt-get install -y r-base-dev git > /dev/null

ADD r-cran-pkgs /tmp/r-cran-pkgs
RUN bash /tmp/r-cran-pkgs

RUN apt-get autoremove -y
RUN apt-get autoclean

# Since the default user is root, $HOME is actually / at this point
ADD .Renviron /.Renviron
ADD .Rprofile /.Rprofile
ADD r-config.R /tmp/r-config.R
RUN cat /tmp/r-config.R | R --no-save
