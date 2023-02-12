import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class ComplaintTab extends StatelessWidget {
 
  Timestamp timestamp;
  final String complaintDescription;
  final String complaintCategory;
  final String complaintStatus;
  final VoidCallback actionOnTappingDelete;
  final Color iconColor;
  ComplaintTab({required this.timestamp, required this.complaintDescription, required this.complaintCategory, required this.complaintStatus,
  required this.actionOnTappingDelete, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: size.width/10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: complaintStatus == 'Active' ? Colors.black : Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    complaintCategory,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text("Registered on: ${DateFormat("yyyy-MM-dd").format(timestamp.toDate()).toString()}",
                      style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text("Complaint Status : $complaintStatus",
                      style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    complaintDescription,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

            complaintStatus == 'Active'
            ? IconButton(onPressed:actionOnTappingDelete,  icon: Icon(Icons.delete_outline, size: 30, color: iconColor,),)
            : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
