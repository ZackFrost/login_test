import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_test/pages/login.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  final String userName;

  const Home({Key? key, required this.userName}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String link = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo1.png',
                    height: 5.h,
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
                    },
                    child: Row(
                      children: [
                        Text("Logout",),
                        SizedBox(width: 3,),
                        Icon(Icons.logout, size: 18,)
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Hello, ",
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.userName.toTitleCase(),
                    style: TextStyle(fontSize: 18.sp),
                  ),

                ],
              ),
              SizedBox(height: 10,),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.DEFAULT);
                      print(barcodeScanRes);
                      if(barcodeScanRes.isNotEmpty){
                        setState(() {
                          link = barcodeScanRes;
                        });
                      }
                    },
                    child: const Text("Scan QR Code")),
              ),
              const SizedBox(height: 10,),
              if(link.isNotEmpty)
                Text("Note: Tap on the link to view"),
              const SizedBox(height: 6,),
              if(link.isNotEmpty)
              GestureDetector(
                  onTap: () async{
                    try{
                      launch(link);
                    } catch(ex){
                      Fluttertoast.showToast(msg: "Error, something went wrong");
                    }
                  },
                  child: Text(link, style: TextStyle(color: Colors.blueAccent),)),

            ],
          ),
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
