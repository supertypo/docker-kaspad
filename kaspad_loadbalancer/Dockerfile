FROM haproxy:latest

ARG KASPAD_VERSION

EXPOSE 16110
EXPOSE 16111

WORKDIR /app

ENV PATH=/app:$PATH

USER root

RUN apt-get update && apt-get install -y \
  wget \
  unzip \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/kaspanet/kaspad/releases/download/${KASPAD_VERSION}/kaspad-${KASPAD_VERSION}-linux.zip 2>&1 && \
  unzip kaspad-${KASPAD_VERSION}-linux.zip && \
  mv bin/kaspactl ./ && \
  rm -r bin/ kaspad-${KASPAD_VERSION}-linux.zip

COPY is-synced.sh /app/
RUN chmod 755 /app/is-synced.sh

COPY haproxy.cfg /app/

USER haproxy

CMD ["/usr/local/sbin/haproxy", "-f", "/app/haproxy.cfg"]

