import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefController {
  read(String key) async {
    print("Hello form read");
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      print(json.decode(prefs.getString(key)!));
      return json.decode(prefs.getString(key)!);
    }
    else {
      return null;
    }
  }

  Future<bool> contains(String key) async {
    print("Hello form contains");
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  save(String key, value) async {
    print("Hello form save");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    print("Hello form remove");
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}