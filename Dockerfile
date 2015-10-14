FROM debian:jessie
MAINTAINER Jieke Choo jiekechoo@sectong.com

RUN apt-get update && apt-get install -q -y --no-install-recommends wget

RUN echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN mkdir /opt/java
RUN wget --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" -qO- \
https://download.oracle.com/otn-pub/java/jdk/8u20-b26/jre-8u20-linux-x64.tar.gz \
| tar zxvf - -C /opt/java --strip 1

RUN mkdir /opt/flume
RUN wget -qO- http://192.168.1.10/apache-flume-1.6.0-bin.tar.gz \
| tar zxvf - -C /opt/flume --strip 1

RUN wget -q http://192.168.1.10/elasticsearch/lib/lucene-core-4.10.4.jar -P /opt/flume/lib
RUN wget -q http://192.168.1.10/elasticsearch/lib/elasticsearch-1.7.2.jar -P /opt/flume/lib

ADD start-flume.sh /opt/flume/bin/start-flume

ENV JAVA_HOME /opt/java
ENV PATH /opt/flume/bin:/opt/java/bin:$PATH
CMD [ "start-flume" ]
