import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:fruitwar/main.dart';
import 'package:fruitwar/models/highScore.dart';
import 'package:fruitwar/pages/myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/memory.dart';
import '../shared_pref.dart';

class MemoryGame extends ConsumerStatefulWidget {
  const MemoryGame({Key? key}) : super(key: key);

  @override
  MemoryGameState createState() => MemoryGameState();
}

class MemoryGameState extends ConsumerState<MemoryGame> {
  late ConfettiController _controllerCenter;
  List<Memory> userList = [];
  List<HighScore> highScores = [
    // HighScore(taps: 28, time: 23, isCurrent: false)
  ];
  String firstSelection = '';
  String secondSelection = '';
  int? firstIndex;
  int? secondIndex;
  int matchCounter = 0;
  int tapCounter = 0;
  bool isMatch = false;
  bool isEnabled = true;

  final stopwatch = Stopwatch();
  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    if (userList.isEmpty) {
      initPath("images").then((value) {
        setState(() {
          for (var i = 0; i <= 7; i++) {
            if (value[i].toString().contains("lego")) {
              userList.add(Memory(
                assetPath: value[i],
                iSelected: false,
              ));
              userList.add(Memory(
                assetPath: value[i],
                iSelected: false,
              ));
            }
          }
          userList.shuffle();
        });
      });
      highScores = loadHighScores();
      highScores.forEach(
        (element) => print(element.toJson()),
      );
    }
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvided = ref.watch(themeProvider);
    final selectedFruit = ref.watch(selectionProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (() {
                highScores = loadHighScores();
                for (var i = 0; i < userList.length; i++) {
                  userList[i].iSelected = false;
                }
                for (var i = 0; i < highScores.length; i++) {
                  if (highScores[i].isCurrent! == "true") {
                    highScores[i].isCurrent = "false";
                  }
                }
                matchCounter = 0;
                tapCounter = 0;
                userList.shuffle();
                stopwatch.reset();

                setState(() {});
              }),
              icon: const Icon(Icons.restore))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: matchCounter < 8
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(selectedFruit.toString()),
                      radius: 50,
                    ),
                  ),
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Timer in Seconds: ${stopwatch.elapsed.inSeconds}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Taps: $tapCounter"),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      children: List.generate(
                        userList.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: isEnabled
                                ? () {
                                    tapCounter++;
                                    matchCounter == 0
                                        ? {
                                            stopwatch.start(),
                                            for (var i = 0;
                                                i < highScores.length;
                                                i++)
                                              {
                                                if (highScores[i].isCurrent! ==
                                                    "true")
                                                  {
                                                    highScores[i].isCurrent =
                                                        "false",
                                                  }
                                              }
                                          }
                                        : null;
                                    if (firstSelection == "") {
                                      firstSelection =
                                          userList[index].assetPath.toString();
                                      userList[index].iSelected = true;
                                      firstIndex = index;
                                      setState(() {});
                                    } else {
                                      secondSelection =
                                          userList[index].assetPath.toString();
                                      userList[index].iSelected = true;
                                      secondIndex = index;
                                      setState(() {});
                                    }
                                    if (firstSelection != "" &&
                                        firstSelection == secondSelection) {
                                      matchCounter++;
                                      //win

                                      bool isHighScore = false;
                                      matchCounter == 8
                                          ? {
                                              stopwatch.stop(),
                                              _controllerCenter.play(),
                                              if (highScores.length < 3)
                                                {
                                                  highScores.add(HighScore(
                                                      isCurrent: "true",
                                                      taps:
                                                          tapCounter.toString(),
                                                      time: stopwatch
                                                          .elapsed.inSeconds
                                                          .toString())),
                                                  highScores.sort(
                                                    ((a, b) {
                                                      var r = a.time!
                                                          .compareTo(b.time!);
                                                      if (r != 0) return r;
                                                      return a.time!
                                                          .compareTo(b.time!);
                                                    }),
                                                  ),
                                                  saveHighScores(),
                                                }
                                              else
                                                {
                                                  for (var i = 0;
                                                      i < highScores.length;
                                                      i++)
                                                    {
                                                      if (int.parse(
                                                              highScores[i]
                                                                  .time!) >
                                                          stopwatch.elapsed
                                                              .inSeconds)
                                                        {
                                                          isHighScore = true,
                                                        }
                                                    },
                                                  if (isHighScore)
                                                    {
                                                      highScores.add(HighScore(
                                                          isCurrent: "true",
                                                          taps: tapCounter
                                                              .toString(),
                                                          time: stopwatch
                                                              .elapsed.inSeconds
                                                              .toString())),
                                                      highScores.sort(
                                                        ((a, b) {
                                                          var r = a.time!
                                                              .compareTo(
                                                                  b.time!);
                                                          if (r != 0) {
                                                            return r;
                                                          }
                                                          return a.time!
                                                              .compareTo(
                                                                  b.time!);
                                                        }),
                                                      ),
                                                      highScores.removeLast(),
                                                      highScores.forEach(
                                                        (element) => print(
                                                            element.toJson()),
                                                      ),
                                                      saveHighScores(),
                                                      highScores.forEach(
                                                        (element) => print(
                                                            element.toJson()),
                                                      ),
                                                    }
                                                }
                                            }
                                          : null;
                                      firstSelection = "";
                                      secondSelection = "";
                                    } else if (secondSelection != "" &&
                                        firstSelection != secondSelection) {
                                      isEnabled = false;
                                      Timer(
                                        const Duration(seconds: 1),
                                        () {
                                          userList[secondIndex ?? 0].iSelected =
                                              false;
                                          userList[firstIndex ?? 0].iSelected =
                                              false;
                                          firstSelection = "";
                                          secondSelection = "";
                                          isEnabled = true;
                                          setState(() {});
                                        },
                                      );
                                    }
                                  }
                                : null,
                            child: userList[index].iSelected!
                                ? CircleAvatar(
                                    backgroundImage: AssetImage(
                                        userList[index].assetPath.toString()),
                                  )
                                : const CircleAvatar(
                                    backgroundColor: Color(0xff50E3C2),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Card(
                    child: Center(
                        child: Column(
                      children: [
                        ConfettiWidget(
                          confettiController: _controllerCenter,
                          blastDirectionality: BlastDirectionality.explosive,
                          shouldLoop: true,
                          createParticlePath: drawStar,
                          gravity: 0.1,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              themeProvided
                                  ? const Text("You Won!",
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.teal))
                                  : const Text(
                                      "You Won!",
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Color(0xff50E3C2)),
                                    ),
                              const Text(
                                "Your Score: ",
                                style: TextStyle(fontSize: 20),
                              ),
                              themeProvided
                                  ? Text(
                                      "Time: ${stopwatch.elapsed.inSeconds}, Taps: $tapCounter",
                                      style:
                                          const TextStyle(color: Colors.blue))
                                  : Text(
                                      "Time: ${stopwatch.elapsed.inSeconds}, Taps: $tapCounter",
                                      style: const TextStyle(
                                          color: Colors.yellow)),
                              themeProvided
                                  ? const Text("High-Scores!",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.teal))
                                  : const Text(
                                      "High-Scores!",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff50E3C2)),
                                    ),
                              Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: highScores.length,
                                  itemBuilder: ((context, index) {
                                    return Center(
                                      child: highScores[index].isCurrent! ==
                                              "true"
                                          ? themeProvided
                                              ? Text(
                                                  "Time: ${highScores[index].time}, Taps: ${highScores[index].taps}",
                                                  style: const TextStyle(
                                                      color: Colors.blue))
                                              : Text(
                                                  "Time: ${highScores[index].time}, Taps: ${highScores[index].taps}",
                                                  style: const TextStyle(
                                                      color: Colors.yellow),
                                                )
                                          : Text(
                                              "Time: ${highScores[index].time}, Taps: ${highScores[index].taps}"),
                                    );
                                  }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              ),
      ),
    );
  }
}
