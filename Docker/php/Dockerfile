# Use a imagem PHP 8.2-fpm como base
FROM php:8.2-fpm

ARG APP_ENV

# Instalação de dependências e ferramentas utilizadas posteriormente
RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        gnupg2 \
        libpng-dev \
        libzip-dev \
        zip \
        unzip \
        git \
        nano \
        zlib1g-dev \
        unixodbc \
        unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

ENV ACCEPT_EULA=Y
# Adição da chave e repositório do Microsoft SQL Server para instalação do sqlsrv e pdo_sqlsrv
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && apt-get install -y \
    mssql-tools \
    && rm -rf /var/lib/apt/lists/*

# Configuração e instalação do pdo_odbc
RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
    && docker-php-ext-install pdo_odbc

# Cópia do script utilizado para instalação de extensões PHP
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/install-php-extensions

# Instalação de extensões PHP necessárias e suas dependências via apt
RUN chmod uga+x /usr/bin/install-php-extensions \
    && sync \
    && install-php-extensions \
        bcmath \
        ds \
        exif \
        gd \
        intl \
        opcache \
        pcntl \
        redis \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Instalação das extensões sqlsrv e pdo_sqlsrv
RUN pecl install sqlsrv-5.10.1 \
    && pecl install pdo_sqlsrv-5.10.1 \
    && install-php-extensions sqlsrv pdo_sqlsrv

# Instale as bibliotecas do SQLite e MySQL
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    libsqlite3-0    

# Instale as extensões PDO para SQLite e MySQL
RUN docker-php-ext-install pdo_mysql pdo_sqlite mysqli

# Instalação da extensão LDAP
# RUN apt-get update \
#     && apt-get install -y \
#         libldap2-dev \
#     && rm -rf /var/lib/apt/lists/* \
#     && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
#     && docker-php-ext-install ldap

# Instalação das ferramentas e extensões adicionais do Microsoft SQL Server
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
    && echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc \
    && rm -rf /var/lib/apt/lists/*

# Verifique se os diretórios de cache e logs existem e, se não existirem, crie-os e defina as permissões
RUN mkdir -p storage/framework/{sessions,views,cache} \
    && mkdir -p storage/logs \
    && chown -R www-data:www-data storage

# Verifique se o diretório do log do Xdebug existe e, se não existir, crie-o e defina as permissões
RUN if [ ! -d /var/log/xdebug ]; then mkdir -p /var/log/xdebug && chmod -R 777 /var/log/xdebug; fi

# Ativando e instalando o XDebug
ADD ./Docker/php/xdebug.ini "/usr/local/etc/php/conf.d/xdebug.ini"
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# # Instala as dependências da wkhtmltopdf
RUN apt-get update && apt-get install -y fontconfig libfreetype6 libjpeg62-turbo \
    libxrender1 xfonts-75dpi xfonts-base

RUN curl -sLO http://ftp.us.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1w-0+deb11u1_amd64.deb \
&& dpkg -i libssl1.1_1.1.1w-0+deb11u1_amd64.deb \
&& rm libssl1.1_1.1.1w-0+deb11u1_amd64.deb

# # Instala a wkhtmltopdf
RUN curl -LO https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_amd64.deb && \
    dpkg -i wkhtmltox_0.12.6.1-2.bullseye_amd64.deb && \
    apt-get --fix-broken install -y && \
    rm wkhtmltox_0.12.6.1-2.bullseye_amd64.deb && \
    which wkhtmltopdf

# Instale o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Defina o diretório de trabalho como /var/www/html
WORKDIR /var/www/html

# Copie o conteúdo do diretório atual (onde está o Dockerfile) para /var/www/html no contêiner
COPY . /var/www/html

# Copie o script de entrada para o contêiner
COPY ./Docker/php/entrypoint-${APP_ENV}.sh /usr/local/bin/entrypoint.sh

# Dê permissão de execução ao script de entrada
RUN chmod +x /usr/local/bin/entrypoint.sh

# Defina o ponto de entrada
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
