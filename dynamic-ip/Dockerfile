# Pulling Ubuntu image
FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install cron curl jq -y && \
    rm -rf /var/lib/apt/lists/*

COPY script.sh .
COPY entrypoint.sh .

RUN chmod +x script.sh entrypoint.sh

ADD crontab /etc/cron.d/script

RUN chmod 0644 /etc/cron.d/script && crontab /etc/cron.d/script

ENTRYPOINT ["/entrypoint.sh"]
