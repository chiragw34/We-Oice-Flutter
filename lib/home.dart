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
  TextStyle style = TextStyle(
    fontFamily: "NunitoSans",
    fontSize: 20,
  );

  TextStyle headingStyle = TextStyle(
    fontFamily: "NunitoSans",
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  bool _hasSpeech = false;
  bool _isListening = false;
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

  List<String> entries = <String>[];

  @override
  Widget build(BuildContext context) {
    var _noSpeech = Center(
      child: Text(
        'Speech recognition unavailable',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );

    var _yesSpeech = SingleChildScrollView(
      child: Container(
        // color: Colors.green[200],

        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            width: MediaQuery.of(context).size.width,
            // padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            // color: Colors.red[200],
            child: Text(
              'Transactions',
              style: headingStyle,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
            ),
            height: MediaQuery.of(context).size.height * 0.55,
            child: entries.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.grey,
                        size: 150,
                      ),
                      SizedBox(
                        width: 100,
                        height: 10,
                      ),
                      Text(
                        "no transactions yet",
                        style: TextStyle(
                          fontFamily: "NunitoSans",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: <Widget>[
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            color: Colors.blue[100],
                            child: Container(
                              height: 130,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${entries[index]}',
                                      style: style,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              color: Colors.redAccent,
                              splashColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  entries.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 5,
                      color: Colors.black12,
                    ),
                  ),
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: lastWords.isEmpty
                    ? Text("")
                    : Text(
                        'Recognized Words :',
                        style: headingStyle,
                        textAlign: TextAlign.left,
                      ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  lastWords,
                  style: TextStyle(
                      fontFamily: "NunitoSans",
                      fontSize: 20,
                      color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ]),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: const Text(
            'We\'Oice',
            style: TextStyle(
              fontFamily: "NunitoSans",
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: _hasSpeech ? _yesSpeech : _noSpeech,
      floatingActionButton: _isListening
          ? Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.redAccent,
              ),
              child: new IconButton(
                color: Colors.white,
                iconSize: 50,
                icon: Icon(Icons.close),
                alignment: Alignment.bottomCenter,
                onPressed: stopListening,
              ),
            )
          : Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.redAccent,
              ),
              child: new IconButton(
                color: Colors.white,
                iconSize: 50,
                icon: Icon(Icons.mic),
                alignment: Alignment.bottomCenter,
                onPressed: startListening,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(onResult: resultListener);
    setState(() {
      _isListening = true;
    });
  }

  void stopListening() {
    speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      _isListening = !result.finalResult;

      if (result.recognizedWords.isEmpty) {
        lastWords = "";
      } else {
        lastWords = "${result.recognizedWords} - listening...";
      }
      if (result.finalResult) {
        lastWords = "${result.recognizedWords}";
        entries.add(result.recognizedWords);
      }
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
