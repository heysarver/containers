ARG TAG_NAME

# Build stage
FROM bitnami/wordpress:${TAG_NAME} AS build

USER root

RUN apt-get update && apt-get upgrade -y && \
    apt-get -y install autoconf build-essential

RUN /opt/bitnami/php/bin/pecl install redis

# Final stage
FROM bitnami/wordpress:${TAG_NAME}

USER root

COPY --from=build /opt/bitnami/php/lib/php/extensions/redis.so /opt/bitnami/php/lib/php/extensions/redis.so

RUN echo 'extension=redis.so' >> /opt/bitnami/php/etc/php.ini

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wordpress/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]
