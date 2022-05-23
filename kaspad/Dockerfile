FROM alpine:latest

ARG REPO_URL
ARG KASPAD_VERSION

ENV KASPAD_URL=${REPO_URL}/releases/download/${KASPAD_VERSION}/kaspad-${KASPAD_VERSION}-linux.zip

EXPOSE 16110
EXPOSE 16111

WORKDIR /app

ENV PATH=/app:$PATH

RUN mkdir -p /app/data/ && \
  adduser -h /app/data -S -D -u 51591 kaspad && \
  chown kaspad /app/data

RUN cd /tmp && \
  wget ${KASPAD_URL} 2>&1 && \
  unzip kaspad-${KASPAD_VERSION}-linux.zip && \
  cp bin/kaspad bin/kaspactl /app/ && \
  rm -r bin/ kaspad-${KASPAD_VERSION}-linux.zip

USER kaspad

CMD ["/app/kaspad", "--utxoindex"]

