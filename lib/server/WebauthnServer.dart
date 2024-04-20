import 'package:passkey_demo_frontend/server/api/webauthn_api.dart';
import 'package:passkey_demo_frontend/server/models/authentication_request.dart';
import 'package:passkey_demo_frontend/server/models/public_key_credential_creation_options_response.dart';
import 'package:passkey_demo_frontend/server/models/public_key_credential_request_options_response.dart';
import 'package:passkey_demo_frontend/server/models/registration_request.dart';
import 'package:passkey_demo_frontend/server/models/successful_authentication_response.dart';

class WebauthnServer implements WebauthnAPI {
  @override
  Future<PublicKeyCredentialRequestOptionsResponse?>
      authenticationUserHandleGet(String userHandle) {
    // TODO: implement authenticationUserHandleGet
    throw UnimplementedError();
  }

  @override
  Future<SuccessfulAuthenticationResponse?> authenticationUserHandlePost(
      AuthenticationRequest body, String userHandle) {
    // TODO: implement authenticationUserHandlePost
    throw UnimplementedError();
  }

  @override
  Future<PublicKeyCredentialCreationOptionsResponse?> registrationGet() {
    // TODO: implement registrationGet
    throw UnimplementedError();
  }

  @override
  Future<bool?> registrationPost(RegistrationRequest body) {
    // TODO: implement registrationPost
    throw UnimplementedError();
  }
}
