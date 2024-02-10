import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class LoginService{

  static Future<String> makeSoapRequest(String mobileNumber, String password) async {
    var soapXML = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Login xmlns="https://hmstesthpV3.x1.com.my">
      <mobile>$mobileNumber</mobile>
      <password>$password</password>
    </Login>
  </soap:Body>
</soap:Envelope>''';

    Map<String, String> _headers = {};

    _headers["Content-Type"] = 'text/xml; charset=utf-8';
    _headers["SOAPAction"] = 'https://hmstesthpV3.x1.com.my/Login';
    _headers["Host"] = 'hmstesthpv3.x1.com.my';
    // _headers['Content-Length'] = '${utf8.encode(soapXML).length}';

    try {

      http.Response response = await http.post(
        Uri.parse('https://hmstesthpv3.x1.com.my/DriverServiceFlutterIOSV3.asmx'),
        headers: _headers,
        body: utf8.encode(soapXML)
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('SOAP Response: ${response.body}');
        final document = XmlDocument.parse(response.body);
        XmlElement nameElement;
        XmlElement driverIDElement;
        // Find the 'Name' and 'DriverID' elements
        try{
          nameElement = document.findAllElements('Name').single;
          driverIDElement = document.findAllElements('DriverID').single;

          Fluttertoast.showToast(
              msg: "Login Successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );

          return nameElement.text;
        } catch(ex){
          final driverIDElement = document.findAllElements('Error').single;
          Fluttertoast.showToast(
              msg: driverIDElement.text,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }

        // Extract the text values
        // String name = nameElement.text;
        // String driverID = driverIDElement.text;
        // print("Login Successful  -  $name -- $driverID");
      } else {
        // Handle error response
        print('SOAP Request failed with status: ${response.statusCode}');
        print('SOAP Response: ${response.body}');

      }
    } catch (e) {
      // Handle exceptions
      print('Error making SOAP Request: $e');
    }
    return "";
  }
}