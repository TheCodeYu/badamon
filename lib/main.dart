import 'dart:ui';

import 'package:badamon/blocs/bloc_wrapper.dart';
import 'package:badamon/blocs/global/global_bloc.dart';
import 'package:badamon/config/i10n.dart';
import 'package:badamon/config/router_config.dart';
import 'package:badamon/pages/splash/splash.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlocWrapper(MyApp()));
  doWhenWindowReady(() {
    final initialSize = Size(600, 450);

    appWindow.minSize = initialSize;
    appWindow.size = initialSize;

    // SetWindowPos(appWindow.handle!, HWND_TOPMOST, 0, 0, 0, 0,
    //     SWP_NOSIZE); // 设置窗体置顶，下面说明其它参数的含义
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(builder: (ctx, state) {
      return ScreenUtilInit(
          designSize: Size(600, 450),
          builder: () => MaterialApp(
              // shortcuts: <LogicalKeySet, Intent>{
              //   ...WidgetsApp.defaultShortcuts,
              //   LogicalKeySet(
              //       LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
              //   const SearchIntent(),
              // },
              // actions: <Type, Action<Intent>>{
              //   ...WidgetsApp.defaultActions,
              //   SearchIntent: ActionUnit.searchAction,
              // },
              debugShowCheckedModeBanner: false,
              onGenerateTitle: (context) => AppLocalizations.of(context)!.app,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: [
                LocaleNamesLocalizationsDelegate(),
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                const FallbackCupertinoLocalisationsDelegate(),
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: state.locale,
              localeResolutionCallback:

                  /// [supportedLocales] : supportedLocales
                  ///iOS上语言表示不一样 [en_US, zh_CN]  zh_Hans_CN languageCode-scriptCode-countryCode
                  (Locale? _locale, Iterable<Locale>? supportedLocales) {
                if (_locale != null) {
                  return _locale;
                }

                Locale locale = Locale.fromSubtags(
                    languageCode: 'zh',
                    scriptCode: 'Hans',
                    countryCode: 'CN'); //当APP不支持系统设置的语言时，设置默认语言
                /// [todo]遍历系统选择的语言是否是支持的语言,去除了脚本代码，暂时没测会不会有问题,ios系统带了脚本代码
                supportedLocales?.forEach((l) {
                  if ((l.countryCode == _locale?.countryCode) &&
                      (l.languageCode == _locale?.languageCode)) {
                    locale = Locale.fromSubtags(
                        languageCode: l.languageCode,
                        scriptCode: l.scriptCode,
                        countryCode: l.countryCode);
                  }
                });
                return locale;
              },
              onGenerateRoute: RouterConfig.onGenerateRoute,
              theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                primarySwatch: state.themeColor,
                fontFamily: state.fontFamily,
              ),
              home: MoveWindow(
                child: Splash(),
              ))
          // builder: (BuildContext context, Widget? child) {
          //   return FlutterSmartDialog(child: child);
          // },
          );
    });
  }
}
