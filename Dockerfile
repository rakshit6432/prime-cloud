# Use an official PHP runtime as a parent image
FROM php:8.1-fpm-alpine

# Install necessary packages
RUN apk add --no-cache \
    bash \
    nginx \
    supervisor \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    zlib-dev \
    libxpm-dev \
    freetype-dev \
    libzip-dev \
    icu-dev \
    g++ \
    make \
    autoconf \
    openssl-dev

# Configure PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
    && docker-php-ext-install pdo_mysql gd zip intl opcache bcmath

# Install Node.js and NPM
RUN apk add --no-cache nodejs npm

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory
WORKDIR /var/www/html

# Copy the application files
COPY . .

# Install Laravel dependencies
RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist

# Build the Vue.js app
RUN npm install
RUN npm run production

# Expose ports
EXPOSE 80

# Start services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
