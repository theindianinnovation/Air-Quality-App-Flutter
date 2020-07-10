import 'package:flutter/material.dart';
import 'package:air_pollution/ui/home_page.dart';
import 'package:air_pollution/app/app_theme.dart';

class SmogeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemeDataFactory.prepareThemeData(),
      home: MyHomePage(),
    );
  }
}