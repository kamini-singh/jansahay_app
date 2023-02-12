import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jansahay_app/screens/pick_image.dart';
import 'package:jansahay_app/widgets/AppButton.dart';
import 'package:jansahay_app/widgets/TextInputField.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FormPage extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  final File imageFile;
  final String currentAddress;
  FormPage({required this.categoryName, required this.categoryId, required this.imageFile, required this.currentAddress});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late User user;
  var imageUrl;

  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
  }


  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  final name = TextEditingController();
  final phone = TextEditingController();
  final description = TextEditingController();
  //final address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/10, horizontal: 30),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20),),
             color: Color(0xFF5271ff),
          ),
             child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: ListView(
                  children: [
                    Text('Register a Complaint for ${widget.categoryName}',
                    style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),),
                        TextInputField(text: 'Name', hintText:'Enter name', myController: name),
                        TextInputField(text: 'Phone Number', hintText:'Enter Phone number', myController: phone),
                        TextInputField(text: 'Complaint Description', hintText:'Explaint the problem', myController: description),
                       // TextInputField(text: 'Address', hintText:'Address of the area', myController: address),
                        AppButtons(text: 'Register Complaint', textColor: Colors.white, buttonColor: Colors.black, action: () async{
                        
                         setState(() {
                           isLoading = true;
                         });

                         //adding data in user's complaint collection
                        
                         final docref = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid)
                         .collection("complaints").doc();

                          final String complaintId = docref.id;
                          uploadImage() async{
                            // Reference reference = FirebaseStorage.instance.ref()
                            // .child('image/');
                            // final UploadTask upLoadTask = reference.putFile(imageFile);
                            // final TaskSnapshot snapshot = (await UploadTask) as TaskSnapshot;
                            // imageUrl =  await snapshot.ref.getDownloadURL();
                          var snapshot = await FirebaseStorage.instance.ref()
                          .child('images/imageName')
                          .putFile(imageFile);
                           imageUrl = await snapshot.ref.getDownloadURL();
                          }
                        await uploadImage();
                         await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid)
                         .collection("complaints").doc(complaintId).set(
                          {
                            'name' : name.text,
                            'phone' : phone.text,
                            'description' : description.text,
                            'complaintStatus' : 'Active',
                            'timestamp': FieldValue.serverTimestamp(),
                            'complaintCategory' : widget.categoryName,
                            'complaintId' : complaintId,
                            'imageFile' : imageUrl,
                            'currentAddress': currentAddress,
                          }
                         );
                         print(imageUrl);
                         //adding data in corresponding category folder
                          await FirebaseFirestore.instance.collection("categories").doc(widget.categoryId)
                         .collection("complaints").doc(complaintId).set(
                          {
                            'name' : name.text,
                            'phone' : phone.text,
                            'description' : description.text,
                            'complaintStatus' : 'Active',
                            'timestamp': FieldValue.serverTimestamp(),
                            'userId': FirebaseAuth.instance.currentUser!.uid,
                            'complaintId': complaintId,
                            'imageFile' : imageUrl,
                            'currentAddress': currentAddress,
                          }
                         );

                         print(complaintId);

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

