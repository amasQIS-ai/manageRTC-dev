// Simple test to check if server can start
import { config } from "dotenv";
config();

import express from "express";
import { createServer } from "http";

const app = express();
const httpServer = createServer(app);

const PORT = process.env.PORT || 5000;

app.get("/", (req, res) => {
  res.send("Test server running");
});

httpServer.listen(PORT, () => {
  console.log(`🚀 Test server running on port ${PORT}`);
});

console.log("Test server setup complete");
