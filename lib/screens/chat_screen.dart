import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news/screens/auth_screen.dart';

import 'package:news/widgets/messages.dart';
import 'package:news/widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Messages(),
                ),
                NewMessage(),
              ],
            );
          }
          return AuthScreen();
        });
  }
}
