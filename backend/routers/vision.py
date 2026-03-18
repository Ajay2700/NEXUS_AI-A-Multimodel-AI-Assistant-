# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# NEXUS AI — Vision Router
# GPT-4o Vision image analysis
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import os

from fastapi import APIRouter, HTTPException
from openai import AsyncOpenAI
from pydantic import BaseModel

router = APIRouter()


def get_openai_client() -> AsyncOpenAI:
    return AsyncOpenAI(api_key=os.getenv("OPENAI_API_KEY"))


class AnalyzeRequest(BaseModel):
    images: list[str]  # base64-encoded images
    prompt: str = "What do you see in this image?"


@router.post("/analyze")
async def analyze_image(request: AnalyzeRequest):
    """
    Analyze images using GPT-4o Vision.

    Accepts: {"images": ["base64..."], "prompt": "..."}
    Returns: {"analysis": "AI analysis text"}
    """
    client = get_openai_client()

    try:
        # Build content with images
        content: list[dict] = []
        content.append({"type": "text", "text": request.prompt})

        for img_b64 in request.images:
            content.append({
                "type": "image_url",
                "image_url": {
                    "url": f"data:image/jpeg;base64,{img_b64}"
                }
            })

        response = await client.chat.completions.create(
            model="gpt-4o",
            messages=[
                {"role": "user", "content": content}
            ],
            max_tokens=2048,
            temperature=0.5,
        )

        analysis = response.choices[0].message.content or ""
        return {"analysis": analysis}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
