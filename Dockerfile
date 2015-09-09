
FROM buildpack-deps

# extend the most recent long term support Ubuntu version
#FROM ubuntu:14.04

MAINTAINER Adam Davis

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive

# update dpkg repositories
RUN apt-get update 

# install wget
RUN apt-get install -y wget

# get maven 3.2.2
RUN wget --no-verbose -O /tmp/apache-maven-3.2.5.tar.gz http://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz 

# verify checksum
RUN echo "b2d88f02bd3a08a9df1f0b0126ebd8dc /tmp/apache-maven-3.2.5.tar.gz" | md5sum -c

# install maven
RUN tar xzf /tmp/apache-maven-3.2.5.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.2.5 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.2.5.tar.gz
ENV MAVEN_HOME /opt/maven

# install git
RUN apt-get install -y git

# install nano
RUN apt-get install -y nano

# remove download archive files
RUN apt-get clean

# set shell variables for java installation
ENV java_version 1.8.0_60
ENV filename jdk-8u60-linux-x64.tar.gz
ENV downloadlink http://download.oracle.com/otn-pub/java/jdk/8u60-b27/$filename

# download java, accepting the license agreement
RUN wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O /tmp/$filename $downloadlink 

# unpack java
RUN mkdir /opt/java-oracle && tar -zxf /tmp/$filename -C /opt/java-oracle/
ENV JAVA_HOME /opt/java-oracle/jdk$java_version
ENV PATH $JAVA_HOME/bin:$PATH

# configure symbolic links for the java and javac executables
RUN update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 20000 && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 20000

# copy jenkins war file to the container
ADD http://mirrors.jenkins-ci.org/war/1.628/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war

VOLUME /var/lib/jenkins

ENV JENKINS_HOME /var/lib/jenkins

ENV PLUGINS_ENDPOINT http://updates.jenkins-ci.org/latest/

RUN mkdir -p $JENKINS_HOME/plugins
RUN mkdir -p $JENKINS_HOME/jobs

RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate -O mule-mmc.hpi https://github.com/adamsdavis1976/misc-binaries/blob/master/mule-mmc.hpi?raw=true

RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/credentials.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/git-client.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/git.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/github.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/scm-api.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/postbuild-task.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/build-pipeline-plugin.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/copyartifact.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/ws-cleanup.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/extensible-choice-parameter.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/jquery.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/parameterized-trigger.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/workflow-step-api.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/plain-credentials.hpi
RUN cd $JENKINS_HOME/plugins && wget --no-check-certificate $PLUGINS_ENDPOINT/github-api.hpi


RUN cd $JENKINS_HOME && git clone https://github.com/mulesoft-labs/jenkins-config.git 
RUN mv $JENKINS_HOME/jenkins-config/jobs/ $JENKINS_HOME/ 
RUN mv $JENKINS_HOME/jenkins-config/*.xml $JENKINS_HOME/ 
RUN mv $JENKINS_HOME/jenkins-config/maven_settings/ $JENKINS_HOME/ 

RUN chown -R jenkins $JENKINS_HOME

# configure the container to run jenkins, mapping container port 8080 to that host port
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080