// blind_voice_home.dart
// Flutter screen (copy this file into lib/) that replaces a dropdown with voice control.
// ---------------------------
// BEFORE USING:
// 1) Add dependencies (run in your project root):
//    flutter pub add speech_to_text flutter_tts http
//    (or add in pubspec.yaml under dependencies: speech_to_text: ^5.6.0, flutter_tts: ^4.3.0, http: ^0.13.6)
//
// 2) Android permissions (android/app/src/main/AndroidManifest.xml) - add above <application> tag:
//    <uses-permission android:name="android.permission.RECORD_AUDIO" />
//    <uses-permission android:name="android.permission.INTERNET" />
//
// 3) iOS permissions (ios/Runner/Info.plist) - add:
//    <key>NSMicrophoneUsageDescription</key>
//    <string>App needs microphone access to listen to voice commands</string>
//    <key>NSSpeechRecognitionUsageDescription</key>
//    <string>App needs speech recognition to convert your voice into commands</string>
//
// 4) Backend URL:
//    - If using Android emulator, use: http://10.0.2.2:5000
//    - If using iOS simulator, use: http://127.0.0.1:5000
//    - If running on a physical device, use your PC's LAN IP (example printed by Flask: http://10.74.77.62:5000)
//    Update the BACKEND_URL constant below accordingly.
//
// 5) CORS: your Flask backend already used flask-cors in the backend skeleton, so cross-origin should be allowed.
//
// USAGE (quick):
//  - Copy this file to lib/blind_voice_home.dart
//  - Update BACKEND_URL constant to point to your Flask server
//  - Add this widget to your MaterialApp home:
//      home: BlindVoiceHome()
//  - Run the app on device/emulator
//
// ---------------------------

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

const String BACKEND_URL = "http://10.74.77.62:5000"; // <-- CHANGE this to your backend address

class BlindVoiceHome extends StatefulWidget {
  const BlindVoiceHome({Key? key}) : super(key: key);

  @override
  State<BlindVoiceHome> createState() => _BlindVoiceHomeState();
}

class _BlindVoiceHomeState extends State<BlindVoiceHome> {
  late stt.SpeechToText _speech;
  bool _speechAvailable = false;
  bool _isListening = false;
  String _lastWords = '';
  String _status = 'Press the microphone to speak';
  final FlutterTts _tts = FlutterTts();
  String _lastDetectionText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
    _initTts();
  }

  Future<void> _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onStatus: (val) => debugPrint('Speech status: $val'),
        onError: (val) => debugPrint('Speech error: $val'),
      );
    } catch (e) {
      debugPrint('Speech init error: $e');
      _speechAvailable = false;
    }
    setState(() {});
  }

  Future<void> _initTts() async {
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  void _startListening() async {
    if (!_speechAvailable) {
      setState(() => _status = 'Speech not available');
      return;
    }

    setState(() {
      _isListening = true;
      _status = 'Listening...';
      _lastWords = '';
    });

    await _speech.listen(
      onResult: (result) async {
        setState(() {
          _lastWords = result.recognizedWords;
        });

        // when speech is final or reasonably confident, stop and handle
        if (result.finalResult) {
          await _speech.stop();
          setState(() => _isListening = false);
          await _handleRecognizedCommand(_lastWords);
        }
      },
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: true,
      partialResults: true,
    );
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
      _status = 'Stopped listening';
    });
  }

  Future<void> _handleRecognizedCommand(String raw) async {
    final text = raw.toLowerCase().trim();
    debugPrint('Recognized: $text');

    String mode = 'objects'; // default

    if (text.contains('person') || text.contains('people') || text.contains('someone')) {
      mode = 'person';
    } else if (text.contains('currency') || text.contains('note') || text.contains('coin') || text.contains('rupee') || text.contains('money')) {
      mode = 'currency';
    } else if (text.contains('object') || text.contains('what') || text.contains('front')) {
      mode = 'objects';
    }

    final spoken = 'Okay. I will detect $mode now.';
    await _speak(spoken);

    await Future.delayed(Duration(milliseconds: 400));
    await _callDetectApi(mode);
  }

  Future<void> _callDetectApi(String mode) async {
    setState(() => _status = 'Contacting backend...');
    try {
      final uri = Uri.parse('$BACKEND_URL/detect');
      final res = await http.post(
        uri,
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode({'mode': mode}),
      ).timeout(Duration(seconds: 12));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final List detections = (body['detections'] ?? []) as List;
        String responseText = '';

        if (detections.isEmpty) {
          responseText = "I couldn't detect anything.";
        } else {
          // Count labels
          final Map<String,int> counts = {};
          for (var d in detections) {
            final label = (d['label'] ?? 'object').toString();
            counts[label] = (counts[label] ?? 0) + 1;
          }
          final parts = counts.entries.map((e) => '${e.value} ${e.key}${e.value > 1 ? 's' : ''}').toList();
          responseText = 'I detected ${parts.join(', ')}.';
        }

        setState(() {
          _lastDetectionText = responseText;
          _status = 'Detection complete';
        });

        await _speak(responseText);
      } else {
        setState(() => _status = 'Backend error: ${res.statusCode}');
        await _speak('I could not reach the detection server.');
      }
    } catch (e) {
      debugPrint('Error calling detect API: $e');
      setState(() => _status = 'Request failed');
      await _speak('There was an error contacting the server.');
    }
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS error: $e');
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTapDown: (_) => _startListening(),
      onTapUp: (_) => _stopListening(),
      child: Semantics(
        label: 'Hold to talk',
        hint: 'Hold the button and speak your command',
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: _isListening ? Colors.redAccent : Colors.blueAccent,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(blurRadius: 6, offset: Offset(0,3))],
          ),
          child: Center(
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              size: 64,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blind Assistant'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              Text(
                _status,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 24),
              _buildMicButton(),
              SizedBox(height: 24),

              // Last recognized speech (visible for debugging)
              if (_lastWords.isNotEmpty)
                Column(
                  children: [
                    Text('You said:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text(_lastWords, textAlign: TextAlign.center),
                    SizedBox(height: 18),
                  ],
                ),

              // Last detection (visible for debugging)
              if (_lastDetectionText.isNotEmpty)
                Column(
                  children: [
                    Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text(_lastDetectionText, textAlign: TextAlign.center),
                  ],
                ),

              Spacer(),

              Text('Tip: Hold the mic button, say "Detect people" or "Detect currency" or "What\'s in front of me"', textAlign: TextAlign.center),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
