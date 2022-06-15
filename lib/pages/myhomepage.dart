import 'package:fruitwar/pages/memorypage.dart';
import 'package:fruitwar/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

final selectionProvider = StateProvider((ref) => fruit);
String? fruit;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

String capitalizeTrim(word) {
  var list = word.substring(13).split("").reversed.join();
  list.split('');
  var index = list.indexOf('.');

  list = list
      .substring(index += 1)
      .split("")
      .reversed
      .join()
      .toString()
      .capitalize()
      .replaceAll("_", " ");

  return list;
}

class MyHomePageState extends ConsumerState<MyHomePage> {
  List fruitList = [];

  bool isAd = true;
  @override
  void initState() {
    super.initState();
    initPath("fruit").then((value) {
      setState(() {
        for (var i = 0; i < value.length; i++) {
          fruitList.add(value[i]);
        }
      });

      fruitList = fruitList.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvided = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: (() {
            ref.read(themeProvider.notifier).state = !themeProvided;
            setthemeProvided(!themeProvided);
          }),
          icon: themeProvided
              ? const Icon(Icons.dark_mode_outlined)
              : const Icon(Icons.light_mode_outlined),
        )
      ]),
      body: isAd
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .75,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "FRUITWAR! ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvided
                                          ? Colors.teal
                                          : const Color(0xff50E3C2),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "High-Scores get discounts, and vouchers, may the odds be ever in your favor!",
                                    style: TextStyle(
                                      color: themeProvided
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (() {
                              isAd = false;

                              setState(() {});
                            }),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Press Play! ",
                                      style: TextStyle(
                                        color: themeProvided
                                            ? Colors.black
                                            : Colors.white,
                                      )),
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 20,
                                      color: Color(0xff50E3C2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Lottie.network(
                              'https://assets10.lottiefiles.com/temporary_files/EGBZKv.json'),
                          // Lottie.asset("assets/reward.json",
                          //     width: 300, height: 300),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(
                fruitList.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      ref.read(selectionProvider.notifier).state =
                          fruitList[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const MemoryGame()),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(fruitList[index]),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Text(capitalizeTrim(fruitList[index])),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
