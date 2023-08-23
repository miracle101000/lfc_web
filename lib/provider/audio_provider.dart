import 'package:flutter/material.dart';

class AudioProvider extends ChangeNotifier {
  String _title = '',
      _description = '',
      _length = '',
      _image_url = '',
      _audio_url = '',
      _id = '';
  TextEditingController? _controller, _controller1, _controller2;
  bool _isEdit = false;

  String get title => _title;
  String get description => _description;
  String get length => _length;
  String get id => _id;
  String get image_url => _image_url;
  String get audio_url => _audio_url;
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

  set description(String v) {
    _description = v;
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

  set audio_url(String v) {
    _audio_url = v;
    notifyListeners();
  }
}
