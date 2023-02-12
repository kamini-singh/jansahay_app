import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Size? size;
class MyComplaintTab extends StatelessWidget {
   Color color;
   final String text;
   final VoidCallback action;
   MyComplaintTab({required this.color, required this.text, required this.action});

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return MaterialButton(
        onPressed: action,
        child: Container(
          width: size!.width/2 - 50,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20),),
          color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text( text,
                      style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),),
          ),
        ),
      );
  }
}
