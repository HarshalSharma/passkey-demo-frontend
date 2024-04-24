import 'package:passkey_demo_frontend/server/WebauthnServer.dart';

class RemoteServices {
  final WebauthnServer server;

  RemoteServices(this.server);

  get webauthnApi => server;

  get notesApi => server;

  get preferencesApi => server;
}
