import 'dart:convert';
import 'dart:developer';

import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:passkey_demo_frontend/app_state.dart';
import 'package:passkey_demo_frontend/server/api/webauthn_api.dart';
import 'package:passkey_demo_frontend/server/models/authentication_request.dart';
import 'package:passkey_demo_frontend/server/models/public_key_credential_creation_options_response.dart';
import 'package:passkey_demo_frontend/server/models/public_key_credential_request_options_response.dart';
import 'package:passkey_demo_frontend/server/models/registration_request.dart';
import 'package:passkey_demo_frontend/server/models/successful_authentication_response.dart';
import 'package:provider/provider.dart';

class WebauthnServer implements WebauthnAPI {
  final BuildContext context;

  WebauthnServer(this.context);

  get origin => Provider.of<ServerState>(context, listen: false).serverOrigin;

  @override
  Future<PublicKeyCredentialCreationOptionsResponse?> registrationGet() async {
    var uri = '$origin/registration';
    var jsonMap = await httpGET(uri);
    if (jsonMap == null) {
      return null;
    }
    return PublicKeyCredentialCreationOptionsResponse.fromJson(jsonMap);
  }

  @override
  Future<bool?> registrationPost(RegistrationRequest body) async {
    var uri = '$origin/registration';
    var jsonBody = jsonEncode(body.toJson());
    var responseMap = await httpPOST(uri, jsonBody);
    if (responseMap == null) {
      return false;
    }
    return true;
  }

  @override
  Future<PublicKeyCredentialRequestOptionsResponse?>
      authenticationUserHandleGet(String userHandle) async {
    var uri = '$origin/authentication/$userHandle';
    var jsonMap = await httpGET(uri);
    if (jsonMap == null) {
      return null;
    }
    return PublicKeyCredentialRequestOptionsResponse.fromJson(jsonMap);
  }

  @override
  Future<SuccessfulAuthenticationResponse?> authenticationUserHandlePost(
      AuthenticationRequest body, String userHandle) async {
    var uri = '$origin/authentication/$userHandle';
    var jsonBody = jsonEncode(body.toJson());
    var responseMap = await httpPOST(uri, jsonBody);
    if (responseMap == null) {
      return null;
    }
    return SuccessfulAuthenticationResponse.fromJson(responseMap);
  }

  Future<Map<String, dynamic>?> httpGET(String uri) async {
    try {
      final response = await http.get(Uri.parse(uri), headers: {
        "ngrok-skip-browser-warning": "0000",
      });

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return readResponse(response);
      } else {
        // Request failed, handle error
        log('Failed to fetch data: ${response.statusCode}');
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      log('Error fetching data: $e');
      throw Exception('Error fetching data: $e');
    }
  }

  Future<Map<String, dynamic>?> httpPOST(String uri, String jsonBody) async {
    try {
      final response = await http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody, // Example request body
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return readResponse(response);
      } else {
        // Request failed, handle error
        log('Failed to post data: ${response.statusCode}');
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      log('Error posting data: $e');
      throw Exception('Error posting data: $e');
    }
  }

  readResponse(http.Response response) {
    if (response.body.isNotEmpty) {
      // Request was successful, parse response
      return jsonDecode(response.body);
    } else {
      return {};
    }
  }
}
