import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nubank_clone/constants/app_colors.dart';
import 'package:nubank_clone/constants/fonts.gen.dart';
import 'package:nubank_clone/core/app_state.dart';
import 'package:nubank_clone/pages/home/home_screen.dart';
import 'package:nubank_clone/theme/texts.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    );

    return ChangeNotifierProvider(
      create: (context) => AppState()..load(),
      child: Consumer<AppState>(
        builder: (context, state, _) => MaterialApp(
          title: 'Nubank Clone',
          debugShowCheckedModeBanner: false,
          themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: false,
            fontFamily: FontFamily.gothamSSm,
            textTheme: customTextTheme,
            scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          ),
          darkTheme: ThemeData(
            useMaterial3: false,
            brightness: Brightness.dark,
            fontFamily: FontFamily.gothamSSm,
            textTheme: customTextThemeDark,
            scaffoldBackgroundColor: AppColors.darkBackground,
            canvasColor: AppColors.darkBackground,
            colorScheme: const ColorScheme.dark(
              surface: AppColors.darkBackground,
              primary: AppColors.primary,
            ),
          ),
          home: HomeScreen(),
        ),
      ),
    );
  }
}
