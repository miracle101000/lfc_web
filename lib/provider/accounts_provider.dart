import 'package:flutter/material.dart';

class AccountsProvider extends ChangeNotifier {
  String _title = '',
      _accountNo = '',
      _accountName = '',
      _bankName = '',
      _id = '';
  TextEditingController? _controller, _controller1, _controller2, _controller3;
  bool _isEdit = false;

  String get title => _title;
  String get accountNo => _accountNo;
  String get accountName => _accountName;
  String get bankName => _bankName;
  String get id => _id;
  bool get isEdit => _isEdit;
  TextEditingController? get controller => _controller;
  TextEditingController? get controller1 => _controller1;
  TextEditingController? get controller2 => _controller2;
  TextEditingController? get controller3 => _controller3;

  set isEdit(bool v) {
    _isEdit = v;
    // notifyListeners();
  }

  set controller(TextEditingController? v) {
    _controller = v;
  }

  set controller1(TextEditingController? v) {
    _controller1 = v;
  }

  set controller2(TextEditingController? v) {
    _controller2 = v;
  }

  set controller3(TextEditingController? v) {
    _controller3 = v;
  }

  set title(String v) {
    _title = v;
    _controller!.text = v;
    notifyListeners();
  }

  set id(String v) {
    _id = v;
    notifyListeners();
  }

  set accountNo(String v) {
    _accountNo = v;
    _controller1!.text = v;
    notifyListeners();
  }

  set accountName(String v) {
    _accountName = v;
    _controller2!.text = v;
    notifyListeners();
  }

  set bankName(String v) {
    _bankName = v;
    _controller3!.text = v;
    notifyListeners();
  }
}
