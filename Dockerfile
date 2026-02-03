# ESTÁGIO 1: O "Builder" usando Yarn (mais robusto contra erros de token)
FROM node:20-slim AS builder
WORKDIR /app

# Removemos qualquer arquivo de configuração que possa ter vindo do seu GitHub
RUN rm -f .npmrc package-lock.json

# Instalamos o servidor usando Yarn apontando para o registro oficial
RUN yarn add @modelcontextprotocol/server-playwright --registry https://registry.npmjs.org/

# ESTÁGIO 2: A Imagem de Execução (Playwright)
FROM mcr.microsoft.com/playwright:v1.40.0-jammy
WORKDIR /app

# Copiamos apenas a pasta node_modules que o Yarn criou com sucesso
COPY --from=builder /app/node_modules ./node_modules

# Instalamos o navegador Chromium necessário
RUN npx playwright install chromium

# Porta configurada para o seu domínio navegador.zzapp.money
EXPOSE 3001

# Comando final chamando o executável local diretamente para evitar novas buscas na rede
CMD ["./node_modules/.bin/mcp-server-playwright", "--sse"]
