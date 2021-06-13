class AuthData {
  String clientId = "";
  String clientSecret = "";
  String redirectUri = "";
  String code = "";
  String grantType = "";

  AuthData({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
    required this.code,
    required this.grantType,
  });

  AuthData.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'] ?? "";
    clientSecret = json['client_secret'] ?? "";
    redirectUri = json['redirect_uri'] ?? "";
    code = json['code'] ?? "";
    grantType = json['grant_type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['client_secret'] = this.clientSecret;
    data['redirect_uri'] = this.redirectUri;
    data['code'] = this.code;
    data['grant_type'] = this.grantType;
    return data;
  }
}

class Auth {
  String accessToken = "";
  String tokenType = "";
  String refreshToken = "";
  String scope = "";
  int createdAt = 0;

  Auth({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
    required this.scope,
    required this.createdAt,
  });

  Auth.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    refreshToken = json['refresh_token'];
    scope = json['scope'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['refresh_token'] = this.refreshToken;
    data['scope'] = this.scope;
    data['created_at'] = this.createdAt;
    return data;
  }
}
