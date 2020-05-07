import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:cloudabsen/PageAdmin.dart';
import 'package:cloudabsen/karyawan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart' ;
import 'package:geolocator/geolocator.dart';

class Login extends StatefulWidget {
  Login();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String nikq = '';
  String namakaryawan = '';
  String status = '';
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  ProgressDialog pr;

  TextEditingController nik = new TextEditingController();

  String msg='';

  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(key, value);
  }

  Future<void> notif() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tidak Ada Koneksi Internet !'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Pastikan smartphone anda terkoneksi dengan internet untuk bisa menggunakan aplikasi ini',style: TextStyle(
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

  Future<void> notif3() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gagal !'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Fetch Data gagal',style: TextStyle(
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

  Future<void> notif2() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('NIK tidak ditemukan !'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Pastikan anda memasukkan NIK yang sudah terdaftar di aplikasi ini.',style: TextStyle(
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

  _getCurrentLocation(){
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
//    if(response.statusCode == 200){
//      print(response.body);
//    }else{
//      print('oppps');
////      hasil = errMessage;
//    }

  }

  CekLogin()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
//      print('not connected');
    notif();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var nikx = prefs.getString('nik');
    if( nikx!= "" && nikx!= null ){
      final response = await http.post("https://android.stikesbanyuwangi.ac.id/p/cek_karyawan", body: {
        "nik": prefs.getString('nik'),
      });
      var datauser = jsonDecode(response.body);
      setState(() {
        nikq= datauser[0]['nik'];
        namakaryawan= datauser[0]['nama_karyawan'];
        status= datauser[0]['status'];
      });
      if(datauser[0]['statusDivisi']=='Admin'){
//        Navigator.pushReplacementNamed(context, '/AdminPage');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PageAdmin(
          nik: nikq,
          nama_karyawan: namakaryawan,
          status: status,
        )));
      }else if(datauser[0]['statusDivisi']==''){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => KaryawanPage(
          nik: nikq,
          nama_karyawan: namakaryawan,
          status: status,
        )));
//        Navigator.pushReplacementNamed(context, '/MemberPage');
      }
//      print('sudah login');
    }else{
      print('belom');
    }
  }

  Future<List> _login() async {
    pr.show();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//    print(nik.text);
    final response = await http.post("https://android.stikesbanyuwangi.ac.id/p/login", body: {
      "nik": nik.text,
    });
    if(response.statusCode == 200){
      var datauser = jsonDecode(response.body);
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {

          if(datauser[0]['stat'] == 'kosong'){
//          print(datauser.length);
            notif2();
//          setState(() {
//            msg="Login Fail";
//          });
          }else{

//          print(datauser.length);

            nikq= datauser[0]['nik'];
            save('nik',nikq);
          final response1 = http.post("https://android.stikesbanyuwangi.ac.id/p/update_data_device", body: {
            "nik": nik.text,
            'model_hp' : androidInfo.model.toString(),
            'android_ver' : androidInfo.version.release.toString(),
            'android_api' : androidInfo.version.sdkInt.toString(),
            'device_width' : MediaQuery.of(context).size.width.toString(),
            'device_height' : MediaQuery.of(context).size.height.toString(),
            'device_product' : androidInfo.product.toString(),
            'device_fracture':androidInfo.manufacturer.toString(),
          });
            if(datauser[0]['statusDivisi']=='Admin'){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PageAdmin(
                nik: nikq,
                nama_karyawan: namakaryawan,
                status: status,
              )));
            }else if(datauser[0]['statusDivisi']==''){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => KaryawanPage(
                nik: nikq,
                nama_karyawan: namakaryawan,
                status: status,
              )));
            }

            setState(() {
              nikq= datauser[0]['nik'];
              namakaryawan= datauser[0]['nama_karyawan'];
              status= datauser[0]['status'];
            });

          }

        });
      });
    }else{
      var datauser = jsonDecode(response.body);
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {
          notif3();
        });
      });
    }


  }



  Widget wi300(){
    if(MediaQuery.of(context).size.width <= 400 && MediaQuery.of(context).size.height <= 700){
      return ListView(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage('Assets/img/undraw_mobile_login_ikmv.png'),width: 250,),
                      Container(height: 12.0),
                      Text('Login',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Container(height: 10,),
                      Text('Login terlebih dahulu untuk melihat infomasi absensi menggunakan nik',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),

                      Container(height: 30.0),
                      TextField(
                        keyboardType: TextInputType.number,
                        onSubmitted: (text){
                          _login();
                        },
                        controller: nik,
                        obscureText: false,
                        style: TextStyle(fontSize: 20.0),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "NIK",
                        ),
                      ),
                      Container(height: 25.0),
                      Text(msg,style: TextStyle(fontSize: 20.0,color: Colors.red),),
                      Container(
                        child:  MaterialButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: (){
                            _login();
//                            setState(() {
//                              karyawan = _fetchKaryawan();
//                            });
//                                                setState(() {});
//                LoginNow();
                          },//since this is only a UI app
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            padding: EdgeInsets.all(20),

                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.blue[300],
                                    Colors.blue[400],
                                    Colors.blueAccent,
                                  ],
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Text('LOGIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          color: Colors.transparent,
                          elevation: 0,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      ),
                      Container(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }else if(MediaQuery.of(context).size.width >= 400 && MediaQuery.of(context).size.height >= 700){
      return ListView(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage('Assets/img/undraw_mobile_login_ikmv.png'),width: 350,),
                      Container(height: 12.0),
                      Text('Login',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Container(height: 10,),
                      Text('Login terlebih dahulu untuk melihat infomasi absensi menggunakan nik',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),

                      Container(height: 30.0),
                      TextField(
                        keyboardType: TextInputType.number,
                        onSubmitted: (text){
                          _login();
                        },
                        controller: nik,
                        obscureText: false,
                        style: TextStyle(fontSize: 20.0),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "NIK",
                        ),
                      ),
                      Container(height: 25.0),
                      Text(msg,style: TextStyle(fontSize: 20.0,color: Colors.red),),
                      Container(
                        child:  MaterialButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: (){
                            _login();
//                            setState(() {
//                              karyawan = _fetchKaryawan();
//                            });
//                                                setState(() {});
//                LoginNow();
                          },//since this is only a UI app
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            padding: EdgeInsets.all(20),

                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.blue[300],
                                    Colors.blue[400],
                                    Colors.blueAccent,
                                  ],
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Text('LOGIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          color: Colors.transparent,
                          elevation: 0,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      ),
                      Container(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }else{
      return ListView(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage('Assets/img/undraw_mobile_login_ikmv.png'),width: 250,),
                      Container(height: 12.0),
                      Text('Login',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Container(height: 10,),
                      Text('Login terlebih dahulu untuk melihat infomasi absensi menggunakan nik',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),

                      Container(height: 30.0),
                      TextField(
                        keyboardType: TextInputType.number,
                        onSubmitted: (text){
                          _login();
                        },
                        controller: nik,
                        obscureText: false,
                        style: TextStyle(fontSize: 20.0),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "NIK",
                        ),
                      ),
                      Container(height: 25.0),
                      Text(msg,style: TextStyle(fontSize: 20.0,color: Colors.red),),
                      Container(
                        child:  MaterialButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: (){
                            _login();
//                            setState(() {
//                              karyawan = _fetchKaryawan();
//                            });
//                                                setState(() {});
//                LoginNow();
                          },//since this is only a UI app
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            padding: EdgeInsets.all(20),

                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.blue[300],
                                    Colors.blue[400],
                                    Colors.blueAccent,
                                  ],
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Text('LOGIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          color: Colors.transparent,
                          elevation: 0,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      ),
                      Container(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    CekLogin();
//    GetDetailUser();
//    print(nama_lengkapx);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    return Scaffold(
//      backgroundColor: Colors.lightBlue[400],
      body: wi300(),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
