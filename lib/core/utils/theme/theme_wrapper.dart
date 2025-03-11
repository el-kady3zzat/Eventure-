// lib/core/utils/theme/theme_wrapper.dart
import 'package:eventure/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeWrapper extends StatelessWidget {
  final Widget child;

  const ThemeWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return Theme(
            data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
            child: child,
          );
        },
      ),
    );
  }
}