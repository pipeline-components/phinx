FROM composer:1.8 as build

COPY app/ /app/
RUN composer install --no-interaction --no-scripts --no-progress --optimize-autoloader 
WORKDIR /app/

FROM php:7.3.5-alpine3.8

RUN docker-php-ext-install mysqli && \
    docker-php-ext-install pdo_mysql

ENV PATH "$PATH:/app/vendor/bin/"
COPY --from=build /app/ /app/

WORKDIR /code/
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.label-schema.description="Phinx in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Phinx" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/phinx/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/phinx/" \
    org.label-schema.vendor="Pipeline Components"