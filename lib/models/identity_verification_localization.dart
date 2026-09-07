class IdentityVerificationLocalization {
  IdentityVerificationLocalizationIntro? intro;

  IdentityVerificationLocalizationPrepare? prepare;

  IdentityVerificationLocalizationPageElements? starting;

  IdentityVerificationLocalizationPageElements? processing;

  IdentityVerificationLocalizationResultElements? success;

  IdentityVerificationLocalizationResultElements? fail;

  IdentityVerificationLocalizationPageElements? cameraPermission;

  IdentityVerificationLocalization({
    this.intro,
    this.prepare,
    this.starting,
    this.processing,
    this.success,
    this.fail,
    this.cameraPermission,
  });

  IdentityVerificationLocalization.fromJson(Map<String, dynamic> json) {
    if (json['intro'] is Map) {
      intro = IdentityVerificationLocalizationIntro.fromJson(json['intro']);
    }
    if (json['prepare'] is Map) {
      prepare = IdentityVerificationLocalizationPrepare.fromJson(
        json['prepare'],
      );
    }
    if (json['starting'] is Map) {
      starting = IdentityVerificationLocalizationPageElements.fromJson(
        json['starting'],
      );
    }
    if (json['processing'] is Map) {
      processing = IdentityVerificationLocalizationPageElements.fromJson(
        json['processing'],
      );
    }
    if (json['success'] is Map) {
      success = IdentityVerificationLocalizationResultElements.fromJson(
        json['success'],
      );
    }
    if (json['fail'] is Map) {
      fail = IdentityVerificationLocalizationResultElements.fromJson(
        json['fail'],
      );
    }
    if (json['cameraPermission'] is Map) {
      cameraPermission = IdentityVerificationLocalizationPageElements.fromJson(
        json['cameraPermission'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['intro'] = intro?.toJson();
    data['prepare'] = prepare?.toJson();
    data['starting'] = starting?.toJson();
    data['processing'] = processing?.toJson();
    data['success'] = success?.toJson();
    data['fail'] = fail?.toJson();
    data['cameraPermission'] = cameraPermission?.toJson();
    return data;
  }
}

class IdentityVerificationLocalizationIntro {
  String? eyebrow;
  String? title;
  String? body;
  String? cta;

  /// Small trust line under the intro CTA; pass `''` to hide.
  String? trustLabel;

  IdentityVerificationLocalizationIntro({
    this.eyebrow,
    this.title,
    this.body,
    this.cta,
    this.trustLabel,
  });

  IdentityVerificationLocalizationIntro.fromJson(Map<String, dynamic> json) {
    eyebrow = json['eyebrow'];
    title = json['title'];
    body = json['body'];
    cta = json['cta'];
    trustLabel = json['trustLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eyebrow'] = eyebrow;
    data['title'] = title;
    data['body'] = body;
    data['cta'] = cta;
    data['trustLabel'] = trustLabel;

    return data;
  }
}

class IdentityVerificationLocalizationPageElements {
  String? title;
  String? body;
  IdentityVerificationLocalizationPageElements({this.title, this.body});

  IdentityVerificationLocalizationPageElements.fromJson(
    Map<String, dynamic> json,
  ) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}

class IdentityVerificationLocalizationPrepare {
  String? eyebrow;
  String? title;
  List<IdentityVerificationLocalizationPageElements>? tips;
  String? cta;
  String? backLabel;

  IdentityVerificationLocalizationPrepare({
    this.eyebrow,
    this.title,
    this.tips,
    this.cta,
    this.backLabel,
  });

  IdentityVerificationLocalizationPrepare.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    eyebrow = json['eyebrow'];
    if (json['tips'] is List) {
      tips = (json['tips'] as List)
          .where((e) => e.values.every((v) => v != null))
          .map(
            (e) => IdentityVerificationLocalizationPageElements.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList();
    }
    cta = json['cta'];
    backLabel = json['backLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eyebrow'] = eyebrow;
    data['title'] = title;
    data['tips'] = tips?.map((e) => e.toJson()).toList();
    data['cta'] = cta;
    data['backLabel'] = backLabel;

    return data;
  }
}

class IdentityVerificationLocalizationResultElements
    extends IdentityVerificationLocalizationPageElements {
  String? cta;

  IdentityVerificationLocalizationResultElements({
    super.title,
    super.body,
    this.cta,
  });

  IdentityVerificationLocalizationResultElements.fromJson(
    Map<String, dynamic> json,
  ) {
    title = json['title'];
    body = json['body'];
    cta = json['cta'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['cta'] = cta;

    return data;
  }
}
