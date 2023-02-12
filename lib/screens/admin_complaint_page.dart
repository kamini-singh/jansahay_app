import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jansahay_app/screens/admin_page.dart';
import 'package:jansahay_app/widgets/AppButton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintPage extends StatefulWidget {
  final String categoryId;
  final String complaintId;
  final String adminType;
  ComplaintPage({required this.categoryId, required this.complaintId, required this.adminType});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/15, horizontal: 30),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20),),
             color: Color(0xFF5271ff),
          ),
             child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                 child: ListView(
                 physics: PageScrollPhysics(),
                 children:[
                                           
                          Center(
                            child: Text('Complaint Details',
                            style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                        ),),
                          ),

                    StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                          .collection("categories").doc(widget.categoryId)
                          .collection('complaints').doc(widget.complaintId).snapshots(), 
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                      if (snapshot.hasData) {
                      //final map = snapshot.data!.data as Map<String, dynamic>;
                      Map<String, dynamic> map = snapshot.data!.data() as Map<String, dynamic>;
                      return ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(
                      ),
                        children :[
                      
                          MyText(text: "ComplaintID: ${map['complaintId']}"),
                          MyText(text: "Complaint Recepient name: ${map['name']}"),
                          MyText(text:"Complaint Description: ${map['description']}"),
                          MyText(text:"Complaint Location Address: ${map['currentAddress']}"),
                          MyText(text:"Complaint Status: ${map['complaintStatus']}"),
                          Container(
                            height:150,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20),),
                              image: DecorationImage(image: NetworkImage(map['imageFile']),
                            ),
                          ),
                          ),
                          isLoading?
                          Center(
                            child: CircularProgressIndicator(),
                          )
                          :Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AppButtons(text: 'Mark as Resolved', textColor: Colors.white, buttonColor: Colors.black, action: () async{

                              setState(() {
                                isLoading = true;
                              });

                            await FirebaseFirestore.instance
                            .collection("categories").doc(widget.categoryId)
                            .collection('complaints').doc(widget.complaintId).update(
                            {'complaintStatus': 'Resolved'});
                         
                            Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => AdminPage(categoryId: widget.categoryId, admintype: widget.adminType)),
                              );
                            setState(() {
                                isLoading = false;
                              });
                        }),
                          ),
                        ],
                        
                        );
                       }
                      return(Container());
                     }
                   ),
                 ],
                 ),
             ),
        ),
      ),
      );
  }          
}

class MyText extends StatelessWidget {

  final String text;
 MyText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10),),
               color: Colors.white38,
            ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text( text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
          ),
        ),
      ),
    );
  }
}