import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js";
import express from "express";
import { chromium } from "playwright-core";

const app = express();
const BROWSER_WS_ENDPOINT = process.env.BROWSER_WS_ENDPOINT || "ws://browserless-agencia:3000";

const server = new Server({
    name: "zzapp-playwright",
    version: "1.0.0",
}, {
    capabilities: { tools: {} },
});

// Transporte SSE para manter o serviço VIVO e VERDE
let transport = null;

app.get("/sse", async (req, res) => {
    console.log("🚀 Agente de IA conectado!");
    transport = new SSEServerTransport("/messages", res);
    await server.connect(transport);
});

app.post("/messages", async (req, res) => {
    if (transport) {
        await transport.handlePostMessage(req, res);
    }
});

const PORT = 3001;
app.listen(PORT, () => {
    console.log(`✅ Servidor da Agência rodando na porta ${PORT}`);
});
