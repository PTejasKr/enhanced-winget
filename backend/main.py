import asyncio,json
from typing import List
from fastapi import FastAPI,WebSocket,WebSocketDisconnect
import uvicorn
import scraper
import llm

app = FastAPI(title="Ew")

class ConnectionManager:
    def __init__(self): self.active: List[WebSocket] = []
    async def connect(self, ws: WebSocket):
        await ws.accept()
        self.active.append(ws)
    def disconnect(self, ws: WebSocket): self.active.remove(ws)
    async def broadcast(self, msg: str):
        for c in self.active:
            try: await c.send_text(msg)
            except: pass

manager = ConnectionManager()

@app.get("/")
def root(): return {"status": "ok"}

@app.websocket("/ws/updates")
async def ws_endpoint(ws: WebSocket):
    await manager.connect(ws)
    try:
        while True:
            data = await ws.receive_text()
            try:
                payload = json.loads(data)
                decision = llm.generate_llm_decision(
                    payload.get("app_name", "unknown"),
                    payload.get("versions", []),
                    scraper.aggregate_data(payload.get("app_name", "unknown"), payload.get("versions", []))
                )
                await ws.send_text(json.dumps(decision))
            except json.JSONDecodeError:
                await ws.send_text(json.dumps({"error": "invalid"}))
    except WebSocketDisconnect:
        manager.disconnect(ws)

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000)
