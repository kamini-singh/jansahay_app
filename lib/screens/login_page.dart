import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jansahay_app/screens/admin_page.dart';
import 'package:jansahay_app/widgets/AppButton.dart';
import 'package:jansahay_app/widgets/TextInputField.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogInPage extends StatefulWidget {

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  bool isLoading = false;
  final email = TextEditingController();
  final password = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  bool isAdmin = false;
  late String adminCategory;
  late String adminType;

Future<void> getData( email) async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _fireStore.collection('admin').get();
    await _fireStore.collection('admin').doc(FirebaseAuth.instance.currentUser!.uid).get().then(
         (DocumentSnapshot doc) {
           if(doc.exists)
           {
           final map = doc.data() as Map<String, dynamic>;
           adminCategory = map['categoryId'];
           adminType = map['category'];
           print(adminCategory);
           print(adminType);
           }
         }
    ); 
    final allData =
          querySnapshot.docs.map((doc) => doc.get('emailId')).toList();

  if(allData.contains(email))
  {
   isAdmin = true;
  }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/5, horizontal: 30),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20),),
             color: Color(0xFF5271ff),
          ),
             child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                child: Column(
                  children: [
                    Text('Log In',
                    style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),),
                        TextInputField(text: 'EMAIL ID', hintText:'Enter email id', myController: email),
                        TextInputField(text: 'PASSWORD', hintText:'Enter your password', myController: password, hideText: true),
                        AppButtons(text: 'Log In', textColor: Colors.white, buttonColor: Colors.black, action: () 
                        async{
                          setState(() {
                           isLoading = true;
                         });
                          try {
                           final  userCredential =
                            await _auth.signInWithEmailAndPassword(
                            email: email.text, password: password.text);
                           } catch (e) {print('Error');}

                           await getData(email.text);

                           print(isAdmin);
                            if(isAdmin == true)
                            {
                              Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => AdminPage(categoryId: adminCategory, admintype: adminType)),
                              );
                            }

                            else
                             Navigator.pushNamed(context, '/homepage');

                          setState(() {
                            isLoading = false;
                          }); 
                         },
                         isLoading: isLoading,),

                   Text(' Do not have an account?',
                    style: TextStyle(
                          color: Colors.white,
                        ),),
                    TextButton(onPressed: (){Navigator.pushNamed(context, '/signup');}, child: Text ('Sign Up here!',
                    style: TextStyle(
                      color: Colors.white,
                    )))
            ],
        ),
        ),
        ),
      ),
    );
  }
}

