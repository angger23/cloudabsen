import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloudabsen/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' ;

class FormScanIn extends StatefulWidget {
  FormScanIn({this.nik,this.nama_karyawan,this.status});
  final String nik;
  final String nama_karyawan;
  final String status;


  @override
  _FormScanInState createState() => _FormScanInState();
}

class _FormScanInState extends State<FormScanIn> {
var tanggal =DateFormat("H:m").format(DateTime.parse(DateTime.now().toString()));
var amPM =DateFormat("aa").format(DateTime.parse(DateTime.now().toString()));
var hours = int.parse(DateFormat("H").format(DateTime.parse(DateTime.now().toString())));

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;

  ProgressDialog pr;

  Logout2(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  Logout()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("nik");
    Logout2();
  }

  var ya;
  var hok;

  Future<void> notif(ya) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gagal Absen'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Lokasi anda terlalu jauh dari jarak radius Rektorat Stikes Banyuwangi yaitu : ' + ya + ' KM. Maksimal Jarak adalah 70 Meter. ( Di ukur dengan garis lurus antara titik koordinat Rektorat dengan lokasi Anda )',style: TextStyle(
                    fontSize: 12
                ),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed:() => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> notify(ya) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gagal Absen'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Lokasi anda jauh dari jarak radius Rektorat Stikes Banyuwangi yaitu : ' + ya + ' Meter. Maksimal Jarak adalah 70 Meter ( Di ukur dengan garis lurus antara titik koordinat Rektorat dengan lokasi Anda )',style: TextStyle(
                    fontSize: 12
                ),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed:() => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> notifx(ya) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Absen Berhasil'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Jarak Anda dari titik Rektorat Stikes Banyuwangi yaitu : ' + ya + ' M.',style: TextStyle(
                    fontSize: 12
                ),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed:() => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> notifxxx() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Absen Berhasil'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Anda Berhasil Absen',style: TextStyle(
                    fontSize: 12
                ),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed:() => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> notifq() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gagal Absen'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Anda sudah absen .',style: TextStyle(
                    fontSize: 12
                ),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed:() => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }


  absenNow(stat)async{
    final response = await http.post(
        Uri.parse("https://android.stikesbanyuwangi.ac.id/p/absen_now"), body: {
      "nik": widget.nik,
      "status": stat,
    });
    var datauser = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(datauser['value'] == 'gak'){
        notifq();
      }else{
//        notifx(ya.toString());
        notifxxx();
      }
      print('Sukses');
    }else{
      print('tidak');
    }
  }

//  ceklog()async{
//    pr.show();
//    print("LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition
//        .longitude}");
//    final response = await http.post(
//        Uri.parse("https://android.stikesbanyuwangi.ac.id/p/jarak"), body: {
//      "lat": _currentPosition.latitude.toString(),
//      "lang": _currentPosition.longitude.toString(),
//    });
//    var datauser = jsonDecode(response.body);
//    Future.delayed(Duration(seconds: 3)).then((value) {
//      pr.hide().whenComplete(() {
//
//
//          if(datauser['jarak'] >= 70){
//            if(datauser['jarak'] > 1000){
//              hok = (datauser['jarak']).ceil() / 1000;
//              ya = double.parse(hok.toStringAsFixed(2));
//            }else{
//              ya = (datauser['jarak']).ceil();
//            }
//          }else{
//            if(datauser['jarak'] > 1000){
//              hok = (datauser['jarak']).ceil() / 1000;
//              ya = double.parse(hok.toStringAsFixed(2));
//            }else{
//              ya = (datauser['jarak']).ceil();
//            }
////            ya = (datauser['jarak']).ceil();
//          }
//
//          if(hours > 12 && amPM == 'PM'){
//            absenNow('Scan Out');
////            notifx(ya.toString());
//          }else{
//            absenNow('Scan In');
//
////            if(datauser['jarak'] > 1000) {
////              notif(ya.toString());
////            }else if(datauser['jarak'] >= 70){
////              notify(ya.toString());
////            }else{
////              absenNow('Scan In');
////            }
//          }
//      });
//    });
//  }

  ceklog(){
    pr.show();
//    print("LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition
//        .longitude}");
//    final response = await http.post(
//        Uri.parse("https://android.stikesbanyuwangi.ac.id/p/jarak"), body: {
//      "lat": _currentPosition.latitude.toString(),
//      "lang": _currentPosition.longitude.toString(),
//    });
//    var datauser = jsonDecode(response.body);
    Future.delayed(Duration(seconds: 3)).then((value) {
      pr.hide().whenComplete(() {



          if(hours > 12 && amPM == 'PM'){
            absenNow('Scan Out');
//            notifx(ya.toString());
          }else{
            absenNow('Scan In');

//            if(datauser['jarak'] > 1000) {
//              notif(ya.toString());
//            }else if(datauser['jarak'] >= 70){
//              notify(ya.toString());
//            }else{
//              absenNow('Scan In');
//            }
          }
      });
    });
  }

  _getCurrentLocation(){
    ceklog();

//    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
//
//    geolocator
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
//        .then((Position position) {
//      setState(() {
//        _currentPosition = position;
//        ceklog();
//      });
//    }).catchError((e) {
//      print(e);
//    });
}



  Widget tombolLogout(){
    if(widget.status == 'Admin'){
      return Container();
    }else{
      return IconButton(
        icon: Icon(Icons.power_settings_new),
        onPressed: (){
          Logout();
        },
      );
    }
  }

  Widget W300(){
    if(MediaQuery.of(context).size.width <= 400 && MediaQuery.of(context).size.height <= 700){
      return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.blueAccent,
                  Colors.blue[600],
                ],
              ),
            ),
            height: 140,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 50,),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Halaman ini digunakan untuk Absen Masuk Dan Pulang bila',style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Terjadi pemadaman atau hal mendadak di STIKES Banyuwangi',style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top:140),
            child: new Container(
              padding: EdgeInsets.all(10),
              width:MediaQuery.of(context).size.width,
              height: 300,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(
                      1.0, // Move to right 10  horizontally
                      1.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: ListView(
                padding: EdgeInsets.all(4),
                children: <Widget>[
                  Center(
                    child: Text('Absen Sekarang',style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto-Light',
                        fontWeight: FontWeight.w600
                    ),),
                  ),
                  Container(
                    height: 20,
                  ),

                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        _getCurrentLocation();
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.fingerprint,
                        size: 80,
                      ),
                      padding: EdgeInsets.all(50),
                      shape: CircleBorder(),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
//            top: 100.0,
            left: 0.1,
            right: 0.1,
            child: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: new IconThemeData(color: Colors.white),
              title: Text("Form Absensi",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Roboto-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: <Widget>[
                tombolLogout(),
              ],
            ),
          )

        ],
      );
    }else if(MediaQuery.of(context).size.width >= 400 && MediaQuery.of(context).size.height >= 700){
      return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.blueAccent,
                  Colors.blue[600],
                ],
              ),
            ),
            height: 140,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 55,),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Halaman ini digunakan untuk Absen Masuk Dan Pulang bila',style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Terjadi pemadaman atau hal mendadak di STIKES Banyuwangi',style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:140),
            child: new Container(
              padding: EdgeInsets.all(10),
              width:MediaQuery.of(context).size.width,
              height: 300,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(
                      1.0, // Move to right 10  horizontally
                      1.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                Center(
                  child: Text('Absen Sekarang',style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto-Light',
                    fontWeight: FontWeight.w600
                  ),),
                ),
                  Container(
                    height: 20,
                  ),

                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        _getCurrentLocation();
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.fingerprint,
                        size: 80,
                      ),
                      padding: EdgeInsets.all(50),
                      shape: CircleBorder(),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
//            top: 100.0,
            left: 0.1,
            right: 0.1,
            child: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: new IconThemeData(color: Colors.white),
              title: Text("Form Absensi",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto-Regular',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: <Widget>[
                tombolLogout(),
              ],
            ),
          )

        ],
      );
    }else{
      return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.blueAccent,
                  Colors.blue[600],
                ],
              ),
            ),
            height: 140,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 50,),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Halaman ini digunakan untuk Absen Masuk Dan Pulang bila',style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Terjadi pemadaman atau hal mendadak di STIKES Banyuwangi',style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top:140),
            child: new Container(
              padding: EdgeInsets.all(10),
              width:MediaQuery.of(context).size.width,
              height: 300,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(
                      1.0, // Move to right 10  horizontally
                      1.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Center(
                    child: Text('Absen Sekarang',style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto-Light',
                        fontWeight: FontWeight.w600
                    ),),
                  ),
                  Container(
                    height: 20,
                  ),

                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        _getCurrentLocation();
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.fingerprint,
                        size: 80,
                      ),
                      padding: EdgeInsets.all(50),
                      shape: CircleBorder(),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
//            top: 100.0,
            left: 0.1,
            right: 0.1,
            child: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: new IconThemeData(color: Colors.white),
              title: Text("Form Absensi",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Roboto-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: <Widget>[
                tombolLogout(),
              ],
            ),
          )

        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    return Scaffold(
      body: W300(),
    );
  }


//  _getAddressFromLatLng() async {
//    try {
//      List<Placemark> p = await geolocator.placemarkFromCoordinates(
//          _currentPosition.latitude, _currentPosition.longitude);
//
//      Placemark place = p[0];
//
//      setState(() {
//        _currentAddress =
//        "${place.locality}, ${place.postalCode}, ${place.country}";
//      });
//    } catch (e) {
//      print(e);
//    }
//  }
}