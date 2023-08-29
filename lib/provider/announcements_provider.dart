import 'package:flutter/material.dart';

class AnnouncementsProvider extends ChangeNotifier {
  String _selectedText = '';
  bool _isLoading = false, _hasError = false;
  bool _isIniting = false;
  bool _refresh = false;

  String get selectedText => _selectedText;
  bool get isLoading => _isLoading;
  bool get isIniting => _isIniting;
  bool get hasError => _hasError;
  bool _ignore = false;
  bool get ignore => _ignore;
  bool get refresh => _refresh;

  List get l => _l;

  List _l = [];

  refres() {
    _refresh = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      _refresh = false;
      notifyListeners();
    });
  }

  set selectedText(String v) {
    _selectedText = v;
    notifyListeners();
  }

  set isLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  set isIniting(bool v) {
    _isIniting = v;
    notifyListeners();
  }

  set hasError(bool v) {
    _hasError = v;
    notifyListeners();
  }

  Future clear() async {
    _l.clear();
    notifyListeners();
    _l = [];
    notifyListeners();
  }

  remove(int index) {
    _l.removeAt(index);
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
    _l.insert(_l.length, data);
    notifyListeners();
  }

  onChange(String type, String text) {
    int index = _l.indexWhere((element) => element['type'] == type);
    _l.removeAt(index);
    _l.insert(index, {'type': type, 'text': text});
    notifyListeners();
  }
}
