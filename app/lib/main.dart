import 'package:api_authentication_repository/api_authentication_repository.dart';
import 'package:api_credential_repository/api_credential_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:blankpassword/auth.dart';
import 'package:blankpassword/autofill.dart';
import 'package:blankpassword/credential/blocs/credentials_bloc.dart';
import 'package:blankpassword/password.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_autofill_service/flutter_autofill_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blankpassword/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:user_repository/user_repository.dart';
import 'package:http/http.dart' as http;

void run({
  required bool isAutofill,
}) {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  var authenticationInterceptor = ApiAuthenticationInterceptor();
  http.Client httpClient = InterceptedClient.build(interceptors: [
    authenticationInterceptor,
  ]);

  var url = "192.168.1.7:3000";
  var apiAuthenticationRepository = ApiAuthenticationRepository(
    client: httpClient,
    url: url,
    interceptor: authenticationInterceptor,
  );
  var credentialRepository = ApiCredentialRepository(
    client: httpClient,
    url: url,
  );

  apiAuthenticationRepository.passwordStream.listen((password) {
    credentialRepository.password = password;
  });

  var userRepository = UserRepository();

  runApp(MyApp(
    authenticationRepository: apiAuthenticationRepository,
    userRepository: userRepository,
    credentialRepository: credentialRepository,
    isAutofill: isAutofill,
  ));
}

void main() {
  run(isAutofill: false);
}

void autofillEntryPoint() {
  run(isAutofill: true);
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class MyApp extends StatefulWidget {
  MyApp({
    super.key,
    required this.authenticationRepository,
    required this.userRepository,
    required this.credentialRepository,
    required this.isAutofill,
  }) : authenticationBloc = AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        );

  final bool isAutofill;
  final ApiAuthenticationRepository authenticationRepository;
  final ApiCredentialRepository credentialRepository;
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  final _navigatorKey = GlobalKey<NavigatorState>();

  late Future loadFuture;

  late bool isAutofill;
  late Future? autofillFuture;

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    widget.authenticationRepository.passwordStream.listen((event) async {
      var storage = const FlutterSecureStorage();
      storage.write(key: "password", value: event);
      storage.write(
        key: "session",
        value: widget.authenticationRepository.interceptor.session,
      );
      widget.credentialRepository.password = event;
    });
    loadFuture = _loadState();
    autofillFuture = _loadAutofill();
    super.initState();
  }

  Future<void> _loadState() async {
    var storage = const FlutterSecureStorage();
    String? password = await storage.read(key: "password");
    String? session = await storage.read(key: "session");

    try {
      if (session != null) {
        await widget.authenticationRepository.authWithSession(session);
        widget.credentialRepository.password = password;
      }
    } catch (e) {
      //
    }
  }

  Future<bool> _loadAutofill() async {
    var service = AutofillService();
    if (await service.status() != AutofillServiceStatus.enabled) {
      return false;
    }

    var metadata = await service.getAutofillMetadata();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'BlankPassword',
      theme: ThemeData(
        primarySwatch: buildMaterialColor(const Color(0xff472D2D)),
        scaffoldBackgroundColor: buildMaterialColor(const Color(0xff472D2D)),
        fontFamily: 'Montserrat',
      ),
      onGenerateRoute: (context) => MaterialPageRoute(
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          bloc: widget.authenticationBloc,
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                if (!widget.isAutofill) {
                  _navigator.pushAndRemoveUntil<void>(
                    YourPasswordHomePageWidget.route(
                      bloc: CredentialsBloc(
                        credentialRepository: widget.credentialRepository,
                      ),
                      authenticationRepository: widget.authenticationRepository,
                      credentialRepository: widget.credentialRepository,
                    ),
                    (route) => false,
                  );
                } else {
                  _navigator.pushAndRemoveUntil<void>(
                    AutofillPasswordWidget.route(
                      bloc: CredentialsBloc(
                        credentialRepository: widget.credentialRepository,
                      ),
                      authenticationRepository: widget.authenticationRepository,
                      credentialRepository: widget.credentialRepository,
                    ),
                    (route) => false,
                  );
                }
                break;
              default:
                // case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  MaterialPageRoute(
                    builder: (_) => LoginWidget(
                      authenticationRepository: widget.authenticationRepository,
                    ),
                  ),
                  (route) => false,
                );
                break;
              // case AuthenticationStatus.unkown:
              //   break;
            }
          },
          child: child,
        );
      },
    );
  }
}
