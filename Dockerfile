FROM ubuntu:14.04
MAINTAINER Fokko Driesprong <fokko@driesprong.frl>

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y wget git \
  && rm -rf /var/lib/apt/lists/*

# Java
RUN cd /opt/ \
  && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.tar.gz" \
  && tar xzf jdk-8u66-linux-x64.tar.gz \
  && rm jdk-8u66-linux-x64.tar.gz \
  && update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_66/bin/java 100 \
  && update-alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_66/bin/jar 100 \
  && update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_66/bin/javac 100 \
  && java -version

# Maven
RUN cd /opt/ \
  && wget http://apache.cs.uu.nl/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
  && tar xzf apache-maven-3.3.9-bin.tar.gz \
  && rm apache-maven-3.3.9-bin.tar.gz

ENV PATH /opt/apache-maven-3.3.9/bin:$PATH

ENV MAVEN_OPTS -Xmx2048m

# SPARK
RUN git clone https://github.com/apache/spark.git /tmp/spark \
  && cd /tmp/spark \
  && git checkout tags/v1.6.0 \
  && ./dev/change-scala-version.sh 2.11 \
  && mvn -pl '!examples,!external/twitter,!external/flume,!external/flume-sink,!external/flume-assembly,!external/mqtt,!external/mqtt-assembly' -Dscala-2.11 -DskipTests clean package  \
  && mkdir -p /usr/spark/ \
  && mv ./bin/ /usr/spark/bin/ \
  && mv ./assembly/ /usr/spark/assembly/ \
  && mv ./lib_managed/ /usr/spark/lib_managed/ \
  && cd /usr/spark/bin

CMD /usr/spark/bin/spark-class org.apache.spark.deploy.master.Master
