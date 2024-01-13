ARG KASPAD_DOCKER_REPO
ARG KASPA_VERSION
ARG KCHECK_DOCKER_REPO
ARG KCHECK_VERSION

FROM $KASPAD_DOCKER_REPO:$KASPA_VERSION AS kaspad
FROM $KCHECK_DOCKER_REPO:$KCHECK_VERSION as kcheck

FROM haproxy:lts-alpine

ARG KASPAD_DOCKER_REPO
ARG KASPA_VERSION

EXPOSE 16110
EXPOSE 16111

WORKDIR /app

ENV PATH=/app:$PATH

USER root

RUN apk --no-cache add libgcc
COPY --from=kcheck /kcheck /app/kcheck
COPY is-synced-wrpc.sh /app/
RUN chmod 755 /app/is-synced-wrpc.sh

COPY --from=kaspad /app/kaspactl /app/
COPY is-synced.sh /app/
RUN chmod 755 /app/is-synced.sh

COPY haproxy.cfg /app/

USER haproxy

CMD ["/usr/local/sbin/haproxy", "-f", "/app/haproxy.cfg"]

