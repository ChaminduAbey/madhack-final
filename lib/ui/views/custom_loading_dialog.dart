import 'package:flutter/material.dart';

class CustomLoadingDialog {
  static void show(BuildContext context, {String? message}) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(message ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
