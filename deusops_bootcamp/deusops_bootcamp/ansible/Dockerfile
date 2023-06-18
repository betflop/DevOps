FROM python:3-alpine
LABEL vendor1="DeusOps"
LABEL vendor2="Konstantin Deepezh aka D3pRe5s"

ENV ANSIBLE_FORCE_COLOR="true"
ENV ANSIBLE_HOST_KEY_CHECKING="false"
ENV ANSIBLE_CONFIG="/ansible.cfg"

COPY ansible.cfg entrypoint.sh /

RUN apk add --update --no-cache \
    git \
    openssh-client \
    rsync \
    libffi-dev \
    musl-dev 

RUN mkdir ~/.ssh && \
    ssh-keyscan -t rsa gitlab.com >> ~/.ssh/known_hosts

RUN apk add --update --no-cache \
    --virtual .build-deps \
    make \
    gcc \
    && pip install --no-cache-dir ansible \
    && apk del .build-deps

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
