import 'package:get_me_a_tutor/import_export.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hintText;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.itemLabel,
    required this.onChanged,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      validator: validator ??
              (val) {
            if (val == null) {
              return 'Select $hintText';
            }
            return null;
          },
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: GlobalVariables.secondaryTextColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: GlobalVariables.secondaryTextColor),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: GlobalVariables.secondaryTextColor)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabel(item),
            style: TextStyle(
              color: GlobalVariables.primaryTextColor,
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}
