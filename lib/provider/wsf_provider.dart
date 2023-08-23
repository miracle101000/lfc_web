import 'package:flutter/widgets.dart';

class WSFProvider extends ChangeNotifier {
  final List<Map> _list = [];
  bool _isLoading = false;
  final Map<String, bool> _show = {"Trademore": false};
  final Map<String, bool> _onDone = {"Trademore": false};

  bool _refresh = false;

  bool get refresh => _refresh;
  bool get isLoading => _isLoading;
  List<Map> get list => _list;
  Map<String, bool> get show => _show;
  Map<String, bool> get onDone => _onDone;

  set isLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  setList(Map map) {
    if (_list
        .where((element) =>
            element['name'].toString().toLowerCase() == map['name'].toString().toLowerCase())
        .isEmpty) _list.addAll([map]);
    notifyListeners();
  }

  removeListUpdate(String estate, var data) {
    int index = _list.indexWhere((element) => element['name'] == estate);
    _list.removeWhere((element) => element['name'] == estate);
    _list.insert(index, data);
    notifyListeners();
  }

  removeList(String estate) {
    _list.removeWhere((element) => element['name'] == estate);
    notifyListeners();
  }

  refreshm() {
    _refresh = true;
    _list.clear();
    notifyListeners();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      _refresh = false;
      notifyListeners();
    });
  }

  refreshToFalse() {
    _refresh = false;
    notifyListeners();
  }

  updateMapList(String key, Map map) {
    Map c = _list.where((element) => element['name'] == key).toList()[0];
    c.update('list', (value) {
      var d = value;
      d.add(map);
      return d;
    });
    int index = _list.indexWhere((element) => element['name'] == key);
    _list.removeWhere((element) => element['name'] == key);
    _list.insert(index, c);
    notifyListeners();
  }

  updateShow(String key, bool value) {
    _show[key] = value;
    notifyListeners();
  }

  updateDone(String key, bool value) {
    _onDone[key] = value;
    notifyListeners();
  }
}
