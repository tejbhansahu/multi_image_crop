import 'package:flutter/material.dart';

Future<dynamic> showLoaderDialog(
  BuildContext context, {
  required String title,
  String? defaultActionText,
  String? cancelActionText,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.8),
      title: const Center(child: CircularProgressIndicator(),),
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    ),
  );
}
