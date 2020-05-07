import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:cloudabsen/PageAdmin.dart';
import 'package:cloudabsen/karyawan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cloudabsen/login.dart';
import 'package:flutter/services.dart' ;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("Assets/img/splash-screen-01.png"),context);
    precacheImage(AssetImage("Assets/img/footer-01.png"),context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloud Absen Stikes Banyuwangi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Cloud Absen Stikes Banyuwangi'),
//      routes: <String,WidgetBuilder>{
//        '/AdminPage': (BuildContext context)=> new PageAdmin(nik: nikq,nama_karyawan:nama_karyawan,status:status),
//        '/MemberPage': (BuildContext context)=> new KaryawanPage(nik: nikq,nama_karyawan:nama_karyawan,status:status),
//        '/MyHomePage': (BuildContext context)=> new MyHomePage(),
//      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String nikq = '';
  String nama_karyawan = '';
  String status = '';

  ProgressDialog pr;

  ImageProvider logo1 = AssetImage("Assets/img/splash-screen-01.png");
  ImageProvider logo2 = AssetImage("Assets/img/footer-01.png");

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

  CekLogin()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var nikx = prefs.getString('nik');
    if( nikx!= "" && nikx!= null ){
      final response = await http.post("https://android.stikesbanyuwangi.ac.id/p/cek_karyawan", body: {
        "nik": prefs.getString('nik'),
      });
      if(response.statusCode == 200) {
        var datauser = jsonDecode(response.body);
        final response1 = http.post("https://android.stikesbanyuwangi.ac.id/p/update_data_device1", body: {
          "nik": datauser[0]['nik'],
          'model_hp' : androidInfo.model.toString(),
          'device_fracture':androidInfo.manufacturer.toString(),
        });
        setState(() {
          nikq= datauser[0]['nik'];
          nama_karyawan= datauser[0]['nama_karyawan'];
          status= datauser[0]['status'];
        });
        if(datauser[0]['statusDivisi']=='Admin'){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PageAdmin(
            nik: nikq,
            nama_karyawan: nama_karyawan,
            status: status,
          )));
        }else if(datauser[0]['statusDivisi']==''){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => KaryawanPage(
            nik: nikq,
            nama_karyawan: nama_karyawan,
            status: status,
          )));
        }
      }else{
        notif3();
      }
//      print('sudah login');
    }else{
      Timer(Duration(seconds: 4), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login(
      ))));
//      print('belom');
    }
  }

  @override
  void initState() {
    super.initState();
    CekLogin();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0x2ff4173CC),
                  Color(0x2ff1DA0F2),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
//                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: logo1,width: 250,),
//                      Text(
//                        "Cloud Absen",
//                        style: TextStyle(
//                            color: Colors.black,
//                            fontWeight: FontWeight.bold,
//                            fontSize: 24.0),
//                      ),

                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                    Padding(
//                      padding: EdgeInsets.only(top: 20.0),
//                    ),
                    Image(image: logo2,width: 180,),

//                    Text(
//                      "dsfs",
//                      softWrap: true,
//                      textAlign: TextAlign.center,
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 18.0,
//                          color: Colors.white),
//                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
