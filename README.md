# docker-jenkins
Jenkins in a Docker container

This is a dockerfile for jenkins with some extra plugins install. These include:

* mule-mmc (custom plugin based on https://github.com/mulesoft-labs/jenkins-mmc-plugin)
* credentials
* git
* build-pipeline-plugin
* extensible-choice-parameter
* parameterized-trigger
* workflow-step-api

###1 Jobs
The jenkins jobs and configuation are checked out from https://github.com/mulesoft-labs/jenkins-config

These can be update in the docker container using the following command 

    docker exec -it <name of jenkins container> bash
    cd /var/lib/jenkins 
    git pull
  
Jenkins can then force the conbfiguration to be pulled from disk via 

    Manage Jenkins > Reload Configuration from Disk

###2 Run container (from image built from this repo) 

    docker build <dockerfile dir>
    docker run -d -t -p 8080:8080 --name=jenkins <image id from build step>
    
###3 Run container (from image on Docker Hub)

    docker run -d -t -p 8080:8080 --name=jenkins adamsdavis/docker-jenkins:1

###4 Required dependent containers 
###4.1 Nexus

The jenkins image requires a nexus instance to interface with. 

    docker run -d -p 8081:8081 --name nexus sonatype/nexus:oss
  
###4.2 MMC && Mule
The jenkins image also requires MMC and a Mule instance for some jobs to test against

    https://github.com/adamsdavis1976/docker
  
This project contains dockerfiles for MMC and Mule. These can be built manually 

    docker build <docker file dir>
  
This will return an image id. Then the images can be run with 

    docker run -d -t -p 8585:8080 --name=mmc <mmc image id>
    docker run -d -t -p 9081:8081 --name=mule-1 <mule image id>

###4.3 Cloudhub 
You must add cloudhub credentials if you want to test via CH. 

    docker exec -it <name of jenkins container> bash
    nano /var/lib/jenkins/maven_config/settings_ci.xml
    edit CH username and password
  


  


