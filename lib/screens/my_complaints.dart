import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jansahay_app/widgets/MyComplaintTab.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:jansahay_app/widgets/ComplaintTab.dart';
Size? size;

class MyComplaints extends StatefulWidget {
  @override
  State<MyComplaints> createState() => _MyComplaintsState();
}

class _MyComplaintsState extends State<MyComplaints> {
  
  late bool activeComplaints;
  late bool resolvedComplaints;
  late String selectedTab;

  late CollectionReference<Map<String, dynamic>> productList = FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('complaints');

  Color color = Colors.grey;
  Color iconColor = Colors.white;
  @override

  void initState(){
    super.initState();
    activeComplaints = true;
    resolvedComplaints = false;
    selectedTab = 'Active';
  }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: size!.height / 20),
      child: ListView (
         physics: PageScrollPhysics(),
        children: [
        Center(
          child: Text(
            'Welcome to JanSahay',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5271ff),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyComplaintTab(color: activeComplaints? Color(0xFF5271ff): Colors.grey, text: "Active Complaints", action: () {
            setState(() {
              activeComplaints = true;
              resolvedComplaints = false;
              selectedTab = 'Active';
            });
            }),

            MyComplaintTab(color: resolvedComplaints? Color(0xFF5271ff): Colors.grey, text: "Resolved Complaints", action: () {
            setState(() {
            activeComplaints = false;
            resolvedComplaints = true;
            selectedTab = 'Resolved';
        });
        }),
          ],
        ),
       
        const Divider(
          height: 40.0,
          thickness: 2,
          color: Colors.grey,
          ),
        Container(
                child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("users").doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('complaints')
                      .get(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (!streamSnapshot.hasData) {
                      return const Center(
                      child: Text(
                     'No complains as of now',
                      style: TextStyle(
                      color: Colors.grey,
                  ),
                ),
              );
                 }
                    return ListView.builder(
                        physics: PageScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index){
                        if(streamSnapshot.data!.docs[index]['complaintStatus'] == selectedTab)
                          {
                          return ComplaintTab(timestamp: streamSnapshot.data!.docs[index]['timestamp'], 
                          complaintCategory: streamSnapshot.data!.docs[index]['complaintCategory'],
                          complaintStatus: streamSnapshot.data!.docs[index]['complaintStatus'],
                          complaintDescription: streamSnapshot.data!.docs[index]['description'],
                          actionOnTappingDelete: ()async{

                            setState(() {
                              iconColor: Color(0xFF5271ff);
                            });
                            await FirebaseFirestore.instance
                            .collection("users").doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('complaints')
                            .doc(streamSnapshot.data!.docs[index]['complaintId'])
                            .delete();

                          },
                          iconColor: iconColor);
                        }
                        return Container();
                        }
                      );
                  },
                ),
              ),
      ]),
    );
  }
}

