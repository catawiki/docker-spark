FROM ubuntu:14.04
MAINTAINER Fokko Driesprong <fokko@driesprong.frl>

RUN apt-get update \
  && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
  && apt-get upgrade -y \
  && apt-get install -y software-properties-common python-software-properties \
  && apt-add-repository -y ppa:andrei-pozolotin/maven3 \
  && apt-add-repository -y ppa:webupd8team/java \
  && apt-get update \
  && apt-get install -y curl net-tools unzip python git oracle-java8-installer maven3  \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV MAVEN_OPTS -Xmx2048m

# SPARK
RUN git clone https://github.com/apache/spark.git /tmp/spark \
  && cd /tmp/spark \
  && git checkout branch-1.6 \
  && ./dev/change-scala-version.sh 2.11 \
  && mvn -pl '!examples,!external/twitter,!external/flume,!external/flume-sink,!external/flume-assembly,!external/mqtt,!external/mqtt-assembly' -Dscala-2.11 -DskipTests clean package  \
  && mkdir -p /usr/spark/ \
  && mv ./bin/ /usr/spark/bin/ \
  && mv ./assembly/ /usr/spark/assembly/ \
  && mv ./lib_managed/ /usr/spark/lib_managed/ \
  && cd /usr/spark/bin

RUN rm -rf /tmp/ \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/oracle-jdk8-installer

CMD /usr/spark/bin/spark-class org.apache.spark.deploy.master.Master
