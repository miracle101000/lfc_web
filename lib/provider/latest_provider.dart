import 'package:flutter/material.dart';
import 'package:lfc_web/screens/wsf/wsf_list.dart';

class LatestProvider with ChangeNotifier {
  String _id = '';
  String _text = '';
  bool _isEdit = false;
  String _imageUrl = '';
  TextEditingController? _controller;
  String get id => _id;
  String get text => _text;
  String get imageUrl => _imageUrl;
  bool get isEdit => _isEdit; 
  TextEditingController? get controller => _controller;

  set controller(TextEditingController? v) {
    _controller = v;
    // notifyListeners();
  }
  set isEdit(bool v){
    _isEdit = v;
    notifyListeners();;
  }

  set id(String v) {
    _id = v;
    notifyListeners();
  }

  set imageUrl(String v){
    _imageUrl = v;
    notifyListeners();
  }

  set text(String v) {
    _text = v;
    _controller!.text = v.capitalize();
    _isEdit =  true;
    notifyListeners();
  }
}
