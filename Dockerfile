FROM centos:7
LABEL maintainer="Vadym Nechval <blackchval@gmail.com>"

RUN yum -y install gcc \
    wget \
    #libidn-devel \
    perl-JSON \
    perl-File-Slurp \
    perl-YAML \
    perl-Test-Harness \
    perl-App-cpanminus

RUN cpanm Moose \
    namespace::autoclean \
    Test::Builder

# download sample app
RUN wget -O /tmp/sample.war https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/sample.war

RUN mkdir /opt/EC
WORKDIR /opt/EC

ADD ./ ./

ENV PERL5LIB=$PERL5LIB:lib