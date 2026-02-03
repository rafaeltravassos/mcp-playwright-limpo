# ESTÁGIO 1: Construção em ambiente isolado e sem rastro de tokens
FROM node:20-slim AS builder

# Mudamos o HOME para uma pasta vazia. Isso mata qualquer .npmrc herdado
RUN mkdir /tmp/clean-home
ENV HOME=/tmp/clean-home
WORKDIR /app

# Forçamos o registro público e desativamos qualquer tentativa de autenticação
RUN npm config set registry https://registry.npmjs.org/ && \
    npm config set always-auth false

# Instalamos o servidor. Sem tokens, ele tratará o pacote como 100% público
RUN npm install @modelcontextprotocol/server-playwright --no-audit --no-fund

# ESTÁGIO 2: Imagem final do Playwright
FROM mcr.microsoft.com/playwright:v1.40.0-jammy
WORKDIR /app

# Copiamos a instalação limpa
COPY --from=builder /app/node_modules ./node_modules

# Instalamos o navegador (este comando não depende de tokens do npm)
RUN npx playwright install chromium

# Porta configurada no Coolify para o seu domínio navegador.zzapp.money
EXPOSE 3001

# Comando final chamando o executável diretamente
CMD ["./node_modules/.bin/mcp-server-playwright", "--sse"]
