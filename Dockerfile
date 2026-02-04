FROM node:20-slim
WORKDIR /app

# Copia os arquivos de configuração
COPY package*.json ./
RUN npm install

# Copia o código do servidor
COPY index.js ./

# Configurações de Rede
ENV BROWSER_WS_ENDPOINT=ws://browserless-agencia:3000
EXPOSE 3001

# Inicia o servidor sem argumentos extras para evitar erros
CMD ["node", "index.js"]
