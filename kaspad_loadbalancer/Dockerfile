FROM haproxy:2.5.1-alpine

ARG KASPAD_VERSION

EXPOSE 16110
EXPOSE 16111

WORKDIR /app

ENV PATH=/app:$PATH

USER root

RUN cd /tmp && \
  wget https://github.com/kaspanet/kaspad/releases/download/${KASPAD_VERSION}/kaspad-${KASPAD_VERSION}-linux.zip 2>&1 && \
  unzip kaspad-${KASPAD_VERSION}-linux.zip && \
  mv bin/kaspactl /app/ && \
  rm -r bin/ kaspad-${KASPAD_VERSION}-linux.zip

COPY is-synced.sh /app/
RUN chmod 755 /app/is-synced.sh

COPY haproxy.cfg /app/

USER haproxy

CMD ["/usr/local/sbin/haproxy", "-f", "/app/haproxy.cfg"]

