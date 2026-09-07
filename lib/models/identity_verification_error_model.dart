class IdentityVerificationErrorModel {
  /// Where the failure occurred.
  /// 'camera' | 'createSession' | 'getResults' | 'aws' | 'config'
  String? stage;
  String? message;
  dynamic cause;

  IdentityVerificationErrorModel({this.stage, this.message, this.cause});

  IdentityVerificationErrorModel.fromJson(Map<String, dynamic> json) {
    stage = json['stage'];
    message = json['message'];
    cause = json['cause'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stage'] = stage;
    data['message'] = message;
    data['cause'] = cause;
    return data;
  }
}
