import 'dart:ui';
import 'package:fruitwar/pages/myhomepage.dart';
import 'package:fruitwar/shared_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool? isLight;
final themeProvider = StateProvider((_) => isLight ?? true);
void main() {
  if (kIsWeb) {
    runApp(const ProviderScope(
        child:
            Center(child: SizedBox(width: 400, height: 800, child: MyApp()))));
  } else {
    runApp(const ProviderScope(child: MyApp()));
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    initSharedPrefs().then((value) {
      ref.read(themeProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvided = ref.watch(themeProvider);
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'fruitwar',
      theme: themeProvided
          ? ThemeData(
              cardColor: Colors.grey[200],
              scaffoldBackgroundColor: Colors.indigo[100],
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(primary: Colors.indigo[500]),
            )
          : ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
