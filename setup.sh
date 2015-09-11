#!/bin/bash
set -e

export PLUGINS_ENDPOINT=http://updates.jenkins-ci.org/latest/

mkdir -p $JENKINS_HOME/plugins
mkdir -p $JENKINS_HOME/jobs


git clone https://github.com/mulesoft-labs/jenkins-config.git /tmp-jenkins 
cp -R /tmp-jenkins/* $JENKINS_HOME/ 
cp -R /tmp-jenkins/maven_settings/settings_ci.xml /opt/maven/conf/settings.xml  
rm -rf ~/tmp-jenkins

wget --no-check-certificate -O $JENKINS_HOME/plugins/mule-mmc.hpi https://github.com/adamsdavis1976/misc-binaries/blob/master/mule-mmc.hpi?raw=true

wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/credentials.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/git-client.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/git.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/github.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/scm-api.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/postbuild-task.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/build-pipeline-plugin.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/copyartifact.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/ws-cleanup.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/extensible-choice-parameter.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/jquery.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/parameterized-trigger.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/workflow-step-api.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/plain-credentials.hpi
wget --no-check-certificate -P $JENKINS_HOME/plugins/ $PLUGINS_ENDPOINT/github-api.hpi


git config --global user.email "adamsdavis@gmail.com"
git config --global user.name "test user"

