import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  TextEditingController myController = TextEditingController();
  final String text;
  final String hintText;
  bool hideText;
  TextInputField({required this.text, required this.hintText, required this.myController, this.hideText=false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0,),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white24,
              ),
              child:Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextField(
                  obscureText: hideText,
                  controller: myController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}