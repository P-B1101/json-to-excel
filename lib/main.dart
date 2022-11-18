import 'package:flutter/material.dart';
import 'package:json_to_excel/injectable_container.dart';

import 'feature/js_to_excel/presentation/page/js_to_excel_page.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jsob-XLSX Converter',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.blueGrey,
        ),
      ),
      home: const JsToExcelPage(),
    );
  }
}
