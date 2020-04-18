import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//screens
import './screens/ads_list.dart';
import './screens/ads_detail.dart';
import './screens/auth.dart' as AuthScreen;
import './screens/splash.dart';
import './screens/home.dart';
import './screens/search.dart';
import './screens/ad_create.dart';
import './screens/ad_filter.dart';
import './screens/info.dart';
import './screens/messages.dart';
import './screens/ad_user_list.dart';
//providers
import './providers/ads.dart';
import './providers/auth.dart' as AuthProvider;
// import './models/ad.dart';

void main() => runApp(Roylen());

class Roylen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider.Auth()),
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
            theme: ThemeData(
              primaryColor: Color(0xff053505),
              accentColor: Color(0xffe9a401),
              canvasColor: Color(0xfffefaee),
              cardColor: Color(0xffefefef),
              errorColor: Color(0xffee3333),
              primaryTextTheme: TextTheme(
                title: TextStyle(
                    fontSize: 28.0,
                    fontFamily: 'QuickSand',
                    color: Color(0xfffefaee)),
              ),
              textTheme: TextTheme(
                  title: TextStyle(
                    fontSize: 36.0,
                    fontFamily: 'Quicksand',
                    color: Color(0xff053505),
                  ),
                  body1: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Dosis',
                    color: Color(0xff053505),
                  ),
                  body2: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
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
              SearchScreen.routeName: (ctx) => SearchScreen(),
              AdCreate.routeName: (ctx) => AdCreate(),
              AdFilter.routeName: (ctx) => AdFilter(),
              InfoScreen.routeName: (ctx) => InfoScreen(),
              MessagesScreen.routeName: (ctx) => MessagesScreen(),
              AdUserList.routeName: (ctx) => AdUserList(),
            },
          );
        },
      ),
    );
  }
}
