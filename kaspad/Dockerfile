##
# builder image
##
FROM golang:1.20 as builder

ARG REPO_DIR

COPY "$REPO_DIR" /kaspa

WORKDIR /kaspa

RUN go install -ldflags="-s -w -extldflags=-static" -tags netgo,osusergo . ./cmd/...

##
# kaspad image
##
FROM alpine:latest

ARG REPO_URL
ARG KASPA_VERSION

ENV REPO_URL="$REPO_URL" \
  KASPA_VERSION="$KASPA_VERSION" \
  KASPA_USER=kaspa \
  KASPA_HOME=/app/data \
  KASPA_UID=51591 \
  PATH=/app:$PATH

RUN apk --no-cache add \
  libgcc \
  libstdc++ \
  bind-tools \
  su-exec \
  grep

WORKDIR /app

RUN mkdir $KASPA_HOME && \
  addgroup -S -g $KASPA_UID $KASPA_USER && \
  adduser -h $KASPA_HOME -S -D -g '' -G $KASPA_USER -u $KASPA_UID $KASPA_USER

COPY ./entrypoint.sh /app/

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 16111 16110
VOLUME /app/data

COPY --from=builder /go/bin/kaspad /go/bin/kaspactl /app/

CMD ["kaspad", "--utxoindex"]

