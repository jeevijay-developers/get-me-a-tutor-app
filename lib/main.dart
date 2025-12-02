import 'package:get_me_a_tutor/import_export.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Get Me A Tutor',
//       theme: ThemeData(
//         useMaterial3: true,
//         scaffoldBackgroundColor: GlobalVariables.backgroundColor,
//         colorScheme: ColorScheme.light(
//           primary: Colors.black,
//           onPrimary: Colors.white,
//           secondary: Colors.white,
//           onSecondary: Colors.black,
//           surface: Colors.white,
//           onSurface: Colors.black,
//           error: Colors.red,
//           onError: Colors.white,
//         ),
//         textTheme: GoogleFonts.robotoTextTheme(
//           ThemeData.light().textTheme,
//         ),
//       ),
//       onGenerateRoute: (settings) => generateRoute(settings),
//       home: const HomeScreen(),
//     );
//   }
// }
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
              primary: GlobalVariables.appGreenDark,
              onPrimary: Colors.white,
              secondary: Colors.white,
              onSecondary: GlobalVariables.appGreenDark,
              surface: Colors.white,
              onSurface: GlobalVariables.appGreenDark,
              error: Colors.red,
              onError: Colors.white,
            ),
            textTheme: GoogleFonts.robotoTextTheme(
              ThemeData.light().textTheme,
            ),
          ),
          onGenerateRoute: (settings) => generateRoute(settings),
          home: auth.isLoggedIn ? const Dashboard() : const HomeScreen(),
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
//         // WAIT FOR TOKEN TO LOAD BEFORE SHOWING APP
//         if (!auth.isInitialized) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             home: Scaffold(
//               backgroundColor: GlobalVariables.backgroundColor,
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           );
//         }
//
//         // NOW SHOW THE ACTUAL APP
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Get Me A Tutor',
//           theme: ThemeData(
//             useMaterial3: true,
//             scaffoldBackgroundColor: GlobalVariables.backgroundColor,
//             colorScheme: const ColorScheme.light(
//               primary: Colors.black,
//               onPrimary: Colors.white,
//               secondary: Colors.white,
//               onSecondary: Colors.black,
//               surface: Colors.white,
//               onSurface: Colors.black,
//               error: Colors.red,
//               onError: Colors.white,
//             ),
//             textTheme: GoogleFonts.robotoTextTheme(
//               ThemeData.light().textTheme,
//             ),
//           ),
//           onGenerateRoute: (settings) => generateRoute(settings),
//           home: auth.isLoggedIn ? const Dashboard() : const HomeScreen(),
//         );
//       },
//     );
//   }
// }

