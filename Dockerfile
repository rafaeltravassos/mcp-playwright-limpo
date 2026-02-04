import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js";
import express from "express";
import { chromium } from "playwright-core";

const app = express();
const BROWSER_WS_ENDPOINT = process.env.BROWSER_WS_ENDPOINT || "ws://browserless-agencia:3000";

const server = new Server({
    name: "zzapp-playwright-agencia",
    version: "1.0.0",
}, {
    capabilities: { tools: {} },
});

// Handler SSE para manter a conexão ativa
let transport: SSEServerTransport | null = null;

app.get("/sse", async (req, res) => {
    console.log("Novo cliente de IA conectado via SSE");
    transport = new SSEServerTransport("/messages", res);
    await server.connect(transport);
});

app.post("/messages", async (req, res) => {
    if (transport) {
        await transport.handlePostMessage(req, res);
    }
});

// Adicione aqui os seus handlers de ferramentas (navigate, screenshot, etc)

const PORT = 3001;
app.listen(PORT, () => {
    console.log(`🚀 Motorista da Agência pronto na porta ${PORT}`);
});
