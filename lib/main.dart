import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//screens
import './screens/ads_list.dart';
import './screens/ads_selection.dart';
import './screens/ads_detail.dart';
import './screens/auth.dart' as AuthScreen;
import './screens/splash.dart';
import './screens/home.dart';
import './screens/ad_create.dart';
import './screens/info.dart';
import './screens/messages.dart';
import './screens/ad_user_list.dart';
//theme
import './utils/roylen_theme.dart';
//providers
import './providers/ads.dart';
import './providers/auth.dart' as AuthProvider;
import './providers/toaster.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(Roylen());
}

class Roylen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider.Auth()),
        ChangeNotifierProvider.value(value: Toaster()),
        ChangeNotifierProxyProvider<AuthProvider.Auth, Ads>(
          create: (ctx) => Ads(null, []),
          update: (ctx, auth, previousAds) =>
              Ads(auth.getUser(), previousAds.items),
        ),
      ],
      child: Consumer<AuthProvider.Auth>(
        builder: (ctx, _authData, _) {
          return MaterialApp(
            title: 'Roylen',
            theme: RoylenTheme.getThemeData(),
            home: _authData.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: _authData.tryAutoLogin(),
                    builder: (ctx, authResult) =>
                        authResult.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : HomeScreen(),
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
              AdsSelection.routeName: (ctx) => AdsSelection(ReturnMode.Search)
            },
          );
        },
      ),
    );
  }
}
