import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/highScore.dart';

late SharedPreferences prefs;
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

List<HighScore> sharedPreferencesList = <HighScore>[];

Future<void> saveHighScores() async {
  final SharedPreferences prefs = await _prefs;
  List<String> spList =
      sharedPreferencesList.map((item) => jsonEncode(item.toJson())).toList();
  await prefs.setStringList('highScores', spList);
}

List<HighScore> loadHighScores() {
  // prefs = _prefs as SharedPreferences;
  List<String>? spList = prefs.getStringList("highScores");
  return sharedPreferencesList =
      spList?.map((e) => HighScore.fromJson(jsonDecode(e))).toList() ?? [];
}

Future<void> setthemeProvided(value) async {
  final SharedPreferences prefs = await _prefs;
  await prefs.setBool('themeProvided', value);
}

Future<void> setAd(value) async {
  final SharedPreferences prefs = await _prefs;
  await prefs.setBool('isAd', value);
}

Future<bool> initSharedPrefs() async {
  prefs = await _prefs;
  return prefs.getBool("themeProvided") ?? true;
}

Future<List> initPath(path) async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');

  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  final imagePaths = manifestMap.keys
      .where((String key) => key.contains('assets/$path'))
      .toList()
      .reversed
      .toList();
  return imagePaths;
}
