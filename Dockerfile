FROM buildpack-deps
MAINTAINER Zaiste <oh [at] zaiste.net>

RUN apt-get update \
  && apt-get -q -y install wget curl git openjdk-7-jdk \
  && echo "deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list \
  && wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add - \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y jenkins maven \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

VOLUME /var/lib/jenkins

ENV JENKINS_HOME /var/lib/jenkins
ENV MAVEN_HOME /usr/share/maven
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64

EXPOSE 8080

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

CMD /usr/local/bin/run
