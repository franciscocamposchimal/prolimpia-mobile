import 'package:prolimpia_mobile/models/user_model.dart';

class CurrentUser {
  User user;
  String token;
  String tokenType;
  String tokenCreatedAt;
  int expiresIn;

  CurrentUser(
      {this.user,
      this.token,
      this.tokenType,
      this.tokenCreatedAt,
      this.expiresIn});

  CurrentUser.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
    tokenType = json['token_type'];
    tokenCreatedAt = json['token_created_at'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['token'] = this.token;
    data['token_type'] = this.tokenType;
    data['token_created_at'] = this.tokenCreatedAt;
    data['expires_in'] = this.expiresIn;
    return data;
  }
}
