// import 'dart:js';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supppro/barcode/barcode_list_scanner_controller.dart';
import 'package:supppro/productCard.dart';
import 'package:supppro/providers/app_state.dart';
import 'package:supppro/providers/suppItem.dart';
import 'package:supppro/screens/goal_rank_screen.dart';
import 'package:supppro/screens/gptscreen.dart';
import 'package:supppro/screens/home_screen.dart';
import 'package:supppro/screens/landing_screen.dart';
import 'package:supppro/screens/purpose_selection_screen.dart';
import 'package:supppro/screens/scan_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ApplicationState>(
          create: (_) => ApplicationState(),
        ),
      ],
      child: Builder(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<SuppItems>(
              create: (_) => SuppItems(),
            ),
          ],
          child: const MyApp(),
        ),
      ),
    ),
  );
}

// Add GoRouter configuration outside the App class
final _router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const landingScreen(),
    routes: [
      GoRoute(
        path: 'home-screen',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: 'sign-in',
        builder: (context, state) {
          return SingUpLogInScreen();
        },
        routes: [
          GoRoute(
            path: 'forgot-password',
            builder: (context, state) {
              final arguments = state.queryParams;
              return ForgotPasswordScreen(
                email: arguments['email'],
                headerMaxExtent: 200,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: 'profile',
        builder: (context, state) {
          return ProfileScreen(
            providers: const [],
            actions: [
              SignedOutAction((context) {
                context.pushReplacement('/');
              }),
            ],
          );
        },
      ),
      GoRoute(
          path: 'scan-barcode',
          builder: (context, state) {
            return scanScreen();
          },
          routes: [
            GoRoute(
                path: 'camera-page',
                builder: (context, state) {
                  return BarcodeListScannerWithController();
                })
          ]),
      GoRoute(path: 'view-detail', builder: (context, state) => ProductCard()),
      GoRoute(path: 'gpt-query', builder: (context, state) => gptScreen()),
      GoRoute(
          path: 'goal-select',
          builder: (context, state) => PurposeSelectionPage()),
    ],
  ),
]);

SignInScreen SingUpLogInScreen() {
  return SignInScreen(
    actions: [
      ForgotPasswordAction(((context, email) {
        final uri = Uri(
          path: '/sign-in/forgot-password',
          queryParameters: <String, String?>{
            'email': email,
          },
        );
        context.push(uri.toString());
      })),
      AuthStateChangeAction(((context, state) {
        if (state is SignedIn || state is UserCreated) {
          var user = (state is SignedIn)
              ? state.user
              : (state as UserCreated).credential.user;
          if (user == null) {
            return;
          }
          if (state is UserCreated) {
            user.updateDisplayName(user.email!.split('@')[0]);
          }
          if (!user.emailVerified) {
            user.sendEmailVerification();
            const snackBar = SnackBar(
                content: Text(
                    'Please check your email to verify your email address'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          context.pushReplacement('/scan-barcode');
        }
      })),
    ],
  );
}

// end of GoRouter configuration

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      title: 'Supo Pro',
      theme: FlexThemeData.light(scheme: FlexScheme.damask),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.damask),
      themeMode: ThemeMode.system,
      routerConfig: _router,
      // routes: {
      //  LogInScreen.routeName: (ctx) => LogInScreen(),
      // },
    );
  }
}

//UI: Give an image instruction when enter the barcode
//gpt but with careful wording 
// Prompt + profile : the nature of supps 