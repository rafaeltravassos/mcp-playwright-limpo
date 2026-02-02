FROM mcr.microsoft.com/playwright:v1.40.0-jammy
WORKDIR /app
COPY package*.json ./
# Comando para ignorar tokens expirados no seu servidor
RUN npm config set registry https://registry.npmjs.org/
RUN npm install --no-audit --no-fund
RUN npx playwright install chromium
COPY . .
EXPOSE 3000
CMD ["npx", "-y", "@modelcontextprotocol/server-playwright", "--sse"]
