import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jansahay_app/screens/admin_page.dart';
import 'package:jansahay_app/screens/first_screen.dart';
import 'package:jansahay_app/screens/form.dart';
import 'package:jansahay_app/screens/homepage.dart';
import 'package:jansahay_app/screens/login_page.dart';
import 'package:jansahay_app/screens/my_complaints.dart';
import 'package:jansahay_app/screens/signup_page.dart';
import 'package:jansahay_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JanSahay',
      home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, usersnp){
      // if(usersnp.hasData)
      //    return HomePage();
        return FirstScreen();
     },
      ),
      routes: {
        '/signup' :(context) => SignUpPage(),
        '/login'  :(context) => LogInPage(),
        '/homepage' :(context) => HomePage(),
        '/firstscreen' :(context) => FirstScreen(),
        '/mycomplaints' :(context) => MyComplaints(),
      },
    );
  }
}
