# ESTÁGIO 1: O "Builder" em ambiente limpo
FROM node:20-slim AS builder
WORKDIR /app

# Criamos um arquivo de configuração local que anula qualquer configuração global
RUN echo "registry=https://registry.npmjs.org/" > .npmrc

# Instalamos o servidor usando o registro oficial diretamente no comando
RUN npm install @modelcontextprotocol/server-playwright --registry=https://registry.npmjs.org/ --no-audit --no-fund

# ESTÁGIO 2: A Imagem de Execução (Playwright)
FROM mcr.microsoft.com/playwright:v1.40.0-jammy
WORKDIR /app

# Copiamos apenas a pasta node_modules que foi baixada com sucesso
COPY --from=builder /app/node_modules ./node_modules

# Instalamos o navegador Chromium (este comando não usa o registro npm)
RUN npx playwright install chromium

# Porta configurada no Coolify para o seu domínio navegador.zzapp.money
EXPOSE 3001

# Comando final chamando o executável local diretamente
CMD ["./node_modules/.bin/mcp-server-playwright", "--sse"]
