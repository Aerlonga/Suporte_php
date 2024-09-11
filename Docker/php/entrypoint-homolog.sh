#!/bin/sh

# Navegue para o diretório de trabalho
cd /var/www/html

# Verifique se a pasta vendor não existe, então execute o composer install
if [ ! -d "vendor" ]; then
    composer install --optimize-autoloader --no-interaction
fi

# Execute a geração da chave do Laravel
php artisan key:generate --force

if [ -f "public/hot" ]; then
    rm public/hot
fi

# Verifique se o arquivo foi excluído com sucesso
if [ -f "public/hot" ]; then
    echo "O arquivo public/hot não foi excluído."
else
    echo "O arquivo public/hot foi excluído com sucesso."
fi

php artisan migrate

php artisan db:seed

# Execute o PHP-FPM
php-fpm