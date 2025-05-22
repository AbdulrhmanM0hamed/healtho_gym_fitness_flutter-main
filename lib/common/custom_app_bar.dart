
import 'package:flutter/material.dart';
import 'package:healtho_gym/core/constant/font_manger.dart';
import 'package:healtho_gym/core/constant/styles_manger.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.centerTitle = true,
    this.leading,
    this.backgroundColor,
    this.titleColor,
    this.elevation,
    this.automaticallyImplyLeading = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title!,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: 20,
          color: titleColor ?? Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading ??
          (automaticallyImplyLeading && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios , color: Colors.white,),
                  onPressed: () => Navigator.pop(context),
                )
              : null),
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 0,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}
