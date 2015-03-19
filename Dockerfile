FROM ubuntu:latest

ENV ATLASSIAN_HOME=/var/atlassian/application-data \
    CONFLUENCE_USER=confluence \
    CONFLUENCE_GROUP=confluence \
    CONFLUENCE_CHECKSUM=17eae4db5f08e7829f465aa6a98d7bcfe30d335afc97c52f57472c91bbe88da8 \
    CONFLUENCE_BASENAME=atlassian-confluence-5.7.1 \
    CONFLUENCE_INSTALL_DIR=/opt/atlassian/confluence

ENV CONFLUENCE_HOME=${ATLASSIAN_HOME}/confluence \
    CONFLUENCE_TARBALL=${CONFLUENCE_BASENAME}.tar.gz

ENV CONFLUENCE_URL=https://www.atlassian.com/software/confluence/downloads/binary/${CONFLUENCE_TARBALL}

RUN apt-get update \
    && apt-get install -y \
    wget \
    openjdk-7-jre

RUN mkdir -p ${ATLASSIAN_HOME} \
    && groupadd -r ${CONFLUENCE_GROUP} \
    && useradd -r -g ${CONFLUENCE_GROUP} -d ${CONFLUENCE_HOME} ${CONFLUENCE_USER} \
    && mkdir -p ${CONFLUENCE_INSTALL_DIR}

WORKDIR ${CONFLUENCE_INSTALL_DIR}
RUN wget -q ${CONFLUENCE_URL} \
    && echo ${CONFLUENCE_CHECKSUM} ${CONFLUENCE_TARBALL} | sha256sum -c - \
    && tar zxf ${CONFLUENCE_TARBALL} \
    && rm ${CONFLUENCE_TARBALL} \
    && ln -s ${CONFLUENCE_BASENAME} current \
    && chown -R ${CONFLUENCE_USER}:${CONFLUENCE_GROUP} current/logs \
    && chown -R ${CONFLUENCE_USER}:${CONFLUENCE_GROUP} current/temp \
    && chown -R ${CONFLUENCE_USER}:${CONFLUENCE_GROUP} current/work

COPY confluence-server.xml /
COPY docker-entrypoint.sh /
VOLUME ${CONFLUENCE_HOME}
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR ${CONFLUENCE_INSTALL_DIR}/current/bin
EXPOSE 8090
CMD ./start-confluence.sh -fg
