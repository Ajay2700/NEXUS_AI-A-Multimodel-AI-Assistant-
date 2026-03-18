# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# NEXUS AI — FastAPI Backend
# Main application entry point with CORS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import os
from contextlib import asynccontextmanager

from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Load .env file (must be before any os.getenv calls)
load_dotenv()

from routers import chat, voice, vision


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan: startup/shutdown events."""
    # Startup
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        print("⚠️  WARNING: OPENAI_API_KEY not set. AI features will fail.")
    else:
        print("✅ OpenAI API key loaded")
    yield
    # Shutdown
    print("🛑 NEXUS AI Backend shutting down")


app = FastAPI(
    title="NEXUS AI Backend",
    description="FastAPI backend for NEXUS AI multimodal assistant",
    version="1.0.0",
    lifespan=lifespan,
)

# ── CORS ─────────────────────────────────────────────────────
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, restrict to app domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Routers ──────────────────────────────────────────────────
app.include_router(chat.router, prefix="/chat", tags=["Chat"])
app.include_router(voice.router, prefix="/voice", tags=["Voice"])
app.include_router(vision.router, prefix="/vision", tags=["Vision"])


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "service": "nexus-ai-backend"}
