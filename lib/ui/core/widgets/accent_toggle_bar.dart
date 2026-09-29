import 'package:flutter/material.dart';
import '../../../domain/models/accent_type.dart';
import '../theme/app_theme.dart';

class AccentToggleBar extends StatelessWidget {
  final AccentType currentAccent;
  final ValueChanged<AccentType> onAccentChanged;

  const AccentToggleBar({
    super.key,
    required this.currentAccent,
    required this.onAccentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            accent: AccentType.british,
            label: '英音 (RP)',
            flag: '🇬🇧',
            isSelected: currentAccent == AccentType.british,
          ),
          const SizedBox(width: 4),
          _buildItem(
            accent: AccentType.american,
            label: '美音 (GA)',
            flag: '🇺🇸',
            isSelected: currentAccent == AccentType.american,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required AccentType accent,
    required String label,
    required String flag,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onAccentChanged(accent),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
