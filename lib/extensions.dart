import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateFormating on DateTime {
  String formattedDate() {
    return '${DateFormat.Hm().format(this)}, ${DateFormat.MMMd().format(this)}';
  }
}
