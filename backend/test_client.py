import asyncio
import websockets
import json

async def test_websocket():
    uri = "ws://localhost:8000/ws/updates"
    try:
        async with websockets.connect(uri) as websocket:
            print(f"Connected to {uri}")
            
            # Send a mock payload simulating a local daemon query
            payload = {
                "app_name": "Discord",
                "versions": [
                    {"repo": "winget", "version": "1.0.9015"},
                    {"repo": "scoop", "version": "1.0.9016"},
                    {"repo": "chocolatey", "version": "1.0.9015"}
                ]
            }
            
            print(f"Sending payload: {json.dumps(payload, indent=2)}")
            await websocket.send(json.dumps(payload))
            
            # Receive response
            response = await websocket.recv()
            print(f"Received decision: {json.dumps(json.loads(response), indent=2)}")
            
    except Exception as e:
        print(f"Connection failed: {e}")

if __name__ == "__main__":
    asyncio.run(test_websocket())
