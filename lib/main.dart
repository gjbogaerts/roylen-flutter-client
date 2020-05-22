import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
//screens
import './screens/ads_list.dart';
import './screens/ads_search.dart';
import './screens/ads_favorites.dart';
import './screens/ads_filters.dart';
import './screens/ads_detail.dart';
import './screens/auth.dart' as AuthScreen;
import './screens/splash.dart';
import './screens/home.dart';
import './screens/ad_create.dart';
import './screens/info.dart';
import './screens/messages.dart';
import './screens/ad_user_list.dart';
import './screens/auth_password_reset.dart';
import './screens/auth_profile.dart';
import './screens/on_boarding.dart';
//theme
import './utils/roylen_theme.dart';
//providers
import './providers/ads.dart';
import './providers/auth.dart' as AuthProvider;
import './providers/toaster.dart';
import './providers/messages.dart';
import './providers/offers.dart';
//error reporting
import './utils/error_reporting.dart';

ErrorReporting sentry = ErrorReporting();

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (sentry.isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  bool showOnBoarding;
  if (prefs.containsKey('showOnBoarding')) {
    showOnBoarding = prefs.getBool('showOnBoarding');
  } else {
    showOnBoarding = true;
  }
  prefs.setBool('showOnBoarding', false);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runZonedGuarded(() async {
    runApp(Roylen(showOnBoarding));
  }, (error, stackTrace) async {
    await (sentry.reportError(error, stackTrace));
  });
  // runZoned<Future<Null>>(() async {
  //   runApp(Roylen(showOnBoarding));
  // }, onError: (error, stackTrace) async {
  //   await (sentry.reportError(error, stackTrace));
  // });
  // runApp(Roylen());
}

class Roylen extends StatelessWidget {
  final bool _showOnBoarding;
  Roylen(this._showOnBoarding);

  @override
  Widget build(BuildContext context) {
    // _showOnBoarding = true;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider.Auth()),
        ChangeNotifierProvider.value(value: Toaster()),
        ChangeNotifierProxyProvider<AuthProvider.Auth, Messages>(
          create: (ctx) => Messages(null, []),
          update: (ctx, auth, previousMessages) =>
              Messages(auth.getUser(), previousMessages.items),
        ),
        ChangeNotifierProxyProvider<AuthProvider.Auth, Offers>(
          create: (ctx) => Offers(null, []),
          update: (ctx, auth, previousOffers) =>
              Offers(auth.getUser(), previousOffers.offers),
        ),
        ChangeNotifierProxyProvider<AuthProvider.Auth, Ads>(
          create: (ctx) => Ads(null, []),
          update: (ctx, auth, previousAds) =>
              Ads(auth.getUser(), previousAds.items),
        ),
      ],
      child: Consumer<AuthProvider.Auth>(
        builder: (ctx, _authData, _) {
          return MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('nl', 'NL')
            ],
            title: 'Roylen',
            theme: RoylenTheme.getThemeData(),
            home: _showOnBoarding
                ? I18n(child: OnBoarding())
                : _authData.isAuth
                    ? I18n(child: HomeScreen())
                    : FutureBuilder(
                        future: _authData.tryAutoLogin(),
                        builder: (ctx, authResult) =>
                            authResult.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : I18n(child: HomeScreen()),
                      ),
            routes: {
              HomeScreen.routeName: (ctx) => HomeScreen(),
              AdsList.routeName: (ctx) => AdsList(),
              AdsDetail.routeName: (ctx) => AdsDetail(),
              AuthScreen.Auth.routeName: (ctx) => AuthScreen.Auth(),
              AdCreate.routeName: (ctx) => AdCreate(),
              InfoScreen.routeName: (ctx) => InfoScreen(),
              MessagesScreen.routeName: (ctx) => MessagesScreen(),
              AdUserList.routeName: (ctx) => AdUserList(),
              AdsSearch.routeName: (ctx) => AdsSearch(null),
              AdsFavorites.routeName: (ctx) => AdsFavorites(),
              AdsFilters.routeName: (ctx) => AdsFilters(null),
              AuthPasswordReset.routeName: (ctx) => AuthPasswordReset(),
              AuthProfile.routeName: (ctx) => AuthProfile()
            },
          );
        },
      ),
    );
  }
}
