import 'package:flutter/material.dart';

class UtilityBuilder {
  static Widget futureBuilderLoading<T>({required Future<T> future, required Widget Function(BuildContext buildContext, T? data) builder, Widget? onLoading}) {
    return FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return onLoading ?? const Center(child: CircularProgressIndicator());
          }
          return builder(context, snapshot.data);
        });
  }
}
