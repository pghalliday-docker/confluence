#!/bin/bash

set -e

SOURCE_SERVER_XML=/confluence-server.xml
SERVER_XML=${CONFLUENCE_INSTALL_DIR}/current/conf/server.xml
if [ "${CONFLUENCE_PROXY_NAME}" != "" -a "${CONFLUENCE_PROXY_PORT}" != "" ]
then
  sed "s/PROXY_SETTINGS/proxyName=\"${CONFLUENCE_PROXY_NAME}\" proxyPort=\"${CONFLUENCE_PROXY_PORT}\"/g" <${SOURCE_SERVER_XML} >${SERVER_XML}
else
  sed 's/PROXY_SETTINGS//g' <${SOURCE_SERVER_XML} >${SERVER_XML}
fi

chown -R ${CONFLUENCE_USER}:${CONFLUENCE_GROUP} ${CONFLUENCE_HOME}
su ${CONFLUENCE_USER} -c "$@"
