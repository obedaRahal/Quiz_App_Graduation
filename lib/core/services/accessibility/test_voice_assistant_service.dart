import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TestVoiceAssistantService {
  static const String _preferredArabicLocale = 'ar-SA';

  final FlutterTts _tts = FlutterTts();

  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _ignoreNextCancel = false;
  String? _lastErrorMessage;
  VoidCallback? onCompleted;
  VoidCallback? onCancelled;
  VoidCallback? onError;

  bool get isSpeaking => _isSpeaking;
  String? get lastErrorMessage => _lastErrorMessage;

  Future<void> init() async {
    if (_isInitialized) return;

    await _configureArabicVoice();
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _tts.setStartHandler(() {
      _isSpeaking = true;
      _lastErrorMessage = null;
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
      _lastErrorMessage = _resolveErrorMessage(message);
      debugPrint('✗ TTS error: $message');
      debugPrint('→ $_lastErrorMessage');
      onError?.call();
    });

    _isInitialized = true;
  }

  Future<void> _configureArabicVoice() async {
    await _tts.setLanguage(_preferredArabicLocale);

    try {
      final rawVoices = await _tts.getVoices;
      if (rawVoices is! List) return;

      final arabicVoices = rawVoices
          .whereType<Map>()
          .where((voice) => _isArabicLocale(voice['locale']))
          .toList(growable: false);
      final offlineArabicVoices = arabicVoices
          .where(
            (voice) => !_requiresNetwork(voice) && _isVoiceDataInstalled(voice),
          )
          .toList(growable: false);

      if (offlineArabicVoices.isEmpty) {
        debugPrint('⚠ No offline Arabic TTS voice is installed');
        return;
      }

      final selectedVoice = offlineArabicVoices.firstWhere(
        (voice) => _normalizeLocale(voice['locale']) == 'ar-sa',
        orElse: () => offlineArabicVoices.first,
      );
      final voiceName = selectedVoice['name']?.toString();
      final voiceLocale = selectedVoice['locale']?.toString();

      if (voiceName == null ||
          voiceName.isEmpty ||
          voiceLocale == null ||
          voiceLocale.isEmpty) {
        return;
      }

      final result = await _tts.setVoice({
        'name': voiceName,
        'locale': voiceLocale,
      });

      if (result == 1) {
        debugPrint('✓ Offline Arabic TTS voice selected');
        debugPrint('→ name: $voiceName');
        debugPrint('→ locale: $voiceLocale');
      }
    } catch (error) {
      debugPrint('⚠ Could not select an offline Arabic TTS voice: $error');
    }
  }

  bool _isArabicLocale(Object? locale) {
    final normalizedLocale = _normalizeLocale(locale);
    return normalizedLocale == 'ar' || normalizedLocale.startsWith('ar-');
  }

  String _normalizeLocale(Object? locale) {
    return locale?.toString().trim().replaceAll('_', '-').toLowerCase() ?? '';
  }

  bool _requiresNetwork(Map<dynamic, dynamic> voice) {
    final value = voice['network_required']?.toString().trim().toLowerCase();
    return value == '1' || value == 'true';
  }

  bool _isVoiceDataInstalled(Map<dynamic, dynamic> voice) {
    final features = voice['features']?.toString().toLowerCase() ?? '';
    return !features.contains('notinstalled');
  }

  String _resolveErrorMessage(Object? error) {
    final rawError = error?.toString() ?? '';

    if (rawError.contains('-7')) {
      return 'انتهت مهلة الاتصال بمحرك الصوت. نزّل بيانات الصوت العربي من إعدادات تحويل النص إلى كلام ثم حاول مجددًا.';
    }

    if (rawError.contains('-6')) {
      return 'تعذر الاتصال بخدمة تحويل النص إلى كلام. تحقق من الإنترنت أو نزّل صوتًا عربيًا للعمل دون اتصال.';
    }

    if (rawError.contains('-9')) {
      return 'بيانات الصوت العربي غير مكتملة. أكمل تنزيلها من إعدادات تحويل النص إلى كلام.';
    }

    return 'تعذر تشغيل المساعد الصوتي';
  }

  Future<void> speak(String text) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty) return;

    await init();
    _lastErrorMessage = null;

    if (_isSpeaking) {
      _ignoreNextCancel = true;
      await _tts.stop();
    }

    debugPrint('============ TestVoiceAssistantService.speak ============');
    debugPrint(cleanText);
    debugPrint('=========================================================');

    final result = await _tts.speak(cleanText, focus: true);
    if (result != 1) {
      throw StateError('TextToSpeech rejected the speak request: $result');
    }
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
