import 'package:get_me_a_tutor/import_export.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // ⏳ While loading token from SharedPreferences
    if (auth.token == null && auth.role == null) {
      // token not loaded yet OR user not logged in
      return const HomeScreenNew();
    }

    // ✅ Token + role exist → route to dashboard
    if (auth.token != null && auth.role != null) {
      switch (auth.role) {
        case 'student':
          return const StudentDashboard();

        case 'tutor':
          return auth.hasTeacherProfile ? const TeacherDashboard() : TeacherProfileCreateScreen();

        case 'parent':
          return auth.hasParentProfile ?  ParentDashboard() : ParentProfileCreateScreen();

        case 'institute':
          return auth.hasInstituteProfile ?  InstituteDashboard() : InstituteProfileCreateScreen();

        default:
          return const HomeScreenNew();
      }
    }

    // fallback
    return const HomeScreenNew();
  }
}
