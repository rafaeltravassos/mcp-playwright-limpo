FROM mcr.microsoft.com/playwright:v1.40.0-jammy
WORKDIR /app

# Blindagem contra o erro de token
RUN echo "registry=https://registry.npmjs.org/" > .npmrc

COPY package*.json ./
RUN npm install --no-audit --no-fund
RUN npx playwright install chromium

COPY . .

# Mudamos para a porta 3001 para não bater com o Browserless
EXPOSE 3001

# Comando de início com a porta corrigida
CMD ["npx", "-y", "@modelcontextprotocol/server-playwright", "--sse", "--port", "3001"]
