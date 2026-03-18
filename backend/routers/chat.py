# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# NEXUS AI — Chat Router
# WebSocket endpoint for GPT-4o streaming
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import json
import os
from typing import Any

from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from openai import AsyncOpenAI

router = APIRouter()


def get_openai_client() -> AsyncOpenAI:
    return AsyncOpenAI(api_key=os.getenv("OPENAI_API_KEY"))


@router.websocket("/ws/{session_id}")
async def chat_websocket(websocket: WebSocket, session_id: str):
    """
    WebSocket endpoint for real-time chat streaming.

    Receives:
        {"content": "...", "history": [...], "images": [...]}

    Sends:
        {"type": "token", "content": "..."} — per token
        {"type": "done"} — stream complete
        {"type": "error", "content": "..."} — on error
    """
    await websocket.accept()

    try:
        while True:
            # Receive message from client
            raw = await websocket.receive_text()
            data: dict[str, Any] = json.loads(raw)

            content = data.get("content", "")
            history = data.get("history", [])
            images = data.get("images", [])

            # Build messages for OpenAI
            messages = []

            # Add history
            for msg in history:
                role = msg.get("role", "user")
                text = msg.get("content", "")
                messages.append({"role": role, "content": text})

            # Build current user message
            if images:
                # Vision request with images
                user_content: list[dict[str, Any]] = []
                if content:
                    user_content.append({"type": "text", "text": content})
                for img_b64 in images:
                    user_content.append({
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{img_b64}"
                        }
                    })
                messages.append({"role": "user", "content": user_content})
            else:
                messages.append({"role": "user", "content": content})

            # Stream response from GPT-4o
            try:
                client = get_openai_client()
                stream = await client.chat.completions.create(
                    model="gpt-4o",
                    messages=messages,
                    stream=True,
                    max_tokens=4096,
                    temperature=0.7,
                )

                async for chunk in stream:
                    delta = chunk.choices[0].delta
                    if delta.content:
                        await websocket.send_json({
                            "type": "token",
                            "content": delta.content,
                        })

                # Signal completion
                await websocket.send_json({"type": "done"})

            except Exception as e:
                await websocket.send_json({
                    "type": "error",
                    "content": str(e),
                })

    except WebSocketDisconnect:
        pass
    except Exception as e:
        try:
            await websocket.send_json({
                "type": "error",
                "content": f"Connection error: {str(e)}",
            })
        except Exception:
            pass
