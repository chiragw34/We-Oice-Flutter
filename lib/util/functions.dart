Map textToData(String recognisedText) {
  print("inside fn $recognisedText");
  if (recognisedText == "")
    return {"amount": null, "type": null, "items": null};
  else {
    final intRegex = RegExp(r'\s+(\d+)\s+', multiLine: true);
    var amount = intRegex.stringMatch("I " + recognisedText + " I");
    print("amount is $amount");
    if (amount != null) amount = amount.trim();

    var type;
    if (recognisedText.toLowerCase().contains("paid")) {
      type = "Paid";
    } else if (recognisedText.toLowerCase().contains("received")) {
      type = "Received";
    }

    print("type is $type");

    return {"amount": amount, "type": type, "items": null};
  }
}
