import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  int? _idUsuario;
  Map<String, dynamic>? _userData;

  String? get token => _token;
  int? get idUsuario => _idUsuario;
  Map<String, dynamic>? get userData => _userData;

  bool get isAuthenticated => _token != null;

  void setAuthData(String token, Map<String, dynamic> user) {
    _token = token;
    _userData = user;
    _idUsuario = user['idusuario'];
    notifyListeners();
  }

  void clearAuthData() {
    _token = null;
    _idUsuario = null;
    _userData = null;
    notifyListeners();
  }
}