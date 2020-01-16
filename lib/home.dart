import 'package:flutter/material.dart';
import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextStyle style = TextStyle(fontFamily: "NunitoSans", fontSize: 20, );

  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>[
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I'
    ];

    var _noSpeech = Center(
      child: Text(
        'Speech recognition unavailable',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );

    var _yesSpeech = Container(
      // color: Colors.green[200],
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.91,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          width: MediaQuery.of(context).size.width,
          // padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          // color: Colors.red[200],
          child: Text(
            'Transactions',
            style: style,
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.55,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 70,
                child: Card(
                  elevation: 3,
                  color: Colors.blue[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Center(
                      child: Text(
                    'Entry ${entries[index]}',
                    style: style,
                  )),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(color: Colors.white,),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text('Stop'),
              onPressed: stopListening,
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: cancelListening,
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Center(
                child: Text('Recognized Words', style: style,),
              ),
              Center(
                child: Text(lastWords, style: style,),
              ),
            ],
          ),
        ),
        IconButton(
          color: Colors.red,
          iconSize: 50,
          icon: Icon(Icons.mic),
          alignment: Alignment.bottomCenter,
          onPressed: startListening,
        ),
      ]),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text Example'),
      ),
      body: SingleChildScrollView(
        child: _hasSpeech ? _yesSpeech : _noSpeech,
      ),
    );
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(onResult: resultListener);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }
}
