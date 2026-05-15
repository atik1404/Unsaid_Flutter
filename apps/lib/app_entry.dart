import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:di/di.dart';
import 'package:designsystem/designsystem.dart';
import 'package:common/common.dart';
import 'package:localization/localization.dart';
import 'package:pref_storage/pref_storage.dart';

part 'theme_config.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LocalizationCubit(locator<AppStorageRepository>())),
            BlocProvider(create: (_) => ThemeCubit(locator<AppStorageRepository>())),
          ],
          child: BlocBuilder<LocalizationCubit, Locale>(
            builder: (_, locale) {
              return BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (_, themeMode) {
                  return ScreenUtilInit(
                    designSize: _getDesignSize(constraints.biggest),
                    minTextAdapt: true,
                    splitScreenMode: true,
                    builder: (context, _) {
                      return MaterialApp.router(
                        debugShowCheckedModeBanner: false,
                        title: 'Unsaid',
                        theme: _buildAppTheme(Brightness.light),
                        darkTheme: _buildAppTheme(Brightness.dark),
                        themeMode: themeMode,
                        locale: locale,
                        localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate, AppLocalizations.delegate],
                        supportedLocales: const [Locale(AppConstants.en, 'US'), Locale(AppConstants.bn, 'BD')],
                        routerConfig: router,
                      );
                    },
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
