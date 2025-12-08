import 'package:flutter/material.dart';
import 'package:mobilev2/models/user_model.dart';

class UserProvider extends ChangeNotifier{
  UserModel? _userModel;
  UserModel? get user => _userModel;

  void setUser(UserModel user) {
    print("👤 UserProvider.setUser: ${user.id}");
    _userModel = user;
    notifyListeners();
  }

  void clearUser() {
    print("👤 UserProvider.clearUser");
    _userModel = null;
    notifyListeners();
  }

  void setUserIfAvailable(UserModel? user) {
    if (user != null) {
      print("👤 UserProvider.setUserIfAvailable: ${user.id}");
      _userModel = user;
      notifyListeners();
    }else{
      print("👤 UserProvider.setUserIfAvailable: user is null");
    }
  }

  void setUsername(String username) {
    if (_userModel != null) {
      _userModel = _userModel!.copyWith(username: username);
      notifyListeners();
    }
  }
}