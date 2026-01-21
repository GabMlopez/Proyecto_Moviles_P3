import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalizedAppBar extends StatelessWidget implements PreferredSizeWidget{
  final Widget? leading;
  final Widget title;
  final List<Widget>? actions;
  final double height;
  final Widget? bottom;

  const PersonalizedAppBar ({
    super.key,
    this.leading,
    required this.title,
    this.actions,
    this.height = 120,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(height + (bottom != null ? 60 : 0));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  leading ?? const BackButton(color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: title),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          ),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }
}