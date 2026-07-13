import asyncio
import json
from typing import List, Dict, Any
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import uvicorn

import scraper
import llm

app = FastAPI(title="Ew - Cloud Brain API")

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            try:
                await connection.send_text(message)
            except Exception:
                pass

manager = ConnectionManager()

@app.get("/")
def read_root():
    return {"message": "Ew Cloud Brain is running"}

@app.websocket("/ws/updates")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            # Wait for message from client containing available updates
            data = await websocket.receive_text()
            try:
                payload = json.loads(data)
                app_name = payload.get("app_name", "unknown")
                versions = payload.get("versions", [])
                
                # Fetch aggregated community and news data
                aggregated_data = scraper.aggregate_data(app_name, versions)
                
                # Run the actual LLM scoring logic
                decision = llm.generate_llm_decision(app_name, versions, aggregated_data)
                
                # Send the decision back to the client
                await websocket.send_text(json.dumps(decision))
            except json.JSONDecodeError:
                await websocket.send_text(json.dumps({"error": "Invalid JSON"}))
    except WebSocketDisconnect:
        manager.disconnect(websocket)

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
