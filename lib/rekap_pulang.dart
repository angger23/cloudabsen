import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' ;

class RekapPulang extends StatefulWidget {
  RekapPulang({this.nik,this.tanggal});
  final nik;
  final tanggal;

  @override
  _RekapPulangState createState() => _RekapPulangState();
}

class _RekapPulangState extends State<RekapPulang> {

  String jam;
  String stat;

  Future<List> getData2() async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse("https://android.stikesbanyuwangi.ac.id/p/list_jamxy"),body: {
      "nik": widget.nik,
      "jam":jam,
      "stat":stat
    });
    return json.decode(response.body);
  }

  Future<List> getData22() async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse("https://android.stikesbanyuwangi.ac.id/p/list_jamxy"),body: {
      "nik": widget.nik,
      "jam":jam,
      "stat":stat,
      "tanggal":widget.tanggal
    });
    return json.decode(response.body);
  }

  Cek(jamx,statx,jml){
    setState(() {
      jam=jamx;
      stat=statx;
    });

    Notifx(jml);
  }

  Widget yua(){
    if(widget.tanggal == '' || widget.tanggal == null){
      return FutureBuilder<List>(
        future: getData2(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (context, i) {
//                            final list = snapshot.data[i];

              return new Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Color(0x2ffbdc3c7)
                        )
                    )
                ),
                child: ListTile(
//                                leading: Image.asset('Assets/img/Screenshot_1352.png',fit: BoxFit.fill,width: 70,),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Absen Pulang Pada Tanggal',style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(snapshot.data[i]['tanggal'],style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          ),)
                        ],
                      ),

                    ],
                  ),
                ),
              );
            },
          )
              : new Center(
            child: new CircularProgressIndicator(),
          );
        },
      );
    }else{
      return FutureBuilder<List>(
        future: getData22(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (context, i) {
//                            final list = snapshot.data[i];

              return new Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Color(0x2ffbdc3c7)
                        )
                    )
                ),
                child: ListTile(
//                                leading: Image.asset('Assets/img/Screenshot_1352.png',fit: BoxFit.fill,width: 70,),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Absen Pulang Pada Tanggal',style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(snapshot.data[i]['tanggal'],style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          ),)
                        ],
                      ),

                    ],
                  ),
                ),
              );
            },
          )
              : new Center(
            child: new CircularProgressIndicator(),
          );
        },
      );
    }
  }

  Widget yaa(jml){
    if(jml.toString() == '0'){
      return Text('Tidak Ada Data');
    }else{
//      return Text(jml.toString());
      return Expanded(
        child: SizedBox(
          height: 250,
//                    width: 100,
          child: yua(),
        ),
      );
    }
  }

  Future<void> Notifx(jml) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data Rekap Absensi Pulang',style: TextStyle(
              fontSize: 14
          ),),
//          content: SingleChildScrollView(
          content: Container(
            width: 700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                yaa(jml),

              ],
            ),
          ),
//          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop('OK');
              },
            ),
          ],
        );
      },
    );
  }


  Future<List> getData() async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse("https://android.stikesbanyuwangi.ac.id/p/list_jam"),body: {
      "stat1": 'Pulang',
      "stat2": 'Scan Out',
      "nik": widget.nik,
    });
    return json.decode(response.body);
  }

  Future<List> getData1() async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse("https://android.stikesbanyuwangi.ac.id/p/list_jam"),body: {
      "stat1": 'Pulang',
      "stat2": 'Scan Out',
      "nik": widget.nik,
      "tanggal" : widget.tanggal
    });
    return json.decode(response.body);
  }

  Widget CekPanjang1(nama){
    if(nama.length >= 23){
      return Text(nama, style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w700
      ),);
    }else{
      return Text(nama, style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700
      ),);
    }
  }
  Widget CekPanjang(nama){
    if(nama.length >= 23){
      return Text(nama, style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700
      ),);
    }else{
      return Text(nama, style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700
      ),);
    }
  }

  Widget ua1(){
    if(widget.tanggal == '' || widget.tanggal == null) {
      return FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (context, i) {
//                            final list = snapshot.data[i];

              return new Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Color(0x2ffbdc3c7)
                        )
                    )
                ),
                child: ListTile(
                  leading: Image.asset('Assets/img/Screenshot_1352.png',fit: BoxFit.fill,width: 70,),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Jam',style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          ),),
                          Text(snapshot.data[i]['jam']+':',style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          ),)
                        ],
                      ),
                      Text('Pulang',style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey
                      ),)
                    ],
                  ),
                  trailing: Text(snapshot.data[i]['jml'],style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                  ),),
                  onTap: (){
                    Cek(snapshot.data[i]['jam'], 'Scan Out',snapshot.data[i]['jml']);
                  },
                ),
              );
            },
          )
              : new Center(
            child: new CircularProgressIndicator(),
          );
        },
      );
    }else{
      return FutureBuilder<List>(
        future: getData1(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (context, i) {
//                            final list = snapshot.data[i];

              return new Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Color(0x2ffbdc3c7)
                        )
                    )
                ),
                child: ListTile(
                  leading: Image.asset('Assets/img/Screenshot_1352.png',fit: BoxFit.fill,width: 70,),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Jam',style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          ),),
                          Text(snapshot.data[i]['jam']+':',style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          ),)
                        ],
                      ),
                      Text('Pulang',style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey
                      ),)
                    ],
                  ),
                  trailing: Text(snapshot.data[i]['jml'],style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                  ),),
                  onTap: (){
                    Cek(snapshot.data[i]['jam'], 'Scan Out',snapshot.data[i]['jml']);
                  },
                ),
              );
            },
          )
              : new Center(
            child: new CircularProgressIndicator(),
          );
        },
      );
    }
  }

  Widget ua(){
    if(widget.tanggal == '' || widget.tanggal == null) {
      return FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (context, i) {
//                            final list = snapshot.data[i];

              return new Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Color(0x2ffbdc3c7)
                        )
                    )
                ),
                child: ListTile(
                  leading: Image.asset('Assets/img/Screenshot_1352.png',fit: BoxFit.fill,),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Jam',style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),),
                          Text(snapshot.data[i]['jam']+':',style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),)
                        ],
                      ),
                      Text('Pulang',style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey
                      ),)
                    ],
                  ),
                  trailing: Text(snapshot.data[i]['jml'],style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                  ),),
                  onTap: (){
                    Cek(snapshot.data[i]['jam'], 'Scan Out',snapshot.data[i]['jml']);
                  },
                ),
              );
            },
          )
              : new Center(
            child: new CircularProgressIndicator(),
          );
        },
      );
    }else{
      return FutureBuilder<List>(
        future: getData1(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (context, i) {
//                            final list = snapshot.data[i];

              return new Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Color(0x2ffbdc3c7)
                        )
                    )
                ),
                child: ListTile(
                  leading: Image.asset('Assets/img/Screenshot_1352.png',fit: BoxFit.fill,),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Jam',style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),),
                          Text(snapshot.data[i]['jam']+':',style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),)
                        ],
                      ),
                      Text('Pulang',style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey
                      ),)
                    ],
                  ),
                  trailing: Text(snapshot.data[i]['jml'],style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                  ),),
                  onTap: (){
                    Cek(snapshot.data[i]['jam'], 'Scan Out',snapshot.data[i]['jml']);
                  },
                ),
              );
            },
          )
              : new Center(
            child: new CircularProgressIndicator(),
          );
        },
      );
    }
  }

  Widget W300(){
    if(MediaQuery.of(context).size.width <= 400 && MediaQuery.of(context).size.height <= 700) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
          color: Colors.white,
//          borderRadius: BorderRadius.circular(6.0),
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
        child: Container(
          padding: EdgeInsets.all(10),
          child: ua1(),
        ),
      );
    }else if(MediaQuery.of(context).size.width >= 400 && MediaQuery.of(context).size.height >= 700){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
          color: Colors.white,
//          borderRadius: BorderRadius.circular(6.0),
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
        child: Container(
          padding: EdgeInsets.all(20),
          child: ua(),
        ),
      );
    }else{
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
          color: Colors.white,
//          borderRadius: BorderRadius.circular(6.0),
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
        child: Container(
          padding: EdgeInsets.all(10),
          child: ua1(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: W300(),
    );
  }
}