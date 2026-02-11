import 'package:flutter/material.dart';

Widget wrapWithApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}