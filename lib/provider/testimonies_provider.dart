import 'package:flutter/material.dart';

class TestimoniesProvider extends ChangeNotifier {
  String _name = '',
      _length = '',
      _image_url = '',
      _category = '',
      _testimony = '',
      _type ='Text',
      _id = '';
  TextEditingController? _controller, _controller1, _controller2;
  bool _isEdit = false;

  String get name => _name;
  String get type => _type;
  String get category => _category;
  String get length => _length;
  String get testimony => _testimony;
  String get id => _id;
  String get image_url => _image_url;
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

  set name(String v) {
    _name = v;
    _controller!.text = v;
    notifyListeners();
  }

  set id(String v) {
    _id = v;
    notifyListeners();
  }

  set type(String v) {
    _type = v;
    notifyListeners();
  }

   set category(String v) {
    _category = v;
    notifyListeners();
  }

  set testimony(String v) {
    _testimony= v;
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


}
