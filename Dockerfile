FROM ubuntu:latest
MAINTAINER Yihui Xie <xie@yihui.name>

RUN apt-get update -qq
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y "deb http://cran.rstudio.com/bin/linux/ubuntu `lsb_release -cs`/"
RUN add-apt-repository -y ppa:marutter/c2d4u
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get update -qq
RUN apt-get install -y r-base-dev

# packages that I need
RUN apt-get install  r-recommended r-cran-xml r-cran-rcurl r-cran-rgl r-cran-knitr
