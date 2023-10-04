FROM alpine:latest AS build

WORKDIR /tmp/

ARG remote_write_url
ENV REMOTE_WRITE_URL=${remote_write_url}

ARG remote_username
ENV REMOTE_USERNAME=${remote_username}

ARG remote_password
ENV REMOTE_PASSWORD=${remote_password}

RUN apk update && apk --no-cache add gettext
COPY .local/prometheus.yml.template prometheus.yml.template
RUN envsubst <prometheus.yml.template> prometheus.yml

FROM prom/prometheus:latest

WORKDIR /etc/prometheus/

COPY --from=build /tmp/prometheus.yml prometheus.yml
COPY hosts hosts
COPY rules rules

EXPOSE 9090
ENTRYPOINT [ "/bin/prometheus" ]
CMD [ "--config.file=/etc/prometheus/prometheus.yml", \
    "--storage.tsdb.path=/prometheus", \
    "--web.console.libraries=/usr/share/prometheus/console_libraries", \
    "--web.console.templates=/usr/share/prometheus/consoles" ]
