import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jansahay_app/screens/login_page.dart';
import 'package:jansahay_app/screens/signup_page.dart';
import 'package:jansahay_app/widgets/AppButton.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'JanSahay',
                          style: GoogleFonts.poppins(
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'The right place to your queries',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          'assets/app_logo.png',
                          width: 150,
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF5271ff),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        )),
                    child: Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(
                        child: Column(
                          children: [
                            AppButtons(
                                text: 'Sign Up',
                                textColor: Colors.white,
                                buttonColor: Colors.black,
                                action: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return SignUpPage();
                                      },
                                    ),
                                  );
                                }),
                            SizedBox(
                              height: 30,
                            ),
                            AppButtons(
                                text: 'Log In',
                                textColor: Colors.white,
                                buttonColor: Colors.black54,
                                action: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LogInPage();
                                      },
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
