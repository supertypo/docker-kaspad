FROM alpine:latest

ARG VERSION

EXPOSE 16110
EXPOSE 16111

WORKDIR /app

ENV PATH=/app:$PATH

RUN mkdir -p /app/data/ && \
  adduser -h /app/data -S -D -u 51591 kaspad && \
  chown kaspad /app/data

RUN wget https://github.com/kaspanet/kaspad/releases/download/${VERSION}/kaspad-${VERSION}-linux.zip 2>&1 && \
  unzip kaspad-${VERSION}-linux.zip && \
  mv bin/kaspad bin/kaspactl ./ && \
  rm -r bin/ kaspad-${VERSION}-linux.zip

USER kaspad

CMD ["kaspad", "--utxoindex"]

