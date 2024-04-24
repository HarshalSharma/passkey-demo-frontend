import '../models/authentication_request.dart';
import '../models/public_key_credential_creation_options_response.dart';
import '../models/public_key_credential_request_options_response.dart';
import '../models/registration_request.dart';
import '../models/successful_authentication_response.dart';

abstract class WebauthnAPI {
  /// Creates Public Key Credential Request Options From userHandle.
  ///
  ///
  Future<PublicKeyCredentialRequestOptionsResponse?>
      authenticationUserHandleGet(String userHandle);

  /// Creates Public key Credential Request Options from Location.
  ///
  Future<PublicKeyCredentialRequestOptionsResponse?>
  autoAuthenticationGet(double latitude, double longitude);

  /// Authenticates the user credential signing request and grants a token.
  ///
  ///
  Future<SuccessfulAuthenticationResponse?> authenticationUserHandlePost(
      AuthenticationRequest body, String userHandle);

  /// Creates PublicKeyCredentialOptions for webauthn Registration.
  ///
  ///
  Future<PublicKeyCredentialCreationOptionsResponse?> registrationGet();

  /// Store new webauthn-credentials
  ///
  ///
  Future<bool?> registrationPost(RegistrationRequest body);
}
