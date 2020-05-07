import 'dart:ui';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:cloudabsen/list_karyawan.dart';
import 'package:cloudabsen/migrasi_absen.dart';
import 'package:cloudabsen/login.dart';
import 'package:cloudabsen/kelola_absen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart' ;

class PageAdmin extends StatefulWidget {
  PageAdmin({this.nik,this.nama_karyawan,this.status});
  final String nik;
  final String nama_karyawan;
  final String status;

  @override
  _PageAdminState createState() => _PageAdminState();
}

class _PageAdminState extends State<PageAdmin> {

  String msg='';

  Logout2(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  Logout()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("nik");
    Logout2();
  }

  cekuser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('nik'));
    setState(() {
      msg=prefs.get('nik');
    });
  }
  @override
  void initState() {
    super.initState();
    cekuser();
//    GetDetailUser();
//    print(nama_lengkapx);
  }
  Widget wid300(){
    if(MediaQuery.of(context).size.width <= 400 && MediaQuery.of(context).size.height <= 700){
      return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xff047bf9),
              borderRadius: new BorderRadius.only(
//                bottomRight: new Radius.circular(60.0),
                bottomLeft: new Radius.circular(80.0),
              ),
            ),
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: 70,left:30),
              child: Text("by gloob media",
//                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.white
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:140),
            child: new Container(
              padding: EdgeInsets.all(20),
              width:MediaQuery.of(context).size.width,
              height: 150,
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Absensi Hari Ini', style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto-Regular',
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Laporan Absensi Hari ini',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.blueAccent)),
                        color: Colors.white,
                        textColor: Colors.blueAccent,
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KelolaAbsen(
                                    nik:widget.nik,
                                    nama_karyawan:widget.nama_karyawan,
                                    status:widget.status,
                                  )
                              )
                          );
                        },
                        child: Text(
                          "Kelola".toUpperCase(),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Roboto-Regular',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Image.asset('Assets/img/Screenshot_1347.png',fit: BoxFit.fill,)

                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:310),
            child: new Container(
              width:MediaQuery.of(context).size.width,
              height: 80,
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
              child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                onPressed: (){
//                  ohYeaa();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MigrasiAbsen()
                      )
                  );
                },
                child: new Center(
                  child: Padding(
                    padding : EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Image.asset('Assets/img/undraw_server_q2pb.png',fit: BoxFit.fill,),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Migrasi Absensi',style: TextStyle(
                                    fontWeight: FontWeight.w700,

                                  ),),
                                  Container(
                                    height: 5,
                                  ),
                                  Text('Migrasi data mesin ke server',style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:410),
            child: new Container(
              width:MediaQuery.of(context).size.width,
              height: 80,
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
              child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListKaryawan()
                      )
                  );
                },
                child: new Center(
                  child: Padding(
                    padding : EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Image.asset('Assets/img/undraw_people_search_wctu.png',fit: BoxFit.fill,),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Karyawan',style: TextStyle(
                                    fontWeight: FontWeight.w700,

                                  ),),
                                  Container(
                                    height: 5,
                                  ),
                                  Text('List Karyawan Stikes Banyuwangi',style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 10
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:510),
            child:  MaterialButton(
              onPressed: (){
                Logout();
//                LoginNow();
              },//since this is only a UI app
              child: Text('LOGOUT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Colors.orange[300],
              elevation: 0,
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
            ),
          ),


          Positioned(
//            top: 100.0,
            left: 0.1,
            right: 0.1,
            child: AppBar(
              iconTheme: new IconThemeData(color: Colors.white),
              title: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    Text("Stikes",
                      style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(" Banyuwangi",
                      style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(" Absensi",
                      style: TextStyle(
                        fontFamily: 'Roboto-Light',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
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
                  Color(0xff047bf9),
                ],
              ),
              borderRadius: new BorderRadius.only(
//                bottomRight: new Radius.circular(60.0),
                bottomLeft: new Radius.circular(80.0),
              ),
            ),
            height: 140,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: 85,left:28),
              child: Text('by gloob media',
//                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.white
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:140),
            child: new Container(
              padding: EdgeInsets.all(20),
              width:MediaQuery.of(context).size.width,
              height: 170,
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Absensi Hari Ini', style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          fontSize: 25,
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Laporan Absensi Hari ini',
                        style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        height: 25,
                      ),
                      FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.blueAccent)),
                        color: Colors.white,
                        textColor: Colors.blueAccent,
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KelolaAbsen(
                                    nik:widget.nik,
                                    nama_karyawan:widget.nama_karyawan,
                                    status:widget.status,
                                  )
                              )
                          );
                        },
                        child: Text(
                          "Kelola".toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Roboto-Regular',
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Image.asset('Assets/img/Screenshot_1347.png',fit: BoxFit.fill,)

                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:330),
            child: new Container(
              width:MediaQuery.of(context).size.width,
              height: 80,
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
              child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MigrasiAbsen(
                            tanggalMigra:'',
                          )
                      )
                  );
                },
                child: new Center(
                  child: Padding(
                    padding : EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Image.asset('Assets/img/undraw_server_q2pb.png',fit: BoxFit.fill,),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Migrasi Absensi',style: TextStyle(
                                    fontWeight: FontWeight.w700,

                                  ),),
                                  Container(
                                    height: 5,
                                  ),
                                  Text('Migrasi data mesin ke server',style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:430),
            child: new Container(
              width:MediaQuery.of(context).size.width,
              height: 80,
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
              child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListKaryawan()
                      )
                  );
                },
                child: new Center(
                  child: Padding(
                    padding : EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Image.asset('Assets/img/undraw_people_search_wctu.png',fit: BoxFit.fill,),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Karyawan',style: TextStyle(
                                    fontWeight: FontWeight.w700,

                                  ),),
                                  Container(
                                    height: 5,
                                  ),
                                  Text('List Karyawan Stikes Banyuwangi',style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:530),
            child:  MaterialButton(
              onPressed: (){
                Logout();
//                LoginNow();
              },//since this is only a UI app
              child: Text('LOGOUT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Colors.orange[300],
              elevation: 0,
              minWidth: MediaQuery.of(context).size.width,
              height: 70,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
            ),
          ),


          Positioned(
//            top: 100.0,
            left: 0.1,
            right: 0.1,
            child: AppBar(
              iconTheme: new IconThemeData(color: Colors.white),
              title: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    Text("Stikes",
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(" Banyuwangi",
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(" Absensi",
                      style: TextStyle(
                        fontFamily: 'Roboto-Light',
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          )

        ],
      );
    }else{
      return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xff047bf9),
              borderRadius: new BorderRadius.only(
//                bottomRight: new Radius.circular(60.0),
                bottomLeft: new Radius.circular(80.0),
              ),
            ),
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: 70,left:30),
              child: Text("by gloob media",
//                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.white
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:140),
            child: new Container(
              padding: EdgeInsets.all(20),
              width:MediaQuery.of(context).size.width,
              height: 150,
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Absensi Hari Ini', style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto-Regular',
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Laporan Absensi Hari ini',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.blueAccent)),
                        color: Colors.white,
                        textColor: Colors.blueAccent,
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KelolaAbsen(
                                    nik:widget.nik,
                                    nama_karyawan:widget.nama_karyawan,
                                    status:widget.status,
                                  )
                              )
                          );
                        },
                        child: Text(
                          "Kelola".toUpperCase(),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Roboto-Regular',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Image.asset('Assets/img/Screenshot_1347.png',fit: BoxFit.fill,)

                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:310),
            child: new Container(
              width:MediaQuery.of(context).size.width,
              height: 80,
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
              child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                onPressed: (){
//                  ohYeaa();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MigrasiAbsen()
                      )
                  );
                },
                child: new Center(
                  child: Padding(
                    padding : EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Image.asset('Assets/img/undraw_server_q2pb.png',fit: BoxFit.fill,),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Migrasi Absensi',style: TextStyle(
                                    fontWeight: FontWeight.w700,

                                  ),),
                                  Container(
                                    height: 5,
                                  ),
                                  Text('Migrasi data mesin ke server',style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:410),
            child: new Container(
              width:MediaQuery.of(context).size.width,
              height: 80,
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
              child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListKaryawan()
                      )
                  );
                },
                child: new Center(
                  child: Padding(
                    padding : EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Image.asset('Assets/img/undraw_people_search_wctu.png',fit: BoxFit.fill,),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Karyawan',style: TextStyle(
                                    fontWeight: FontWeight.w700,

                                  ),),
                                  Container(
                                    height: 5,
                                  ),
                                  Text('List Karyawan Stikes Banyuwangi',style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 10
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:510),
            child:  MaterialButton(
              onPressed: (){
                Logout();
//                LoginNow();
              },//since this is only a UI app
              child: Text('LOGOUT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Colors.orange[300],
              elevation: 0,
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
            ),
          ),


          Positioned(
//            top: 100.0,
            left: 0.1,
            right: 0.1,
            child: AppBar(
              iconTheme: new IconThemeData(color: Colors.white),
              title: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    Text("Stikes",
                      style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(" Banyuwangi",
                      style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(" Absensi",
                      style: TextStyle(
                        fontFamily: 'Roboto-Light',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
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
    return Scaffold(
      body:wid300(),
    );
  }
}
