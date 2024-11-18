import 'package:flutter/material.dart';

class VideoProvider extends ChangeNotifier {
  String _title = '',
      _description = '',
      _video_link = '',
      _length = '',
      _image_url = '',
      _id = '';
  TextEditingController? _controller, _controller1, _controller2, _controller3;
  bool _isEdit = false;

  String get title => _title;
  String get description => _description;
  String get video_link => _video_link;
  String get length => _length;
  String get id => _id;
  String get image_url => _image_url;
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

  set description(String v) {
    _description = v;
    _controller1!.text = v;
    notifyListeners();
  }

  set video_link(String v) {
    _video_link = v;
    _controller2!.text = v;
    notifyListeners();
  }

  set length(String v) {
    _length = v;
    _controller3!.text = v;
    notifyListeners();
  }

  set image_url(String v) {
    _image_url = v;
    notifyListeners();
  }
}

class LatestVideoProvider extends ChangeNotifier {
  String _title = '',
      _description = '',
      _video_link = '',
      _length = '',
      _image_url = '',
      _id = '';
  TextEditingController? _controller, _controller1, _controller2, _controller3;
  bool _isEdit = false;

  String get title => _title;
  String get description => _description;
  String get video_link => _video_link;
  String get length => _length;
  String get id => _id;
  String get image_url => _image_url;
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

  set description(String v) {
    _description = v;
    _controller1!.text = v;
    notifyListeners();
  }

  set video_link(String v) {
    _video_link = v;
    _controller2!.text = v;
    notifyListeners();
  }

  set length(String v) {
    _length = v;
    _controller3!.text = v;
    notifyListeners();
  }

  set image_url(String v) {
    _image_url = v;
    notifyListeners();
  }
}
