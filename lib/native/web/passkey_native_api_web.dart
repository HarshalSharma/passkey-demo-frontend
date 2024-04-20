import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:js' as js;

import 'package:passkey_demo_frontend/native/passkey_native_api.dart';

PasskeyNativeAPI getPasskeyNativeAPIInstance() {
  return PasskeyNativeAPIWeb();
}

class PasskeyNativeAPIWeb implements PasskeyNativeAPI {
  @override
  Future<bool> isPasskeySupported() async {
    if (js.context.hasProperty('PublicKeyCredential')) {
      // WebAuthn is supported
      log("Feature is supported");
      return true;
    }
    // WebAuthn is not supported
    log("Feature NOT supported");
    return false;
  }

  @override
  Future<Map<String, dynamic>?> createCredential(options) async {
    try {
      if (await isPasskeySupported()) {
        String? response = await _callJS('register', options);
        if (response != null) {
          return json.decode(response);
        }
      }
    } catch (e) {
      log("createCredential Error - ${e.toString()}");
      return Future.error(e.toString());
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> login(Map<String, dynamic> options) async {
    try {
      if (await isPasskeySupported()) {
        String? response = await _callJS('login', options);
        if (response != null) {
          return json.decode(response);
        }
      }
    } catch (e) {
      log("createCredential Error - ${e.toString()}");
      return Future.error(e.toString());
    }
    return null;
  }

  Future<String?> _callJS(String function, Map<String, dynamic> options) async {
    final completer = Completer<String?>();
    try {
      // Call the JavaScript function asynchronously
      js.context.callMethod(function, [
        js.JsObject.jsify(options),
        js.allowInterop((result) {
          log("result in dart - ");
          completer.complete(
              result); // Complete the Future with the result from JavaScript
        }),
        js.allowInterop((error) {
          log("error in dart - ");
          log(error);
          completer.completeError(error); // Complete the Future with the error
        })
      ]);
    } catch (err) {
      log("$err");
      completer.completeError(err);
    }

    return completer.future;
  }
}
