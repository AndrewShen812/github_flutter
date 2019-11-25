import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:github_flutter/i10n/localization_intl.dart';
import 'package:github_flutter/models/profile_change_notifier.dart';
import 'package:github_flutter/routes/home_page.dart';
import 'package:github_flutter/routes/language_page.dart';
import 'package:github_flutter/routes/login_page.dart';
import 'package:github_flutter/routes/theme_page.dart';
import 'package:provider/provider.dart';

import 'common/global.dart';

void main() => Global.init().then((value) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: LocaleModel()),
        ChangeNotifierProvider.value(value: UserModel()),
      ],
      child: Consumer2<ThemeModel, LocaleModel>(
          builder: (context, themeModel, localeModel, child) {
        return MaterialApp(
          title: 'Github Flutter',
          theme: ThemeData(
            primarySwatch: themeModel.theme,
          ),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            // 注册自定义delegate
            GhLocalizetionsDelegate()
          ],
          // 支持的语言
          supportedLocales: [
            const Locale('zh', 'CN'),
            const Locale('en', 'US'),
          ],
          locale: localeModel.getLocale(),
          localeListResolutionCallback:
              (List<Locale> locales, Iterable<Locale> supportedLocales) {
            if (localeModel.getLocale() != null) {
              return localeModel.getLocale();
            } else {
              Locale locale;
              bool supported = false;
              for (Locale loc in locales) {
                if (supportedLocales.contains(loc)) {
                  locale = loc;
                  supported = true;
                  break;
                }
              }
              if (!supported) {
                locale = Locale('zh', 'CN');
              }
              return locale;
            }
          },
          home: HomeRoute(),
          routes: <String, WidgetBuilder>{
            "login": (context) => LoginRoute(),
            "themes": (context) => ThemeChangeRoute(),
            "language": (context) => LanguageRoute(),
          },
        );
      }),
    );
  }
}
