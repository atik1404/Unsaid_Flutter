import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/app_locale.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:di/di.dart';
import 'package:designsystem/designsystem.dart';

part 'theme_config.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MultiBlocProvider(
          providers: [BlocProvider(create: (context) => LocaleCubit())],
          child: BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return ScreenUtilInit(
                designSize: _getDesignSize(constraints.biggest),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, _) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    title: 'Foundry Flutter',
                    theme: _buildAppTheme(Brightness.light),
                    darkTheme: _buildAppTheme(Brightness.dark),
                    locale: locale,
                    localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate, AppLocale.delegate],
                    supportedLocales: const [Locale('en', 'US'), Locale('bn', 'BD')],
                    routerConfig: router,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
