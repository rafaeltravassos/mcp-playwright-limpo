# ESTÁGIO 1: O "Construtor" (Ambiente 100% limpo)
FROM node:20-slim AS builder
WORKDIR /app

# Forçamos o NPM a ignorar qualquer token global injetado pelo ambiente
ENV NPM_CONFIG_USERCONFIG=/tmp/.npmrc
RUN echo "registry=https://registry.npmjs.org/" > /tmp/.npmrc

# Instalamos o servidor em uma pasta isolada
RUN npm install @modelcontextprotocol/server-playwright

# ESTÁGIO 2: A "Execução" (Imagem do Playwright)
FROM mcr.microsoft.com/playwright:v1.40.0-jammy
WORKDIR /app

# Copiamos apenas a pasta node_modules pronta do estágio anterior
# Isso pula completamente o 'npm install' problemático nesta imagem
COPY --from=builder /app/node_modules ./node_modules

# Instalamos apenas os navegadores necessários (este comando não usa tokens de registro)
RUN npx playwright install chromium

# Configuração de porta para o Coolify
EXPOSE 3001

# Comando final usando o binário que já foi baixado no estágio anterior
CMD ["./node_modules/.bin/mcp-server-playwright", "--sse"]
