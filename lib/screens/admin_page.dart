import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jansahay_app/screens/admin_complaint_page.dart';
import 'package:jansahay_app/widgets/MyComplaintTab.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:jansahay_app/widgets/ComplaintTab.dart';
Size? size;

class AdminPage extends StatefulWidget {
  final String categoryId;
  final String admintype;

  AdminPage({required this.categoryId, required this.admintype});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  
  late bool activeComplaints;
  late bool resolvedComplaints;
  late String selectedTab;
  late String admincategory;

  Color color = Colors.grey;
  Color iconColor = Colors.white;

  @override

  void initState() {
    super.initState();
    activeComplaints = true;
    resolvedComplaints = false;
    selectedTab = 'Active';
    }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: size!.height /30),
          child: ListView (
             physics: PageScrollPhysics(),
            children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Logout'),
                IconButton(onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/firstscreen');
                },  icon: Icon(Icons.logout_outlined, size: 30, color: Colors.black),),
              ],
            ),
            Center(
              child: Text(
                'Admin Portal for ${widget.admintype}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
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
                          .collection("categories").doc(widget.categoryId)
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
                      else{
                        return ListView.builder(
                            physics: PageScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index){
                            if(streamSnapshot.data!.docs[index]['complaintStatus'] == selectedTab)
                              {
                              return GestureDetector(
                                onTap: () {
                                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ComplaintPage(categoryId: widget.categoryId, complaintId:streamSnapshot.data!.docs[index]['complaintId'], adminType: widget.admintype)),
                              );
                                },
                                child: ComplaintTab(timestamp: streamSnapshot.data!.docs[index]['timestamp'], 
                                complaintCategory: streamSnapshot.data!.docs[index]['complaintId'],
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
                                iconColor: iconColor),
                              );
                            }
                            return Container();
                            }
                          );
                      }
                      },
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}

