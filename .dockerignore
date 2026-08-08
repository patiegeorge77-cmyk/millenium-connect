FROM richarvey/nginx-php-fpm:3.1.6

COPY . .

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

# Create the deploy script directly in the image, so it never depends on
# a file surviving a manual GitHub upload.
RUN mkdir -p scripts && \
    printf '%s\n' \
    '#!/usr/bin/env bash' \
    'echo "Running composer install..."' \
    'composer install --no-dev --working-dir=/var/www/html --no-interaction --optimize-autoloader' \
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
