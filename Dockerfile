FROM ubuntu:latest
MAINTAINER Yihui Xie <xie@yihui.name>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get install -y software-properties-common > /dev/null
RUN add-apt-repository -y "deb http://cran.rstudio.com/bin/linux/ubuntu `lsb_release -cs`/"
RUN add-apt-repository -y ppa:marutter/c2d4u
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get -qq update
RUN apt-get install -y wget dpkg > /dev/null

RUN mkdir $HOME/bin || true
ENV PATH=$PATH:$HOME/bin:$HOME/texlive/bin/x86_64-linux
RUN echo $PATH && ls -al ~
RUN wget -q -O - https://github.com/yihui/crandalf/raw/master/inst/scripts/install-texlive | bash
RUN echo $PATH && ls -al $HOME/texlive/bin/x86_64-linux
RUN for i in $(find $HOME/texlive/bin/x86_64-linux -type f -executable); do ln -s $i /usr/local/bin/; done
RUN echo which pdflatex
RUN wget -q https://github.com/yihui/ubuntu-bin/releases/download/latest/texlive-local.deb
RUN dpkg -i texlive-local.deb && rm texlive-local.deb
RUN wget -q -O - https://github.com/yihui/crandalf/raw/master/inst/scripts/install-pandoc | bash
RUN mv $HOME/bin/pandoc $HOME/bin/pandoc-citeproc /usr/local/bin/

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
