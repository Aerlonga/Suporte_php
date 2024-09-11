#!/bin/sh

# Navegue para o diretório de trabalho
cd /var/www/html

# Verifique se a pasta vendor não existe, então execute o composer install
if [ ! -d "vendor" ]; then
    composer install --optimize-autoloader --no-interaction
fi

# Execute a geração da chave do Laravel
php artisan key:generate --force

# Cria o schema em local apenas
# php artisan db:create-schema-gmm

php artisan migrate

php artisan db:seed

# Execute o PHP-FPM
php-fpm