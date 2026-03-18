// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — App Constants
// API endpoints, layout constants, animation durations
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract final class AppConstants {
  // ── App Info ──────────────────────────────────────────────
  static const String appName = 'NEXUS AI';
  static const String appTagline = 'Think. Speak. See. Understand.';
  static const String appVersion = '1.0.0';

  // ── API Endpoints ─────────────────────────────────────────
  // 💡 IMPORTANT FOR PHYSICAL DEVICES:
  // Replace the IP below with your **actual PC LAN IP** (e.g. 192.168.1.15)
  // so your phone can reach the backend over Wi‑Fi.
  // Find it with `ipconfig` on Windows (IPv4 Address).
  static const String _host = '192.168.1.15'; // TODO: set to your machine's IP
  static const String _port = '8000';

  static const String baseUrl = 'http://$_host:$_port';
  static const String wsBaseUrl = 'ws://$_host:$_port';

  // Desktop / iOS Simulator override
  static const String desktopBaseUrl = 'http://localhost:8000';
  static const String desktopWsBaseUrl = 'ws://localhost:8000';

  // Chat
  static const String chatWsEndpoint = '/chat/ws';

  // Voice
  static const String voiceTranscribeEndpoint = '/voice/transcribe';
  static const String voiceSynthesizeEndpoint = '/voice/synthesize';

  // Vision
  static const String visionAnalyzeEndpoint = '/vision/analyze';

  // ── Layout ────────────────────────────────────────────────
  static const double inputDockHeight = 72.0;
  static const double inputDockRadius = 28.0;
  static const double chatBubbleRadius = 18.0;
  static const double chatBubbleMaxWidth = 0.78; // % of screen width
  static const double avatarSize = 28.0;
  static const double headerHeight = 56.0;

  // ── Animation Durations ───────────────────────────────────
  static const Duration messageAnimDuration = Duration(milliseconds: 250);
  static const Duration scrollAnimDuration = Duration(milliseconds: 300);
  static const Duration cursorBlinkDuration = Duration(milliseconds: 530);
  static const Duration waveformInterval = Duration(milliseconds: 50);
  static const Duration typingIndicatorDuration = Duration(milliseconds: 600);

  // ── Image ─────────────────────────────────────────────────
  static const int imageMaxDimension = 1024;
  static const int imageQuality = 80;
  static const int maxImageAttachments = 5;

  // ── Storage Keys ──────────────────────────────────────────
  static const String apiKeyStorageKey = 'nexus_api_key';
  static const String sessionTokenKey = 'nexus_session_token';
  static const String lastConversationKey = 'last_conversation_id';
}
