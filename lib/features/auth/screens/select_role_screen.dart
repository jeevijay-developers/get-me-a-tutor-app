import 'package:get_me_a_tutor/import_export.dart';

class SelectRoleScreen extends StatefulWidget {
  static const String routeName = '/selectRoleScreen';
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 393;

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.all(16 * scaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      size: 32 * scaleFactor,
                      color: GlobalVariables.primaryTextColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(height: 16 * scaleFactor),
                  // Title
                  PrimaryText(text: 'Select Your Role', size: 28 * scaleFactor),
                  SizedBox(height: 8 * scaleFactor),
                  // Subtitle
                  SecondaryText(
                    text:
                        'Choose the profile that best describes you to personalize your experience.',
                    size: 14 * scaleFactor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24 * scaleFactor),
            // Role Cards Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16 * scaleFactor),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _RoleCard(
                        title: 'Tutor',
                        description: 'I want to teach students.',
                        icon: Icons.school,
                        isSelected: _selectedRole == 'Tutor',
                        onTap: () {
                          setState(() {
                            _selectedRole = 'Tutor';
                          });
                        },
                        scaleFactor: scaleFactor,
                      ),
                      _RoleCard(
                        title: 'Parent',
                        description: 'I am looking for a tutor.',
                        icon: Icons.family_restroom,
                        isSelected: _selectedRole == 'Parent',
                        onTap: () {
                          setState(() {
                            _selectedRole = 'Parent';
                          });
                        },
                        scaleFactor: scaleFactor,
                      ),
                      _RoleCard(
                        title: 'Institute',
                        description: 'I manage a learning center.',
                        icon: Icons.business,
                        isSelected: _selectedRole == 'Institute',
                        onTap: () {
                          setState(() {
                            _selectedRole = 'Institute';
                          });
                        },
                        scaleFactor: scaleFactor,
                      ),
                      _RoleCard(
                        title: 'Student',
                        description: "I am a student.",
                        icon: Icons.business,
                        isSelected: _selectedRole == 'Student',
                        onTap: () {
                          setState(() {
                            _selectedRole = 'Student';
                          });
                        },
                        scaleFactor: scaleFactor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Continue Button Section
            Padding(
              padding: EdgeInsets.all(16 * scaleFactor),
              child: SizedBox(
                width: double.infinity,
                height: 56 * scaleFactor,
                child: CustomButton(
                  text: 'Continue',
                  onTap: () {
                    if (_selectedRole != null) {
                      Navigator.pushNamed(
                        context,
                        SignUpDetailsScreen.routeName,
                        arguments: _selectedRole,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Inline Role Card Widget
class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final double scaleFactor;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16 * scaleFactor),
        padding: EdgeInsets.all(16 * scaleFactor),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12 * scaleFactor),
          border: isSelected
              ? Border.all(
                  color: GlobalVariables.selectedColor,
                  width: 2 * scaleFactor,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: GlobalVariables.selectBackgroundColor.withOpacity(
                      0.5,
                    ),
                    blurRadius: 8 * scaleFactor,
                    spreadRadius: 2 * scaleFactor,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4 * scaleFactor,
                    spreadRadius: 1 * scaleFactor,
                  ),
                ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 48 * scaleFactor,
              height: 48 * scaleFactor,
              decoration: BoxDecoration(
                color: isSelected
                    ? GlobalVariables.selectBackgroundColor
                    : const Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: GlobalVariables.primaryTextColor,
                size: 24 * scaleFactor,
              ),
            ),
            SizedBox(width: 16 * scaleFactor),
            // Title and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 16 * scaleFactor,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 4 * scaleFactor),
                  Text(
                    description,
                    style: GoogleFonts.roboto(
                      fontSize: 14 * scaleFactor,
                      fontWeight: FontWeight.normal,
                      color: GlobalVariables.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            // Checkmark (only if selected)
            if (isSelected)
              Container(
                width: 24 * scaleFactor,
                height: 24 * scaleFactor,
                decoration: BoxDecoration(
                  color: GlobalVariables.selectedColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16 * scaleFactor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
