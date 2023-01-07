import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/theme.dart';
import '../styles/colours.dart';
import '../styles/texts.dart';

class IconMenuItem extends StatelessWidget {
  final IconData? icon;
  final IconData? subIcon;
  final String? title;
  final void Function()? onTap;
  final bool? isSelected;

  const IconMenuItem(
      {Key? key,
      this.icon,
      this.title,
      this.onTap,
      this.isSelected,
      this.subIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    AppThemes themes = Provider.of<AppThemes>(context);
    ThemeVar theme = themes.appTheme;
    TextStyling textStyling = themes.textStyling;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            margin: const EdgeInsets.symmetric(vertical: 7),
            decoration: isSelected! ? themes.nav : const BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.elasticOut,
                  switchOutCurve: Curves.elasticOut,
                  child: isSelected!
                      ? Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected! ? theme.white : theme.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : const SizedBox(width: 23),
                ),
                AnimatedDefaultTextStyle(
                  style: isSelected!
                      ? textStyling.bold18!.copyWith(
                          letterSpacing: -0.1,
                          color: theme.white,
                        )
                      : textStyling.mediumMuted18!.copyWith(
                          letterSpacing: -0.1,
                          color:
                              themes.isDark ? white.withOpacity(0.7) : primary,
                        ),
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    isSelected! ? title!.toUpperCase() : title!,
                  ),
                ),
              ],
            ),
          ),
          title == "Logout"
              ? const SizedBox.shrink()
              : Divider(
                  height: 0,
                  thickness: 0.5,
                  color: muted,
                  indent: 20,
                  endIndent: 20,
                ),
        ],
      ),
    );
  }
}
