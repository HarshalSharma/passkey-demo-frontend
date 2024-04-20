import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:passkey_demo_frontend/server/api/webauthn_api.dart';
import 'package:passkey_demo_frontend/server/models/authentication_request.dart';
import 'package:passkey_demo_frontend/server/models/public_key_credential_creation_options_response.dart';
import 'package:passkey_demo_frontend/server/models/public_key_credential_request_options_response.dart';
import 'package:passkey_demo_frontend/server/models/registration_request.dart';
import 'package:passkey_demo_frontend/server/models/successful_authentication_response.dart';

class WebauthnServer implements WebauthnAPI {
  final String host;

  WebauthnServer({required this.host});

  @override
  Future<PublicKeyCredentialCreationOptionsResponse?> registrationGet() async {
    var uri = '$host/registration';
    var jsonMap = await httpGET(uri);
    if (jsonMap == null) {
      return null;
    }
    return PublicKeyCredentialCreationOptionsResponse.fromJson(jsonMap);
  }

  @override
  Future<bool?> registrationPost(RegistrationRequest body) async {
    var uri = '$host/registration';
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
    var uri = '$host/authentication/$userHandle';
    var jsonMap = await httpGET(uri);
    if (jsonMap == null) {
      return null;
    }
    return PublicKeyCredentialRequestOptionsResponse.fromJson(jsonMap);
  }

  @override
  Future<SuccessfulAuthenticationResponse?> authenticationUserHandlePost(
      AuthenticationRequest body, String userHandle) async {
    var uri = '$host/authentication/$userHandle';
    var jsonBody = jsonEncode(body.toJson());
    var responseMap = await httpPOST(uri, jsonBody);
    if (responseMap == null) {
      return null;
    }
    return SuccessfulAuthenticationResponse.fromJson(responseMap);
  }

  Future<Map<String, dynamic>?> httpGET(String uri) async {
    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Request was successful, parse response
        return jsonDecode(response.body);
      } else {
        // Request failed, handle error
        log('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      log('Error fetching data: $e');
    }
    return null;
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
        // Request was successful, parse response
        return jsonDecode(response.body);
      } else {
        // Request failed, handle error
        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      log('Error posting data: $e');
    }
    return null;
  }
}
