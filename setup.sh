#!/bin/bash
set -e

# update dpkg repositories
apt-get update 

# install wget
apt-get install -y wget

# get maven 3.2.2
wget --progress=bar -O /tmp/apache-maven-3.2.5.tar.gz http://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz 

# verify checksum
echo "b2d88f02bd3a08a9df1f0b0126ebd8dc /tmp/apache-maven-3.2.5.tar.gz" | md5sum -c

# install maven
tar xzf /tmp/apache-maven-3.2.5.tar.gz -C /opt/
ln -s /opt/apache-maven-3.2.5 /opt/maven
ln -s /opt/maven/bin/mvn /usr/local/bin
rm -f /tmp/apache-maven-3.2.5.tar.gz
export MAVEN_HOME=/opt/maven

# install git
apt-get install -y git
git config --global user.email "test@test.com"
git config --global user.name "test user"

# install nano
apt-get install -y nano

# install nano
apt-get install -y rsync

# remove download archive files
apt-get clean

# copy jenkins war file to the container
wget --progress=bar -O /opt/jenkins.war http://mirrors.jenkins-ci.org/war/1.628/jenkins.war 
chmod 644 /opt/jenkins.war

export JENKINS_HOME=/var/lib/jenkins
export PLUGINS_ENDPOINT=http://updates.jenkins-ci.org/latest/

mkdir -p $JENKINS_HOME/plugins
mkdir -p $JENKINS_HOME/jobs

#get the jenkins jobs 
git clone https://github.com/mulesoft-labs/jenkins-config.git /tmp-jenkins 
rsync -av /tmp-jenkins/ $JENKINS_HOME/ 
rm /opt/maven/conf/settings.xml
ln -s $JENKINS_HOME/maven_settings/settings_ci.xml $MAVEN_HOME/conf/settings.xml  
rm -rf ~/tmp-jenkins

#install custom mule mmc jenkins plugins
wget --progress=bar --no-check-certificate -O $JENKINS_HOME/plugins/mule-mmc.hpi https://github.com/adamsdavis1976/misc-binaries/blob/master/mule-mmc.hpi?raw=true

#install other jenkins plugins
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/credentials.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/git-client.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/git.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/github.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/scm-api.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/postbuild-task.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/build-pipeline-plugin.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/copyartifact.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/ws-cleanup.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/extensible-choice-parameter.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/jquery.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/parameterized-trigger.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/workflow-step-api.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/plain-credentials.hpi
wget --progress=bar --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/github-api.hpi



