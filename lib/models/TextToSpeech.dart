class TextToSpeech {
  String? text;
  String? emotion;

  TextToSpeech({this.text});

  TextToSpeech.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    emotion = json['emotion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['emotion'] = emotion;
    return data;
  }
}