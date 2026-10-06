import 'package:flutter/cupertino.dart';

class LivenessSessionStatus {
  SessionStatus? status;
  String? stage;
  String? message;
  bool? isEligible;

  LivenessSessionStatus.fromJson(Map<String, dynamic> json) {
    if (json['stage'] is String) {
      try {
        status = SessionStatus.from(json['status']);
      } catch (e) {
        debugPrint('Error occurred while parsing session status: $e');
      }
    }
    stage = json['stage'];
    message = json['message'];
    isEligible = json['isEligible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status?.displayName;
    data['stage'] = stage;
    data['message'] = message;
    data['isEligible'] = isEligible;
    return data;
  }
}

enum SessionStatus {
  /// The token already completed verification successfully (liveness, and face-comparison for an identity-verification session).
  completed('COMPLETED'),

  /// The token has expired or the backend returned an auth/session-expired response.
  expired('EXPIRED'),

  ///  The token is invalid, rejected, or otherwise failed validation.
  invalid('INVALID'),

  /// Session token is valid and ready for liveness detection.
  ready('READY'),

  /// Retry limit exceeded — no further attempts allowed.
  readyRetryLimitExceeded('RETRY_LIMIT_EXCEEDED'),

  /// No verificationToken was supplied to the component.
  missingToken('MISSING_TOKEN'),

  /// Liveness already passed on an earlier visit, but identity/document verification is still required — the flow resumes directly on the identity screen.
  identityRequired('IDENTITY_REQUIRED'),

  ///  Liveness already passed on an earlier visit, but identity/document (face-comparison) verification failed.
  identityFailed('IDENTITY_FAILED');

  final String displayName;
  const SessionStatus(this.displayName);

  static SessionStatus? from(String name) {
    return SessionStatus.values.firstWhere(
      (e) => e.displayName == name,
      orElse: () => throw Exception('Invalid state: $name'),
    );
  }
}
