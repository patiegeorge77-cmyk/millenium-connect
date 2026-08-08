FROM webdevops/php-nginx:8.4-alpine

# Laravel needs these PHP extensions; the base image doesn't ship all of them
RUN apk add --no-cache postgresql-dev libzip-dev icu-dev oniguruma-dev && \
    docker-php-ext-install \
    bcmath \
    ctype \
    fileinfo \
    mbstring \
    pdo_pgsql \
    pgsql \
    tokenizer \
    xml \
    intl \
    zip \
    opcache

ENV WEB_DOCUMENT_ROOT=/app/public
ENV APP_ENV=production

WORKDIR /app

# Install PHP dependencies first (better layer caching, and this is the
# actual build-time step — nothing depends on it succeeding at runtime).
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --no-scripts --optimize-autoloader

# Now copy the rest of the app
COPY . .
RUN composer dump-autoload --optimize

# At container startup: cache config/routes, link storage, run migrations
# and seed the DB, then hand off to the base image's normal nginx+php-fpm
# process manager (supervisord) so the server actually starts serving.
CMD ["/bin/sh", "-c", "php artisan config:cache && php artisan route:cache && php artisan storage:link || true && php artisan migrate --force && php artisan db:seed --force || true && exec supervisord"]
