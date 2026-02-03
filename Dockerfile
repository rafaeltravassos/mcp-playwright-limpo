FROM mcr.microsoft.com/playwright:v1.40.0-jammy

WORKDIR /app

# 1. Remove qualquer configuração residual de usuário que possa ter tokens velhos
RUN rm -f /root/.npmrc && rm -f ~/.npmrc

# 2. Define o registro oficial de forma global
RUN npm config set registry https://registry.npmjs.org/

# 3. O TRUQUE: Define um token vazio para o registro. Isso mata o erro de "Access token expired"
RUN npm config set //registry.npmjs.org/:_authToken ""

# 4. Instala o servidor diretamente (sem npx no build para evitar o loop de auth)
RUN npm install @modelcontextprotocol/server-playwright --no-save --no-package-lock

# 5. Instala os navegadores do Playwright
RUN npx playwright install chromium

# Porta configurada no Coolify
EXPOSE 3001

# 6. Comando de execução garantindo que ele não tente baixar nada novamente
CMD ["npx", "-y", "@modelcontextprotocol/server-playwright", "--sse"]
