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
  var _selectedType;
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    // super.initState();
    initSpeechState();
    print("selected $_selectedType");
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
    final appBar = AppBar(
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
    );

    var _noSpeech = Center(
      child: Text(
        'Speech recognition unavailable',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );

    final transactionHeading = Container(
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      // color: Colors.red[200],
      child: Text(
        'Transactions',
        style: headingStyle,
        textAlign: TextAlign.left,
      ),
    );

    final emptyTransactionList = Column(
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
    );

    final filledTransactionList = ListView.separated(
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
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 5,
        color: Colors.black12,
      ),
    );

    final transactionListContainer = Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      height: MediaQuery.of(context).size.height * 0.55,
      child: entries.isEmpty ? emptyTransactionList : filledTransactionList,
    );

    final recognizedWords = Column(
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
                fontFamily: "NunitoSans", fontSize: 20, color: Colors.white),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );

    final costField = TextFormField(
      validator: (value) {
        // if (value.isEmpty) {
        //   _number = "";
        //   return "Please enter a mobile number";
        // }
        // _number = value;
        // return null;
      },
      autofocus: false,
      keyboardType: TextInputType.phone,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Amount *",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );

    final typeField = FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelStyle: style,
            errorStyle:
                TextStyle(color: Theme.of(context).errorColor, fontSize: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          isEmpty: _selectedType == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              // isDense: true,
              hint: Text("Select", style: style),
              onChanged: (String newValue) {
                setState(() {
                  _selectedType = newValue;
                  state.didChange(_selectedType);
                });
              },

              items: ["Paid", "Recieved"].map((String v) {
                return DropdownMenuItem<String>(
                  value: v.toString(),
                  child: Text(
                    v,
                    style: style,
                  ),
                );
              }).toList(),
              value: _selectedType,
            ),
          ),
        );
      },
    );

    final inputContainer = Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      height: 80,
      child: Row(
        children: <Widget>[
          new Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
              child: costField,
            ),
          ),
          new Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
              child: typeField,
            ),
          ),
        ],
      ),
    );

    var _yesSpeech = SingleChildScrollView(
      child: Container(
        // color: Colors.green[200],
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            transactionHeading,
            transactionListContainer,
            recognizedWords,
            inputContainer,
          ],
        ),
      ),
    );

    final listeningButton = Container(
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
    );

    final notListeningButton = Container(
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
    );

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: appBar,
      body: _hasSpeech ? _yesSpeech : _noSpeech,
      floatingActionButton: _isListening ? listeningButton : notListeningButton,
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
    setState(() {
      _isListening = false;
    });
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
    print("error mssg $error");
    setState(() {
      _isListening = false;
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }
}
