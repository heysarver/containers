ARG TAG_NAME

# Build stage
FROM wordpress:${TAG_NAME}-apache AS build

USER root

RUN apt-get update && apt-get upgrade -y && \
    apt-get -y install autoconf build-essential liblz4-dev libzstd-dev

RUN /usr/local/bin/pecl install igbinary msgpack
RUN /usr/bin/printf "yes\nyes\nyes\nyes\nyes\nyes\n" | /usr/local/bin/pecl install --onlyreqdeps redis

# Final stage
FROM wordpress:${TAG_NAME}-apache

USER root

COPY --from=build /usr/local/lib/php/extensions/*/igbinary.so /usr/local/lib/php/extensions/no-debug-non-zts-20220829/
COPY --from=build /usr/local/lib/php/extensions/*/msgpack.so /usr/local/lib/php/extensions/no-debug-non-zts-20220829/
COPY --from=build /usr/local/lib/php/extensions/*/redis.so /usr/local/lib/php/extensions/no-debug-non-zts-20220829/

RUN echo "extension=igbinary.so" > /usr/local/etc/php/conf.d/igbinary.ini \
    && echo "extension=msgpack.so" > /usr/local/etc/php/conf.d/msgpack.ini \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini
