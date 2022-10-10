import 'package:api_authentication_repository/api_authentication_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:blankpassword/auth.dart';
import 'package:blankpassword/password.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blankpassword/blocs/authentication/authentication_bloc.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:user_repository/user_repository.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  var authenticationInterceptor = ApiAuthenticationInterceptor();
  http.Client httpClient = InterceptedClient.build(interceptors: [
    authenticationInterceptor,
  ]);
  var authenticationRepository = ApiAuthenticationRepository(
    client: httpClient,
    url: "localhost:3000",
    interceptor: authenticationInterceptor,
  );
  var userRepository = UserRepository();

  runApp(MyApp(
    authenticationRepository: authenticationRepository,
    userRepository: userRepository,
  ));
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
  MyApp(
      {super.key,
      required this.authenticationRepository,
      required this.userRepository})
      : authenticationBloc = AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        );

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

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
                _navigator.pushAndRemoveUntil<void>(
                  MaterialPageRoute(
                    builder: (_) => const YourPasswordHomePageWidget(),
                  ),
                  (route) => false,
                );
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
