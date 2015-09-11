# Dockerizing Jenkins with Mule plugins
# Version:  1
# Based on:  dockerfile/java (Trusted Java from http://java.com)
FROM java:8-jdk

MAINTAINER Adam Davis

ADD . /build

#setup jenkins, maven etc 
RUN chmod +x /build/setup.sh 
RUN /build/setup.sh

#set container environment variables
ENV MAVEN_HOME=/opt/maven
ENV JENKINS_HOME=/var/lib/jenkins

# configure the container to run jenkins, mapping container port 8080 to that host port
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080