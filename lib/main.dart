import 'package:get_me_a_tutor/import_export.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => InstituteProfileProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProfileProvider()),
        ChangeNotifierProvider(create: (_) => InstituteProvider()),
        ChangeNotifierProvider(create: (_) => JobApplicationProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => TutorAppliedJobsProvider()),
        ChangeNotifierProvider(create: (_) => TutorSearchProvider()),
        ChangeNotifierProvider(create: (_) => ParentProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Get Me A Tutor',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: GlobalVariables.backgroundColor,
            colorScheme: const ColorScheme.light(
              primary: GlobalVariables.selectedColor,
              onPrimary: Colors.white,
              secondary: Colors.white,
              onSecondary: GlobalVariables.selectBackgroundColor,
              surface: Colors.white,
              onSurface: GlobalVariables.selectBackgroundColor,
              error: Colors.red,
              onError: Colors.white,
            ),
            textTheme: GoogleFonts.robotoTextTheme(
              ThemeData.light().textTheme,
            ),
          ),
          onGenerateRoute: (settings) => generateRoute(settings),
          home: const AuthGate(),
        );
      },
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, auth, _) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Get Me A Tutor',
//           theme: ThemeData(
//             useMaterial3: true,
//             scaffoldBackgroundColor: GlobalVariables.backgroundColor,
//             colorScheme: const ColorScheme.light(
//               primary: GlobalVariables.selectedColor,
//               onPrimary: Colors.white,
//               secondary: Colors.white,
//               onSecondary: GlobalVariables.selectBackgroundColor,
//               surface: Colors.white,
//               onSurface: GlobalVariables.selectBackgroundColor,
//               error: Colors.red,
//               onError: Colors.white,
//             ),
//             textTheme: GoogleFonts.robotoTextTheme(
//               ThemeData.light().textTheme,
//             ),
//           ),
//           onGenerateRoute: (settings) => generateRoute(settings),
//           home: const HomeScreenNew(),
//         );
//       },
//     );
//   }
// }
