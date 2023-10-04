FROM prom/blackbox-exporter:latest

COPY config.yml /etc/blackbox_exporter/config.yml

USER        root
EXPOSE      9115
ENTRYPOINT  [ "/bin/blackbox_exporter" ]
CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]
