FROM alpine:latest
MAINTAINER Tyler Baker <forcedinductionz@gmail.com>

ARG VERSION=2.0.2
ARG GLIBC_VERSION=2.28-r0

ENV FILENAME zcash-${VERSION}-linux64.tar.gz
ENV DOWNLOAD_URL https://z.cash/downloads/${FILENAME}
ENV LD_LIBRARY_PATH /usr/local/lib:/usr/lib

RUN apk update \
  && apk --no-cache add wget tar bash ca-certificates \
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-bin-${GLIBC_VERSION}.apk \
  && apk --no-cache add libgomp libstdc++ \
  && rm -rf /glibc-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
  && wget $DOWNLOAD_URL \
  && tar xzvf /$FILENAME \
  && mkdir /root/.zcash \
  && mv /zcash-${VERSION}/bin/* /usr/local/bin/ \
  && rm -rf /zcash-${VERSION}/ \
  && rm -rf /$FILENAME \
  && apk del tar wget ca-certificates

EXPOSE 8232 8233 18232 18133

ADD ./bin/docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
