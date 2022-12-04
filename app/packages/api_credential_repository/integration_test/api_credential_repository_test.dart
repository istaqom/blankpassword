import 'dart:convert';

import 'package:api_credential_repository/api_credential_repository.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    DArgon2Flutter.init();

    test('First Test', () async {
      var credential = Credential(
        name: "test-name",
        password: "test-password",
        sites: [],
        notes: "test-notes",
      );

      var result = jsonDecode(await credentialToJson("password", credential));

      expect(credential, await credentialFromJson("password", result));

      await expectLater(
        () => credentialFromJson("password2", result),
        throwsA(anything),
      );
    });
  });
}
