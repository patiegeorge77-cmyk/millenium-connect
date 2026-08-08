FROM richarvey/nginx-php-fpm:3.1.6

# Image config
ENV SKIP_COMPOSER 0
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Laravel config
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr

# Allow composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /var/www/html

# Copy composer files first and install dependencies during the BUILD,
# not at container startup. This avoids relying on runtime memory/network
# and means every container boot already has a working vendor/ folder.
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --no-scripts --optimize-autoloader

# Now copy the rest of the application
COPY . .

# Re-run composer to trigger any post-install scripts now that all app
# files are present (artisan, etc.)
RUN composer dump-autoload --optimize

# Create the runtime deploy script (migrations/seed/cache only —
# no composer install here, since vendor/ is already baked into the image).
RUN mkdir -p scripts && \
    printf '%s\n' \
    '#!/usr/bin/env bash' \
    'echo "Caching config..."' \
    'php artisan config:cache' \
    'echo "Caching routes..."' \
    'php artisan route:cache' \
    'echo "Linking storage..."' \
    'php artisan storage:link || true' \
    'echo "Running migrations..."' \
    'php artisan migrate --force' \
    'echo "Seeding database..."' \
    'php artisan db:seed --force || true' \
    > scripts/00-laravel-deploy.sh && \
    chmod +x scripts/00-laravel-deploy.sh

CMD ["/start.sh"]
