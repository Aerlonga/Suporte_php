# Use a imagem oficial do Node.js como base
FROM node:latest

ARG APP_ENV

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /var/www/html

# Copie o package.json e o package-lock.json para o diretório de trabalho
COPY package.json package-lock.json ./

# Instale as dependências do projeto
RUN npm install 

# Copie o script de entrada para o contêiner
COPY ./Docker/node/entrypoint-${APP_ENV}.sh /usr/local/bin/entrypoint.sh

# Dê permissão de execução ao script de entrada
RUN chmod +x /usr/local/bin/entrypoint.sh

# Defina o script de entrada como ponto de entrada
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]