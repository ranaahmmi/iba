import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/helper/style.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:iba/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'International Brand Distributor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: AppColors.primaryColor,
        ),
        home: MyHomePage(),
      ),
    );
  }
}