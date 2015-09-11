
FROM adamsdavis/jenkins-docker-base:2

MAINTAINER Adam Davis

ADD . /build

RUN chmod +x /build/setup.sh 

RUN /build/setup.sh

CMD ["-Xmx200m"]