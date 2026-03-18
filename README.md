# NEXUS AI — A Multimodal AI Assistant  
_Think. Speak. See. Understand._

NEXUS AI is a **Tesla × Apple–inspired multimodal AI assistant** built with **Flutter** and a **FastAPI** backend. It combines **chat**, **voice**, and **vision** into a single, clean interface that runs on Android, iOS, and desktop.

This project is designed to showcase:
- Production‑grade **Flutter architecture** (Riverpod, clean layers, Drift, Dio, WebSockets)
- A **real streaming AI chat experience** with WebSocket token streaming
- Integrated **voice transcription + text‑to‑speech**
- **Vision** capabilities (image analysis) with efficient compression and upload
- A refined **UX / UI** inspired by **Apple** and **Tesla** product design

---

## ✨ Features

- **Multimodal AI**
  - 🧠 **Chat** – Streaming AI responses with typing indicators and message history
  - 🎙 **Voice** – Tap‑to‑record with waveform visualization, transcription, and TTS playback
  - 👁 **Vision** – Pick from gallery or capture from camera; images compressed and sent for analysis

- **Modern Flutter Stack**
  - **State management**: Riverpod (`flutter_riverpod`, `hooks_riverpod`, `riverpod_generator`)
  - **Navigation**: `go_router`
  - **Networking**: `dio` + custom retry interceptor + logging
  - **Streaming**: `web_socket_channel` with a dedicated `NexusWebSocketClient`
  - **Persistence**: `drift` + `sqlite3_flutter_libs` + `flutter_secure_storage`

- **Architecture & Code Quality**
  - Clean separation into **data / domain / presentation**
  - **Use cases** and **repositories** for chat, voice, and vision
  - Strong typing + `freezed` + `json_serializable`
  - Centralized logging via `talker_flutter`
  - Linting via `flutter_lints` and `analysis_options.yaml`

- **UI / UX**
  - Dark, minimal interface inspired by **Apple** and **Tesla**
  - Glassmorphism input dock, subtle gradients and glows
  - Elegant chat bubbles with asymmetric radii and streaming cursor
  - Responsive layout and smooth animations (`flutter_animate`, `shimmer`)

---

## 🧱 Project Structure

```text
.
├─ backend/                  # FastAPI-based backend (chat, voice, vision routes)
│  ├─ main.py                # ASGI app entry
│  └─ routers/
│     ├─ chat.py             # WebSocket chat endpoint with streaming
│     ├─ voice.py            # Transcribe + TTS endpoints
│     └─ vision.py           # Image analysis endpoint
│
├─ lib/
│  ├─ app/                   # Root app widget + router
│  ├─ core/
│  │  ├─ constants/          # App-wide constants (API URLs, layout, etc.)
│  │  ├─ error/              # Failure model & error handling
│  │  ├─ network/            # Dio client + WebSocket client
│  │  ├─ storage/            # Drift DB + secure storage
│  │  ├─ theme/              # Colors, typography, theme
│  │  ├─ utils/              # Logger, extensions
│  │  └─ widgets/            # Reusable UI components
│  │
│  └─ features/
│     ├─ chat/               # Chat feature (data/domain/presentation)
│     ├─ voice/              # Voice feature
│     └─ vision/             # Vision feature
│
├─ android/                  # Android platform code
├─ ios/                      # iOS platform code
├─ macos/                    # macOS platform code
├─ pubspec.yaml              # Flutter dependencies
└─ README.md
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter** SDK (compatible with `sdk: ^3.7.0` / `flutter: ">=3.29.0"`)
- **Dart** SDK (comes with Flutter)
- **Python 3.10+** for the backend
- An **LLM / Whisper / Vision** provider configured in the backend (via environment variables in `backend/.env`)

---

## ⚙️ Backend Setup (FastAPI)

1. Go to the backend folder:

```bash
cd backend
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

2. Configure environment (API keys, model, etc.):

```bash
cp .env.example .env
# Edit .env with your keys and model configuration
```

3. Run the backend (listening on `0.0.0.0:8000` so devices on the LAN can connect):

```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

You should now be able to open `http://localhost:8000/docs` in your browser to see the API docs.

---

## 📱 Flutter App Setup

1. From the project root:

```bash
flutter pub get
```

2. Configure API base URLs for your environment in:

```dart
// lib/core/constants/app_constants.dart
static const String _host = '192.168.1.15'; // Replace with your PC's IPv4
static const String _port = '8000';

static const String baseUrl = 'http://$_host:$_port';
static const String wsBaseUrl = 'ws://$_host:$_port';
```

- On **Android emulator**, `10.0.2.2` can be used.
- On a **physical phone**, use your machine’s **LAN IP** (same Wi‑Fi as phone).

3. Run the app:

```bash
flutter run
```

Select your target (Android, iOS simulator, etc.) and NEXUS AI will start.

---

## 🧠 Why This Project Stands Out

- **Real-world architecture**: Full multimodal AI assistant, not just a demo screen.
- **End-to-end ownership**: Flutter client, networking, WebSockets, persistence, and backend APIs.
- **Modern Flutter patterns**: Riverpod, clean architecture, use cases, repository pattern, async streaming.
- **Polished UX**: Careful typography, spacing, animations, and state transitions inspired by Apple/Tesla products.
- **AI integration experience**: Shows practical work with LLMs, transcription, and image analysis.

If you’re reviewing this as an HR / recruiter and want a quick walkthrough of the codebase or architecture, feel free to contact me.

---

## 📄 License

This project is public for portfolio and demonstration purposes.  
Please contact me before using it in commercial products or closed‑source forks.
