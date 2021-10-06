import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:news/screens/web_view_screen.dart';
import 'package:news/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'package:news/providers/providers.dart';
import 'package:news/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UtilityBuilder.futureBuilderLoading(
      future: Firebase.initializeApp(),
      builder: (context, data) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<NewsProvider>(
              create: (_) => NewsProvider(),
            ),
            ChangeNotifierProvider<SettingsProvider>(
              create: (_) => SettingsProvider(),
            ),
          ],
          child: MaterialApp(
            routes: {
              "/": (context) => const HomeScreen(),
              "/web-view": (context) => WebViewScreen(),
            },
          ),
        );
      },
    );
  }
}
