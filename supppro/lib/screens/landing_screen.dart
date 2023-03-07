import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supppro/screens/scan_screen.dart';

import '../main.dart';
import '../providers/app_state.dart';
import '../src/authentication.dart';
import '../src/widgets.dart';

class landingScreen extends StatefulWidget {
  const landingScreen({super.key});

  @override
  State<landingScreen> createState() => _landingScreenState();
}

class _landingScreenState extends State<landingScreen> {
  final _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/images/landing_bg.png',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        PageView(
          controller: _controller,
          children: const [
            MyPage1Widget(),
            MyPage2Widget(),
            MyPage3Widget(),
          ],
        )
      ]),
    );
  }
}

class MyPage1Widget extends StatelessWidget {
  const MyPage1Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            child: Stack(children: <Widget>[
          Positioned(
              top: 370,
              left: 30,
              child: Column(children: [
                Text(
                  "All-in-one solution for",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 20),
                ),
              ])),
          Positioned(
              top: 400,
              left: 30,
              child: Column(children: [
                Text(
                  "researching and managing",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 20),
                ),
              ])),
          Positioned(
              top: 430,
              left: 30,
              child: Column(children: [
                Text(
                  "OTC drugs and supplements",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 20),
                ),
              ])),
          Positioned(
              top: 850,
              left: 350,
              child: Column(children: [
                Text(
                  ">>>",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ])),
          Positioned(
              top: 0,
              left: 6,
              child: Container(
                  width: 284,
                  height: 294,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Rectangle.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
              top: 300,
              left: 30,
              child: Column(children: [
                Text(
                  "SuppPro",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 50),
                ),
              ])),

          //researching and managing OTC drugs and supplements
          Positioned(
              top: 300,
              left: 310,
              child: Container(
                  width: 186,
                  height: 199,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/image3.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
              top: 650,
              left: 0,
              child: Container(
                  width: 272,
                  height: 281,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/image4.png'),
                        fit: BoxFit.fitWidth),
                  ))),
        ]))
      ],
    );
  }
}

class MyPage2Widget extends StatelessWidget {
  const MyPage2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 390,
        height: 844,
        child: Stack(children: <Widget>[
          Positioned(
              top: 850,
              left: 350,
              child: Column(children: [
                Text(
                  ">>>",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ])),
          Positioned(
              top: 100,
              left: 30,
              child: Column(children: [
                Text('Scan barcode to get ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 130,
              left: 30,
              child: Column(children: [
                Text('information and add ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 160,
              left: 30,
              child: Column(children: [
                Text('it to your profile with',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 300,
              left: 160,
              child: Column(children: [
                Text('Verified data from ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 330,
              left: 160,
              child: Column(children: [
                Text('National Institutes of ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 360,
              left: 160,
              child: Column(children: [
                Text('Health',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 190,
              left: 30,
              child: Column(children: [
                Text('one click',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 500,
              left: 30,
              child: Column(children: [
                Text('Layman\'s description',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 530,
              left: 30,
              child: Column(children: [
                Text('with multilingual ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 560,
              left: 30,
              child: Column(children: [
                Text('support ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 690,
              left: 200,
              child: Column(children: [
                Text(' Prevent unexpected ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 720,
              left: 200,
              child: Column(children: [
                Text('drug interactions  ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20)),
              ])),
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                  width: 390,
                  height: 844,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 251,
                        left: -17,
                        child: Container(
                            width: 223,
                            height: 209,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/verified.png'),
                                  fit: BoxFit.fitWidth),
                            ))),
                    Positioned(
                        top: 618,
                        left: 0,
                        child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/rejected.png'),
                                  fit: BoxFit.fitWidth),
                            ))),
                    Positioned(
                        top: 471,
                        left: 226,
                        child: Container(
                            width: 164,
                            height: 164,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/language.png'),
                                  fit: BoxFit.fitWidth),
                            ))),
                    Positioned(
                        top: 65,
                        left: 220,
                        child: Container(
                            width: 186,
                            height: 186,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/barcode.png'),
                                  fit: BoxFit.fitWidth),
                            ))),
                  ]))),
          Consumer<ApplicationState>(builder: (context, appState, _)
              // =>SingUpLogInScreen()

              {
            bool loggedIn = appState.loggedIn;

            return appState.loggedIn
                ? scanScreen()
                : Column(
                    children: [
                      Spacer(),
                      Center(
                        child: Row(
                          children: [
                            Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    !loggedIn
                                        ? context.push('/sign-in')
                                        : FirebaseAuth.instance.signOut();
                                    ;
                                  },
                                  child: !loggedIn
                                      ? const Text('SIGN IN')
                                      : const Text('Logout')),
                            ),
                            Visibility(
                              visible: loggedIn,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, bottom: 8),
                                child: StyledButton(
                                    onPressed: () {
                                      context.push('/profile');
                                    },
                                    child: const Text('Profile')),
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  );
          })
        ]));
  }
}

class MyPage3Widget extends StatelessWidget {
  const MyPage3Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _)
        // =>SingUpLogInScreen()

        {
      return appState.loggedIn
          ? scanScreen()
          : AuthFunc(
              loggedIn: appState.loggedIn,
              signOut: () {
                FirebaseAuth.instance.signOut();
              });
    });
  }
}
