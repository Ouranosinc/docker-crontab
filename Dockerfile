FROM library/docker:stable

ENV HOME_DIR=/opt/crontab
RUN apk add --no-cache --virtual .run-deps gettext bash py3-toml py3-yaml python3 jq tini \
    && mkdir -p ${HOME_DIR}/jobs ${HOME_DIR}/projects \
    && adduser -S docker -D

COPY docker-entrypoint /
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint"]

HEALTHCHECK --interval=5s --timeout=3s \
    CMD ps aux | grep '[c]rond' || exit 1

CMD ["crond", "-f", "-d", "6", "-c", "/etc/crontabs"]
