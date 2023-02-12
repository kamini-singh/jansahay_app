import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jansahay_app/widgets/AppButton.dart';
import 'package:jansahay_app/widgets/TextInputField.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/7, horizontal: 30),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20),),
             color: Color(0xFF5271ff),
          ),
             child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                child: Column(
                  children: [
                    Text('Create new account',
                    style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),),
                        TextInputField(text: 'NAME', hintText:'John', myController: name),
                        TextInputField(text: 'EMAIL ID', hintText:'John@gmail.com', myController: email),
                        TextInputField(text: 'PASSWORD', hintText:'*****', myController: password, hideText: true,),
                        AppButtons(text: 'Sign Up', textColor: Colors.white, buttonColor: Colors.black, action: () async{
                        
                         setState(() {
                           isLoading = true;
                         });
                          try {
                           final  userCredential =
                            await _auth.createUserWithEmailAndPassword(
                            email: email.text, password: password.text);
                            FirebaseFirestore.instance
                          .collection("users")
                          .doc(userCredential.user!.uid)
                          .set(
                          {
                          "fullName": name.text,
                          "emailAddress": email.text,
                          "password": password.text,
                          "userUid": userCredential.user!.uid,
                           },
                           );
                           } catch (e) {print('Error');}

                           
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pushNamed(context, '/homepage');},
                          isLoading: isLoading,)
            ],
        ),
        ),
        ),
      ),
    );
  }
}

