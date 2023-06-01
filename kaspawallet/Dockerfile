FROM alpine:latest

ARG REPO_URL
ARG KASPAD_VERSION

ENV KASPAD_URL=${REPO_URL}/releases/download/${KASPAD_VERSION}/kaspad-${KASPAD_VERSION}-linux.zip \
  KASPAD=kaspad:16110

EXPOSE 8082

WORKDIR /app

ENV PATH=/app:$PATH

RUN mkdir -p /app/data/ && \
  adduser -h /app/data -S -D -u 51591 kaspawallet && \
  chown kaspawallet /app/data

RUN cd /tmp && \
  wget ${KASPAD_URL} 2>&1 && \
  unzip kaspad-${KASPAD_VERSION}-linux.zip && \
  cp bin/kaspawallet /app/ && \
  rm -r bin/ kaspad-${KASPAD_VERSION}-linux.zip

USER kaspawallet

CMD /app/kaspawallet start-daemon --listen=0.0.0.0:8082 --rpcserver=$KASPAD

