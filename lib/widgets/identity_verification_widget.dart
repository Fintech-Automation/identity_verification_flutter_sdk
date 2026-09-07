import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:identity_verification_flutter_sdk/models/identity_verification_brand.dart';
import 'package:identity_verification_flutter_sdk/models/identity_verification_error_model.dart';
import 'package:identity_verification_flutter_sdk/models/identity_verification_flow.dart';
import 'package:identity_verification_flutter_sdk/models/identity_verification_localization.dart';
import 'package:identity_verification_flutter_sdk/models/identity_verification_result_model.dart';
import 'package:identity_verification_flutter_sdk/models/identity_verification_screen_type.dart';
import 'package:identity_verification_flutter_sdk/models/identity_verification_session_status.dart';
import 'package:identity_verification_flutter_sdk/models/identity_verification_theme.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class IdentityVerificationWidget extends StatefulWidget {
  const IdentityVerificationWidget({
    required this.verificationToken,
    this.brand,
    this.flow,
    this.theme,
    this.localization,
    this.captureText,
    this.onSuccess,
    this.onFail,
    this.onError,
    this.onCancel,
    this.onAnalysisComplete,
    this.onScreenChange,
    this.onContinue,
    this.onSessionStatusChange,
    super.key,
  });

  /// Bearer token used to authenticate backend APIs.
  final String verificationToken;

  /// Brand shown in the SDK chrome.
  final IdentityVerificationBrand? brand;

  /// Flow behavior, independent from visual theme.
  final IdentityVerificationFlow? flow;

  ///  Visual system tokens grouped by concern.
  final IdentityVerificationTheme? theme;

  /// SDK-owned screen copy, grouped by screen.
  final IdentityVerificationLocalization? localization;

  /// Text overrides for the camera/capture step.
  final Map<String, String>? captureText;

  ///Fired when liveness passes (`result.passed === true`).
  final void Function(IdentityVerificationResultModel? result)? onSuccess;

  /// Fired when liveness fails (`result.passed === false`).
  final void Function(IdentityVerificationResultModel? result)? onFail;

  /// Fired on any error (session creation, results fetch, or AWS detector error).
  final void Function(IdentityVerificationErrorModel? error)? onError;

  /// Fired when the user cancels the AWS capture.
  final void Function()? onCancel;

  /// Low-level AWS hook fired when capture completes, before results are fetched.
  final void Function()? onAnalysisComplete;

  /// Fired on every screen transition (telemetry).
  final void Function(IdentityVerificationScreenType?)? onScreenChange;

  /// When provided, renders a "Continue" button on the success screen that calls this.
  final void Function()? onContinue;

  /// Called after the SDK validates the token/session state. status indicates the session state, and isEligible indicates whether the session is eligible for verification.
  final void Function(IdentityVerificationSessionStatus?)?
  onSessionStatusChange;

  @override
  State<IdentityVerificationWidget> createState() =>
      _IdentityVerificationWidgetState();
}

class _IdentityVerificationWidgetState
    extends State<IdentityVerificationWidget> {
  Map<String, dynamic> get parameter {
    return {
      'verificationToken': widget.verificationToken,
      'brand': widget.brand?.toJson(),
      'flow': widget.flow,
      'theme': widget.theme?.toJson(),
      'localization': widget.localization?.toJson(),
      'captureText': widget.captureText,
    };
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      // initialUrlRequest: URLRequest(url: WebUri('https://192.168.31.17:5173/')),
      initialFile:
          'packages/identity_verification_flutter_sdk/assets/html/face_liveness.html',
      initialSettings: InAppWebViewSettings(
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        sharedCookiesEnabled: true,
        domStorageEnabled: true,
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,
        useShouldInterceptAjaxRequest: true,
      ),
      initialUserScripts: UnmodifiableListView<UserScript>([
        UserScript(
          source:
              """
                window.__INITIAL_NATIVE_DATA__ = `${jsonEncode(parameter)}`;
              """,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        ),
      ]),
      onWebViewCreated: (controller) async {
        controller.addJavaScriptHandler(
          handlerName: 'onSuccess',
          callback: (args) {
            if (args.isNotEmpty && args[0] is Map<String, dynamic>) {
              if (args[0].containsKey('result')) {
                Map<String, dynamic> result = args[0]['result'];
                IdentityVerificationResultModel livenessResult =
                    IdentityVerificationResultModel.fromJson(result);
                widget.onSuccess?.call(livenessResult);
              }
            }
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onFail',
          callback: (args) {
            if (args.isNotEmpty && args[0] is Map<String, dynamic>) {
              if (args[0].containsKey('result')) {
                Map<String, dynamic> result = args[0]['result'];
                IdentityVerificationResultModel livenessResult =
                    IdentityVerificationResultModel.fromJson(result);
                widget.onFail?.call(livenessResult);
              }
            }
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onError',
          callback: (args) {
            if (args.isNotEmpty &&
                args.first is Map &&
                (args.first as Map).containsKey('error')) {
              widget.onError?.call(
                IdentityVerificationErrorModel.fromJson(args.first['error']),
              );
            }
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onCancel',
          callback: (args) {
            widget.onCancel?.call();
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onAnalysisComplete',
          callback: (args) {
            widget.onAnalysisComplete?.call();
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onScreenChange',
          callback: (args) {
            if (args.isNotEmpty &&
                args.first is Map &&
                (args.first as Map).containsKey('screen')) {
              widget.onScreenChange?.call(
                IdentityVerificationScreenType.from(args.first['screen']),
              );
            }
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onContinue',
          callback: (args) {
            widget.onContinue?.call();
          },
        );

        controller.addJavaScriptHandler(
          handlerName: 'onSessionStatusChange',
          callback: (args) {
            print(args);
            if (args.isNotEmpty && args[0] is Map<String, dynamic>) {
              if (args[0].containsKey('result')) {
                Map<String, dynamic> result = args[0]['result'];
                IdentityVerificationSessionStatus identityVerificationStatus =
                    IdentityVerificationSessionStatus.fromJson(result);
                widget.onSessionStatusChange?.call(identityVerificationStatus);
              }
            }
          },
        );
      },
      onLoadStart: (controller, url) async {},
      onLoadStop: (controller, url) {},
      onNavigationResponse: (controller, navigationResponse) async {
        return NavigationResponseAction.ALLOW;
      },
      onConsoleMessage: (controller, consoleMessage) {
        print('Console message: ${consoleMessage.message}');
      },
      onReceivedError: (controller, request, message) {
        print('error: $message');
      },
      onReceivedHttpError: (controller, request, errorResponse) {
        print('HTTP error: ${errorResponse.statusCode} ${errorResponse.data}');
      },
      onReceivedServerTrustAuthRequest: (controller, challenge) async {
        return ServerTrustAuthResponse(
          action: ServerTrustAuthResponseAction.PROCEED,
        );
      },
      onPermissionRequest: (controller, permissionRequest) async {
        final resources = <PermissionResourceType>[];
        if (permissionRequest.resources.contains(
          PermissionResourceType.CAMERA,
        )) {
          final cameraStatus = await Permission.camera.request();
          if (!cameraStatus.isDenied) {
            resources.add(PermissionResourceType.CAMERA);
          }
        }
        return PermissionResponse(
          action: PermissionResponseAction.GRANT,
          resources: permissionRequest.resources,
        );
      },
    );
  }
}
