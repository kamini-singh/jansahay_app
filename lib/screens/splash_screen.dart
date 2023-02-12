import 'package:flutter/material.dart';
import 'package:jansahay_app/screens/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  static String id = 'splash';

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState()
  {
    super.initState();
    _navigatetohome();
  }
_navigatetohome()async{
    await Future.delayed(Duration(milliseconds: 5000), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
}
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
          alignment: Alignment.center,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
           children:[
               Image.asset('assets/app_logo.png',
                 width:200,
                 height: 200,),
              Text('JanSahay',
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
              Text('The right place to your queries',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              )
        ],
    ),
      ),
    );

  }
}