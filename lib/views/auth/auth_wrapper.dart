import 'package:flutter/material.dart';
import '../../utils/shared_prefs.dart';
import '../home/main_view.dart';
import 'login_view.dart';

class AuthWrapper extends StatelessWidget{
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SharedPrefs.isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return snapshot.data! ? const MainView() : const LoginView();
      },
    );
  }
}