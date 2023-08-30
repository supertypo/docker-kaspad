ARG KASPAD_DOCKER_REPO
ARG KASPA_VERSION

FROM $KASPAD_DOCKER_REPO:$KASPA_VERSION AS kaspad

FROM haproxy:lts-alpine

ARG KASPAD_DOCKER_REPO
ARG KASPA_VERSION

EXPOSE 16110
EXPOSE 16111

WORKDIR /app

ENV PATH=/app:$PATH

USER root

COPY --from=kaspad /app/kaspactl /app/

COPY is-synced.sh /app/
RUN chmod 755 /app/is-synced.sh

COPY haproxy.cfg /app/

USER haproxy

CMD ["/usr/local/sbin/haproxy", "-f", "/app/haproxy.cfg"]

