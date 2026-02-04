# Estágio de Build
FROM node:20-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Estágio de Execução
FROM node:20-slim
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/build ./build
RUN npm install --omit=dev

# Configurações de Rede
ENV BROWSER_WS_ENDPOINT=ws://browserless-agencia:3000
EXPOSE 3001

# Comando de início
CMD ["node", "build/index.js"]
