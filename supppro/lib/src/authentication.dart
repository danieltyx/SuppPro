// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Center(
            child: Row(
              children: [
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        !loggedIn ? context.push('/sign-in') : signOut();
                      },
                      child: !loggedIn
                          ? const Text('SIGN IN')
                          : const Text('Logout')),
                ),
                Visibility(
                  visible: loggedIn,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, bottom: 8),
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
      ),
    );
  }
}
