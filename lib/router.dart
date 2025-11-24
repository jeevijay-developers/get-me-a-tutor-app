import 'package:get_me_a_tutor/import_export.dart';
Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignUpScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );
    case OtpVerifyScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OtpVerifyScreen(),
      );
    case Dashboard.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Dashboard(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>
        const Scaffold(body: Center(child: Text('Screen does not exist'))),
      );
  }
}
