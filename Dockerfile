# Baseimage maintained by the Broad Institute which contains consul-template
# and vault binaries

FROM phusion/baseimage:0.9.17

ENV VERSION 0.10.0

RUN apt-get update && apt-get install -y uuid-runtime zip

RUN curl -SL https://github.com/hashicorp/consul-template/releases/download/v${VERSION}/consul-template_${VERSION}_linux_amd64.tar.gz | tar zvx && mv consul-template_${VERSION}_linux_amd64/consul-template /usr/sbin/ && rm -Rf consul-template_${VERSION}_linux_amd64
COPY consul-template.conf test.tmpl /etc/
RUN curl -SL http://artifactory.broadinstitute.org/artifactory/simple/libs-release-local/vault-zips/linux_amd64.zip | funzip > /usr/sbin/vault

COPY bootstrap.sh /usr/sbin/
