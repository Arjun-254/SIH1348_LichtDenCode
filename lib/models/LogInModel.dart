class LogInModel {
  String? message;
  String? accessToken;
  String? name;
  String? tokenType;

  LogInModel({this.message, this.accessToken, this.tokenType, this.name});

  LogInModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['name'] = name;
    return data;
  }
}
