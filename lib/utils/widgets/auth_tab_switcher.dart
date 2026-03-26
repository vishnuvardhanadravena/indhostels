import 'package:flutter/material.dart';
import 'package:indhostels/utils/theame/app_themes.dart';
import 'package:indhostels/utils/theame/dimensions.dart';

class AuthTabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final List<String> tabs;
  final bool isTab;
  final void Function(int) onTabSelected;

  const AuthTabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.tabs,
    required this.isTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 60,
      width: isTab ? MediaQuery.of(context).size.width / 2 : double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: AppColors.primaryFaded,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => onTabSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha:0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w800,
                    color: isSelected ? AppColors.white : AppColors.black,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
