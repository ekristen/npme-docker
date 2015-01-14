############################################################
# Run an npm Enterprise server as a docker container.
#
# 1. signup for a license: https://www.npmjs.org/enterprise
# 2. run: npm install; npm run-script configure
# 3. run: docker build -t npme .
# 4. run: docker run -p 8080:8080 -t npme
#
# (c) 2014 - npm, Inc see LICENSE.txt
############################################################

# Set the base image to Ubuntu
FROM bcoe/npme

# File Author / Maintainer
MAINTAINER Ben Coe

# Copy configuration/license and upgrade npm Enterprise.
RUN echo "\n\n--- IMPORTANT ---\nabout to copy configuration, make sure:\n\t1. you visit https://www.npmjs.org/enterprise and fetch a license, and\n\t2. run 'npm install; npm run-script configure'\n----------------\n\n"

COPY service.json /etc/npme/service.json
COPY .license.json /etc/npme/.license.json
COPY .ndmrc /etc/npme/.ndmrc
RUN npm install ndm -g
RUN rm -rf /etc/npme/node_modules/@npm
RUN npme update
RUN cd /etc/npme; ndm generate --uid=root --gid=root --platform=initd
RUN cp -R /etc/npme/ /etc/npme_original

COPY run.sh /run.sh

# Expose ports
EXPOSE 8080

# Set the default directory where CMD will execute
WORKDIR /etc/npme

VOLUME /etc/npme

CMD ["/run.sh"]
