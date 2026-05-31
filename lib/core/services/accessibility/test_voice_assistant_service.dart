import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TestVoiceAssistantService {
  final FlutterTts _tts = FlutterTts();

  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _ignoreNextCancel = false;
  VoidCallback? onCompleted;
  VoidCallback? onCancelled;
  VoidCallback? onError;

  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    if (_isInitialized) return;

    //await _tts.awaitSpeakCompletion(true);

    await _tts.setLanguage('ar-SA');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _tts.setStartHandler(() {
      _isSpeaking = true;
      debugPrint('✓ TTS started');
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      debugPrint('✓ TTS completed');
      onCompleted?.call();
    });

    _tts.setCancelHandler(() {
      _isSpeaking = false;
      debugPrint('✓ TTS cancelled');

      if (_ignoreNextCancel) {
        _ignoreNextCancel = false;
        return;
      }

      onCancelled?.call();
    });

    _tts.setErrorHandler((message) {
      _isSpeaking = false;
      debugPrint('✗ TTS error: $message');
      onError?.call();
    });

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty) return;

    await init();

    if (_isSpeaking) {
      _ignoreNextCancel = true;
      await _tts.stop();
    }


    debugPrint('============ TestVoiceAssistantService.speak ============');
    debugPrint(cleanText);
    debugPrint('=========================================================');

    await _tts.speak(cleanText);
  }

  Future<void> stop() async {
    if (!_isInitialized) return;

    _ignoreNextCancel = false;
    await _tts.stop();
    _isSpeaking = false;
  }

  Future<void> dispose() async {
    await stop();
  }
}
