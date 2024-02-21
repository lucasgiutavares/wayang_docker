FROM ubuntu:latest

COPY ./mount ./mount

EXPOSE 9000

#!/bin/bash

# Install Git
ENV TZ="America/Sao_Paulo"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get install git-all -y

# Install Java
RUN apt-get update
RUN apt-get install openjdk-11-jdk -y

# Install Maven
WORKDIR /home
RUN tar xzvf /mount/apache-maven-3.9.6-bin.tar.gz
ENV PATH="$PATH:/home/apache-maven-3.9.6/bin"


# Clone Wayang Rep
RUN git clone https://github.com/apache/incubator-wayang.git

WORKDIR /home/incubator-wayang

## Install Maven
RUN mvn clean compile
RUN mvn clean install

RUN mvn -N io.takari:maven:wrapper

RUN ./mvnw clean package -pl :wayang-assembly -Pdistribution > mvnw.log

# Compile Wayang
WORKDIR /home/incubator-wayang/wayang-assembly/target
RUN tar -xvf apache-wayang-assembly-0.7.1-incubating-dist.tar.gz

RUN export WAYANG_HOME=$(pwd)/wayang-0.7.1

RUN echo "WAYANG-HOME:" $WAYANG_HOME
#
