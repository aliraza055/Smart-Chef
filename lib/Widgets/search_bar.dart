import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_theme.dart';

class SmartSearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const SmartSearchBar({
    super.key,
    this.hint = 'Search delicious recipes...',
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppTheme.getSurface(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.getCardShadow(context),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.getTextDark(context),
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppTheme.getTextLight(context), fontSize: 14),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppTheme.getTextLight(context),
              size: 22,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}

