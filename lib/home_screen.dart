import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late stt.SpeechToText _speech;
  final FlutterTts _flutterTts = FlutterTts();

  String _recognizedLetter = "";
  bool _isListening = false;
  bool _speechAvailable = false;

  // Map possible variations
  final Map<String, String> letterMap = {
    "A": "A",
    "AY": "A",
    "LETTER A": "A",
    "B": "B",
    "BEE": "B",
    "LETTER B": "B",
    "C": "C",
    "SEE": "C",
    "LETTER C": "C",
    "NUMBER ONE": "1",
    "BEER": "BEAR",
    "BIRD": "BIRD",
    "CAT": "CAT",
    "CHICKEN": "CHICKEN",
    "COW": "COW",
    "DEAR": "DEER",
    "DINOSAUR": "DINOSAUR",
    "DOG": "DOG",
    "DUCK": "DUCK",
    "ELEPHANT": "ELEPHANT",
    "FOX": "FOX",
    "HORSE": "HORSE",
    "LION": "LION",
    "MONKEY": "MONKEY",
    "PANDA": "PANDA",
    "RABBIT": "RABBIT",
    "RHINO": "RHINO",
    "SNAKE": "SNAKE",
    "SQUIRREL": "SQUIRREL",
    "TIGER": "TIGER",
    "ZEBRA": "ZEBRA",
    "GIRAFFE": "ZIRAP",
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
    _printMicStatus();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    if (!_speechAvailable) {
      print("Speech recognition not available on this device");
    }
  }

  // Check mic permission
  Future<bool> _checkMicPermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) return true;

    var result = await Permission.microphone.request();
    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) openAppSettings();
    return false;
  }

  Future<void> _printMicStatus() async {
    var status = await Permission.microphone.status;

    if (status.isGranted) {
      print("Microphone permission: Granted");
    } else if (status.isDenied) {
      print("Microphone permission: Denied");
    } else if (status.isPermanentlyDenied) {
      print("Microphone permission: Permanently Denied");
    } else if (status.isRestricted) {
      print("Microphone permission: Restricted");
    } else if (status.isLimited) {
      print("Microphone permission: Limited ");
    }
  }

  // Toggle listening with dialog
  void _toggleListening() async {
    bool hasPermission = await _checkMicPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission required!")),
      );
      return;
    }

    if (!_speechAvailable) return;

    if (!_isListening) {
      setState(() => _isListening = true);

      // Show listening dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          content: Text("Listening..."),
        ),
      );

      // Automatically close dialog and stop listening after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (_isListening) {
          _speech.stop();
          setState(() => _isListening = false);

          // Close dialog if still open
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      });

      _speech.listen(
        localeId: "en_US",
        listenFor: const Duration(seconds: 5),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        onResult: (result) {
          String text = result.recognizedWords.toUpperCase().trim();
          print("Recognized: $text");

          if (letterMap.containsKey(text)) {
            String mappedLetter = letterMap[text]!;

            setState(() => _recognizedLetter = mappedLetter);
            _flutterTts.speak(mappedLetter);

            // Stop listening immediately
            _speech.stop();
            setState(() => _isListening = false);

            // Close the dialog
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        },
      );
    } else {
      _speech.stop();
      setState(() => _isListening = false);

      // Close dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.withOpacity(0.5),
      appBar: AppBar(
          title:
          Center(
              child: Text("Speak & Show Animels", style: TextStyle(color: Colors.white,),),
          ),
        backgroundColor: Colors.purple.withOpacity(0.5),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _recognizedLetter.isEmpty
                ? Container(
                       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      alignment: Alignment.center, // centers the child
                        child: const Text(
                          "Say your favorite Animal Name",
                          textAlign: TextAlign.center, // center text alignment
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                : Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity, // optional, slightly bigger than image
              decoration: BoxDecoration(
                color: Colors.grey[300], // light gray background
                border: Border.all(color: Colors.black, width: 2), // black border
                borderRadius: BorderRadius.circular(20), // rounded corners
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // clip the image to match border radius
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(
                    'assets/images/${_recognizedLetter}.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            Text(
              _recognizedLetter,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Press & Speak",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8), // spacing between text and button
          FloatingActionButton(
            onPressed: _toggleListening,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 32),
          ),
        ],
      ),

    );
  }

}
