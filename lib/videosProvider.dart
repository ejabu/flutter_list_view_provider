import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum Stage { ERROR, LOADING, DONE }

class VideosProvider with ChangeNotifier {
  String errorMessage = "Network Error";
  Stage stage;
  List _playlist;
  int _currentVideoId;

  VideosProvider() {
    this.stage = Stage.LOADING;
    initScreen();
  }

  void initScreen() async {
    try {
      await fetchVideosList();
      stage = Stage.DONE;
    } catch (e) {
      stage = Stage.ERROR;
    }
    notifyListeners();
  }

  List get playlist => _playlist;

  void setPlayList(videosList) {
    _playlist = videosList;
  }

  void validateInput(String valueText) {
    if (valueText == ""){
      this._currentVideoId = null;
      return;
    }
    try {
      int valueInt = int.parse(valueText);
      if (valueInt == 1 || valueInt == 2){
        this._currentVideoId = valueInt;
      }
      else {
        this.errorMessage = "Use only 1 and 2";
        throw 1;
      }
    } on FormatException catch (e) {
      this.errorMessage = "Must be a number";
      throw 1;
    }
  }

  void updateCurrentVideoId(String value) async {
    this.stage = Stage.LOADING;
    notifyListeners();

    try {
      validateInput(value);
      await fetchVideosList();
      stage = Stage.DONE;
    } on SocketException catch (e) {
      this.errorMessage = "Network Error";
      stage = Stage.ERROR;
    } catch (e) {
      stage = Stage.ERROR;
    }
    notifyListeners();
  }

  Future fetchVideosList() async {
    String url;
    if (_currentVideoId != null) {
      url = "https://reqres.in/api/users?page=$_currentVideoId";
    } else {
      url = "https://reqres.in/api/users";
    }
    http.Response response = await http.get(url);
    var videosList = json.decode(response.body)["data"];
    setPlayList(videosList);
  }
}
