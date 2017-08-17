FROM centos:7
LABEL maintainer="Vadym Nechval <blackchval@gmail.com>"

RUN yum -y install wget \
    perl \
    perl-App-cpanminus

RUN cpanm Moose \
    namespace::autoclean \
    JSON \
    File::Slurp \
    YAML \
    LWP

# download sample app
RUN wget -O /tmp/sample.war https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/sample.war

RUN mkdir /opt/EC
WORKDIR /opt/EC

ADD ./ ./

ENV PERL5LIB=$PERL5LIB:lib
ENTRYPOINT ["perl", "mod_control.pl", "-h"]