import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jansahay_app/screens/form.dart';
import 'package:jansahay_app/screens/pick_image.dart';

Size? size;

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: ListView(
          physics: PageScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.only(top: size!.height/20, left:10, right:10, bottom:10),
              child: Text('To register a complaint, select a category',
                          style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF5271ff),
                              ),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                      .collection("categories")
                      .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                      if(!streamSnapshot.hasData)
                      {
                        return const Center(
                          child: CircularProgressIndicator()
                        );
                      }
                      return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 20.0,
                      shrinkWrap: true,
                      physics: ScrollPhysics(
                      ),
                      children: List.generate(
                        streamSnapshot.data!.docs.length,
                        (index) {
                          return CategoriesCard(
                              categoryName: streamSnapshot.data!.docs[index]['CategoryName'],
                              categoryImage: streamSnapshot.data!.docs[index]['CategoryImage'],
                              categoryId: streamSnapshot.data!.docs[index]['categoryId'],
                              );
                        },
                      ),
                    );
                  },
                ),
                ),
            ),
          ],
      ),
    );
  }
}


class CategoriesCard extends StatelessWidget {
   CategoriesCard({required this.categoryName, required this.categoryImage, required this.categoryId});
   final String categoryName;
   final String categoryImage;
   final String categoryId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PickImage(categoryName: categoryName, categoryId: categoryId),),
        );
      },
      child: Container(
            //width: size!.width/2 - 50,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20),),
            color: Colors.white,
            image: DecorationImage(image: NetworkImage(categoryImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.6), BlendMode.modulate,),
            ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text( categoryName,
                          style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),),
              ),
            ),
          ),
    );
  }
}