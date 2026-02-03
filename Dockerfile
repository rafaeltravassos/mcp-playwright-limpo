FROM mcr.microsoft.com/playwright:v1.40.0-jammy

WORKDIR /app

# 1. Força o uso do registro público e ignora qualquer token residual
ENV NPM_CONFIG_REGISTRY=https://registry.npmjs.org/
RUN npm config set auth-type legacy

# 2. Cria um package.json básico para garantir a instalação limpa
RUN echo '{"name": "mcp-server", "version": "1.0.0", "dependencies": {"@modelcontextprotocol/server-playwright": "latest"}}' > package.json

# 3. Instala o pacote explicitamente durante o Build (evita o erro do npx no boot)
RUN npm install --no-audit --no-fund

# 4. Instala os navegadores necessários
RUN npx playwright install chromium

# 5. Expõe a porta que configuramos no Coolify
EXPOSE 3001

# 6. Comando de inicialização usando o pacote já instalado localmente
CMD ["npx", "@modelcontextprotocol/server-playwright", "--sse"]
