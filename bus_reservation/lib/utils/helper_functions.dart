import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getFormaattedDate(DateTime dt, {String format = "yyyy-MM-dd"}) {
  return DateFormat(format).format(dt);
}

void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(
            msg,
            style: const TextStyle(fontSize: 16, color: Colors.teal),
          ),
        ),
      );
}
