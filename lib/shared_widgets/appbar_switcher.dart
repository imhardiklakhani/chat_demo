import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class AppBarSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AppBarSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.switcherBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _item(AppStrings.users, 0),
          _item(AppStrings.history, 1),
        ],
      ),
    );
  }

  Widget _item(String text, int index) {
    final selected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
          selected ? AppColors.switcherSelected : AppColors.switcherUnselected,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
            selected ? AppColors.textSelected : AppColors.textUnselected,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}