FROM alpine:latest

ARG VERSION

EXPOSE 16110
EXPOSE 16111

RUN mkdir -p /app/data/ && \
  adduser -h /app/data -S -D -u 51591 kaspad && \
  chown kaspad /app/data

WORKDIR /app

RUN wget https://github.com/kaspanet/kaspad/releases/download/${VERSION}/kaspad-${VERSION}-linux.zip 2>&1 && \
  unzip kaspad-${VERSION}-linux.zip && \
  mv bin/kaspad ./ && \
  rm -r bin/ && \
  rm kaspad-${VERSION}-linux.zip

USER kaspad

CMD ["/app/kaspad", "--utxoindex"]

