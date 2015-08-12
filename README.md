BaseImage consists of the precompiled hashicorp consul-template binary and presently a custom vault version which supports Slug value for Github teams https://github.com/broadinstitute/vault



**Envrionment Variables Required**

* APPNAME = Appname mostly used for configuration files
* VAULT_ADDR = vault server address with protocol and port
* ENVIRONMENT = One of dev,staging,production

**Example template replacement**

consul-template -config=/etc/consul-template.conf -once -template=/etc/${APPNAME}.tmpl:/etc/${APPNAME}.conf


docker run -ti -e VAULT_ADDR=<VAULT ADDRESS> -e POLICY=secretspython_test -e APPNAME=test broadinstitute/baseimage /opt/bootstrap.sh

