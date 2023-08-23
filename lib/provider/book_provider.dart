import 'package:flutter/material.dart';

class BookProvider extends ChangeNotifier {
  String _title = '',
      _length = '',
      _image_url = '',
      _author ='',
      _pdf_url = '',
      _id = '';
  TextEditingController? _controller, _controller1, _controller2;
  bool _isEdit = false;

  String get title => _title;
  String get author => _author;
  String get length => _length;
  String get id => _id;
  String get image_url => _image_url;
  String get pdf_url => _pdf_url;
  bool get isEdit => _isEdit;
  TextEditingController? get controller => _controller;
  TextEditingController? get controller1 => _controller1;
  TextEditingController? get controller2 => _controller2;

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

  set title(String v) {
    _title = v;
    _controller!.text = v;
    notifyListeners();
  }

  set id(String v) {
    _id = v;
    notifyListeners();
  }

  set author(String v) {
    _author = v;
    _controller1!.text = v;
    notifyListeners();
  }

  set length(String v) {
    _length = v;
    _controller2!.text = v;
    notifyListeners();
  }

  set image_url(String v) {
    _image_url = v;
    notifyListeners();
  }


  set pdf_url(String v) {
    _pdf_url = v;
    notifyListeners();
  }
}
