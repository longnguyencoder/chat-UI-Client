import 'package:flutter/material.dart';
import '../../utils/shared_prefs.dart';
import '../auth/login_view.dart';
import '../home/main_view.dart';

class SplashView extends StatefulWidget{
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async{
    bool isLoggedIn = await SharedPrefs.isLoggedIn();
    if (!mounted) return;
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainView()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}