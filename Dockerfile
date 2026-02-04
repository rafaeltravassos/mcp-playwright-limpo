FROM node:20-slim
WORKDIR /app

# Instalação direta da fonte oficial para evitar pacotes quebrados
RUN npm install -g @playwright/mcp@latest

# Variáveis de Ambiente da Agência
ENV BROWSER_WS_ENDPOINT=ws://browserless-agencia:3000
ENV MCP_PLAYWRIGHT_PERSISTENCE_PATH=/app/storage/auth.json

# Criação da pasta para cookies e sessões da ZZapp Money
RUN mkdir -p /app/storage

# Comando para iniciar com todas as ferramentas habilitadas
CMD ["npx", "@playwright/mcp", "run"]
