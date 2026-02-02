FROM mcr.microsoft.com/playwright:v1.40.0-jammy

WORKDIR /app

# O SEGREDO: Criamos um ambiente onde o NPM é obrigado a ser anônimo
RUN echo "registry=https://registry.npmjs.org/" > .npmrc

COPY package*.json ./

# Instalamos sem auditoria para evitar travar no token
RUN npm install --no-audit --no-fund

RUN npx playwright install chromium

COPY . .

EXPOSE 3000

# Comando que inicia o servidor via SSE para a Evo-AI
CMD ["npx", "-y", "@modelcontextprotocol/server-playwright", "--sse"]
