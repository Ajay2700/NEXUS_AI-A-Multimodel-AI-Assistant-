# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# NEXUS AI — Voice Router
# Whisper transcription + TTS-1-HD synthesis
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import os
import tempfile

from fastapi import APIRouter, File, UploadFile, HTTPException
from fastapi.responses import StreamingResponse
from openai import AsyncOpenAI
from pydantic import BaseModel

router = APIRouter()


def get_openai_client() -> AsyncOpenAI:
    return AsyncOpenAI(api_key=os.getenv("OPENAI_API_KEY"))


@router.post("/transcribe")
async def transcribe_audio(file: UploadFile = File(...)):
    """
    Transcribe audio using Whisper.

    Accepts: audio file upload (m4a, mp3, wav, etc.)
    Returns: {"text": "transcribed text"}
    """
    client = get_openai_client()

    try:
        # Save uploaded file to temp location
        suffix = os.path.splitext(file.filename or "audio.m4a")[1]
        with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
            content = await file.read()
            tmp.write(content)
            tmp_path = tmp.name

        # Transcribe with Whisper
        with open(tmp_path, "rb") as audio_file:
            transcription = await client.audio.transcriptions.create(
                model="whisper-1",
                file=audio_file,
                response_format="text",
            )

        # Cleanup
        os.unlink(tmp_path)

        return {"text": transcription}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


class SynthesizeRequest(BaseModel):
    text: str
    voice: str = "nova"


@router.post("/synthesize")
async def synthesize_speech(request: SynthesizeRequest):
    """
    Synthesize text to speech using TTS-1-HD.

    Accepts: {"text": "...", "voice": "nova"}
    Returns: audio/mpeg stream
    """
    client = get_openai_client()

    try:
        response = await client.audio.speech.create(
            model="tts-1-hd",
            voice=request.voice,  # type: ignore
            input=request.text,
            response_format="mp3",
        )

        async def audio_stream():
            async for chunk in response.aiter_bytes(1024):
                yield chunk

        return StreamingResponse(
            audio_stream(),
            media_type="audio/mpeg",
            headers={
                "Content-Disposition": "attachment; filename=speech.mp3"
            },
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
