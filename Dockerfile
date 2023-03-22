FROM php:8.1.0-apache

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql mysqli gd zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/

# Copy the application files
COPY . .


# Expose ports
EXPOSE 8000
