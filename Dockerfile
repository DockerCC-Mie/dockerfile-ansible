FROM miraclemie/python:3.11-alpine

ENV ANSIBLE_CORE_VER=2.14.4
ENV EASZLAB_ANSIBLE_TAG=2.14.4-lite

RUN set -x \
       # Build dependencies
    && apk --no-cache add --virtual build-dependencies \
        gcc \
        musl-dev \
        python3-dev \
        libffi-dev \
        openssl-dev \
        cargo \
        build-base \
       # Useful tools
    && apk --no-cache add \
        bash \
        openssh-client \
        rsync \
    && pip install pip --upgrade \
    && pip install --no-cache-dir \
        ansible-core=="$ANSIBLE_CORE_VER" \
        ansible \
       # Remove unnecessary ansible packages
    && mv /usr/local/lib/python3.11/site-packages/ansible_collections/ansible /tmp \
    && mv /usr/local/lib/python3.11/site-packages/ansible_collections/community /tmp \
    && rm -rf /usr/local/lib/python3.11/site-packages/ansible_collections/* \
    && mv /tmp/ansible /tmp/community /usr/local/lib/python3.11/site-packages/ansible_collections \
    && mv /usr/local/lib/python3.11/site-packages/ansible_collections/community/crypto /tmp \
    && mv /usr/local/lib/python3.11/site-packages/ansible_collections/community/general /tmp \
    && mv /usr/local/lib/python3.11/site-packages/ansible_collections/community/network /tmp \
    && rm -rf /usr/local/lib/python3.11/site-packages/ansible_collections/community/* \
    && mv /tmp/crypto /tmp/general /tmp/network /usr/local/lib/python3.11/site-packages/ansible_collections/community/ \
       # Some module need '/usr/bin/python' exist
    && ln -s -f /usr/local/bin/python3.11 /usr/bin/python \
    && ln -s -f /usr/local/bin/python3.11 /usr/bin/python3 \
       # Cleaning
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* \
    && rm -rf /root/.cache \
    && rm -rf /root/.cargo

CMD [ "tail", "-f", "/dev/null" ]