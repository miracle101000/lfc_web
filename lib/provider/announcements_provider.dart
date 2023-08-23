import 'package:flutter/material.dart';

class AnnouncementsProvider extends ChangeNotifier {
  List _l = [
    {'type': "+", 'text': ""}
  ];
  bool _ignore = false;

  bool get ignore => _ignore;
  List get l => _l;

  Future clear() async  {
    _l.clear();
    notifyListeners();
    _l = [
      {'type': "+", 'text': ""}
    ];
    notifyListeners();
  }

  set ignore(bool v) {
    _ignore = v;

    notifyListeners();
  }

  setList(List l) {
    _l.insertAll(0, l);
    notifyListeners();
  }

  setMap(var data) {
    _l.insert(_l.length - 1, data);
    notifyListeners();
  }

  onChange(String type, String text) {
    int index = _l.indexWhere((element) => element['type'] == type);
    _l.removeAt(index);
    _l.insert(index, {'type': type, 'text': text});
    notifyListeners();
  }
}
