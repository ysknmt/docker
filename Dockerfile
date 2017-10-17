FROM node:6-slim

ARG VERSION=3.2.2
LABEL version=$VERSION

# Workaround for aufs (refs: https://qiita.com/muddydixon/items/7e7fa0c58d0fe495ce07)
RUN cd $(npm root -g)/npm \
        && npm install fs-extra \
        && sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.rename/fs.move/ ./lib/utils/rename.js
RUN npm install --global gitbook-cli &&\
	gitbook fetch ${VERSION} &&\
	npm cache clear &&\
	rm -rf /tmp/*

WORKDIR /srv/gitbook
VOLUME /srv/gitbook /srv/html
EXPOSE 4000 35729
CMD /usr/local/bin/gitbook serve
