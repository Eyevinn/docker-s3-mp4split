FROM unifiedstreaming/mp4split:1.11.20

RUN apk update && apk add --update \
  bash \
  curl \
  python3 \
  py3-pip

RUN pip install --upgrade pip
RUN pip install --upgrade awscli

ADD ./entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]