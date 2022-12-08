FROM unifiedstreaming/mp4split:1.11.20

RUN apk update && apk add --update \
  bash \
  curl \
  python3 \
  py3-pip \
  jq

RUN pip install --upgrade pip
RUN pip install --upgrade awscli

RUN echo 'export $(strings /proc/1/environ | grep AWS_CONTAINER_CREDENTIALS_RELATIVE_URI)' >> /root/.profile
ADD ./entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]