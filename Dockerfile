FROM ubuntu:latest
MAINTAINER Yihui Xie <xie@yihui.name>

RUN apt-get update -qq
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y "deb http://cran.rstudio.com/bin/linux/ubuntu `lsb_release -cs`/"
RUN add-apt-repository -y ppa:marutter/c2d4u
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get update -qq
RUN apt-get install -y r-base-dev pandoc pandoc-citeproc
RUN ./r-cran-pkgs
RUN sudo apt-get install -y subversion
RUN sudo apt-get build-dep -y r-base-dev
RUN sudo apt-get autoremove -y
RUN sudo apt-get upgrade -y
RUN sudo apt-get autoclean
RUN git config --global user.name "Yihui Xie"
RUN git config --global user.email "xie@yihui.name"
RUN ./install-r-devel
RUN "[ ! -d ~/R ] && mkdir ~/R"
RUN cp .Renviron .Rprofile ~/
RUN R -f r-config.R
RUN Rd -f r-config.R

