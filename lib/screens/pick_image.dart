import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:jansahay_app/screens/form.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Position? currentPosition;
String currentAddress = '';
class PickImage extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  PickImage({required this.categoryName, required this.categoryId});


  @override
  State<PickImage> createState() => _PickImageState();
}
bool isLoading = false;
bool filePicked = false;
late File imageFile;
class _PickImageState extends State<PickImage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filePicked = false;
  }
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: filePicked?
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                  image: DecorationImage(image: FileImage(imageFile),
                ),
                ),
              ),
              IconButton(onPressed: () async{
              if(await getPermission() == true)
              {
                setState(() {
                  isLoading = true;
                });

                
                 await getCurrentPosition();

                 setState(() {
                   isLoading= false;
                 });
              }
              Navigator.push(
                context,
               MaterialPageRoute(builder: (context) => FormPage(categoryName: widget.categoryName, categoryId: widget.categoryId, imageFile: imageFile, currentAddress: currentAddress),),
               );
              }, icon: Icon(Icons.check_circle, size: 50, color: Colors.green,)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Verify image and provide current location'),
            ),
            isLoading?
            Center(
              child: CircularProgressIndicator(),
            )
            : Container(),
            ],
          )
          :Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () async{
                final ImagePicker _picker = ImagePicker();
                //final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                imageFile = File(image!.path);
                
                setState(() {
                  filePicked = true;
                });

              print(imageFile);
              }, icon: Icon(Icons.camera_alt_sharp, size: 50, color: Colors.grey,)),
              SizedBox( height: 10,),
              Text("Tap on icon to click the picture of issue")
            ],
          ),
        ),
      ),
    );
  }
}


Future<bool> getPermission() async{
  
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {   
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}

Future<void> getCurrentPosition() async{
  final hasPermission = await getPermission();
  if(!hasPermission)
  {
   print("false");
   return;
  }
    try{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    } catch(e) {print("Error");}

    List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);
    _getAddressFromLatLng(currentPosition!);
    }


Future<void> _getAddressFromLatLng(Position position) async {
  await placemarkFromCoordinates(
          currentPosition!.latitude, currentPosition!.longitude)
      .then((List<Placemark> placemarks) {
    Placemark place = placemarks[0];
    try {
      currentAddress =
          "${place.street}, ${place.subLocality} ${place.subAdministrativeArea}, ${place.postalCode}";
    }
     catch(e) {print(e);}

     print(currentAddress);
  });
 }