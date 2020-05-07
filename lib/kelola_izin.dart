import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:cloudabsen/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' ;

class KelolaIzin extends StatefulWidget {
  KelolaIzin({this.nik,this.nama_karyawan,this.status});
  final String nik;
  final String nama_karyawan;
  final String status;


  @override
  _KelolaIzinState createState() => _KelolaIzinState();
}

class _KelolaIzinState extends State<KelolaIzin> {

  Future<void> Notif(url) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.network(
                  url,fit: BoxFit.fill,
                )
//                Text('Username atau password anda salah !'),
              ],
            ),
          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('OK'),
//              onPressed: () {
//                Navigator.of(context).pop('OK');
//              },
//            ),
//          ],
        );
      },
    );
  }

  Logout2(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage()), (route) => false);
  }

  Logout()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("nik");
    Logout2();
  }

  Future<List> karyawan;


  @override
  void initState() {
    super.initState();
    karyawan = _fetchKaryawan();
  }


  Future<List> _fetchKaryawan() async {
//    var response = await http.get(uri);

    final response = await http.post(Uri.parse("https://android.stikesbanyuwangi.ac.id/p/absen_hari_ini"),body: {
      "pencarian": 'Izin',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load internet');
    }
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
          fontSize: 13,
          fontWeight: FontWeight.w700
      ),);
    }else{
      return Text(nama, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700
      ),);
    }
  }

  Widget CekButton(tipe){
    if(tipe == 'Scan In'){
      return Container(
        child:  MaterialButton(
          padding: EdgeInsets.all(0.0),
          onPressed: (){
            setState(() {
              karyawan = _fetchKaryawan();
            });
//                                                setState(() {});
//                LoginNow();
          },//since this is only a UI app
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.blue[300],
                    Colors.blue[500],
                    Colors.blueAccent,
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            child: Text('Masuk',
              style: TextStyle(
                fontSize: 10,
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
      );
    }else if(tipe == 'Scan Out'){
      return Container(
        child:  MaterialButton(
          padding: EdgeInsets.all(0.0),
          onPressed: (){
            setState(() {
              karyawan = _fetchKaryawan();
            });
//                                                setState(() {});
//                LoginNow();
          },//since this is only a UI app
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.red[300],
                    Colors.red[500],
                    Colors.redAccent,
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            child: Text('Pulang',
              style: TextStyle(
                fontSize: 10,
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
      );
    }else{
      return Container(
        child:  MaterialButton(
          padding: EdgeInsets.all(0.0),
          onPressed: (){
            setState(() {
              karyawan = _fetchKaryawan();
            });
//                                                setState(() {});
//                LoginNow();
          },//since this is only a UI app
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.orange[300],
                    Colors.orange[500],
                    Colors.orangeAccent,
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            child: Text('Izin',
              style: TextStyle(
                fontSize: 10,
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
      );
    }
  }

  Widget wid300() {
    if(MediaQuery.of(context).size.width <= 400 && MediaQuery.of(context).size.height <= 700){
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 250,
                    child: FutureBuilder<List>(
                      future: karyawan,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);

                        return snapshot.hasData
                            ?
                        ListView.builder(
                          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                          itemBuilder: (context, i) {
//                            final list = snapshot.data[i];

                            return new Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
//              padding: EdgeInsets.all(20),
//              margin: EdgeInsets.only(top:140),
                                child: new Container(
                                  padding: EdgeInsets.all(20),
                                  width:MediaQuery.of(context).size.width,
                                  height: 165,
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                CekPanjang(snapshot.data[i]['nama']),
                                                Text(snapshot.data[i]['nik'],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 12
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                ),


                                              ],
                                            ),
                                            CekButton(snapshot.data[i]['type']),
                                          ],
                                        ),
                                      ),
//                                      Image.asset('Assets/img/Screenshot_1348.png',fit: BoxFit.fill,)
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: new Container(
                                                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                                child: Divider(
                                                  color: Colors.black,
                                                  height: 20,
                                                )),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(snapshot.data[i]['date_time'],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 10
                                            ),
                                          ),
                                          Container(
                                            child:  MaterialButton(
                                              padding: EdgeInsets.all(0.0),
                                              onPressed: (){
                                                Notif(snapshot.data[i]['gambar_file']);
//                                                setState(() {
//                                                  karyawan = _fetchKaryawan();
//                                                });
//                                                setState(() {});
//                LoginNow();
                                              },//since this is only a UI app
                                              child: Container(
                                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: <Color>[
                                                        Colors.blue[300],
                                                        Colors.blue[500],
                                                        Colors.blueAccent,
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                ),
                                                child: Text('Lihat Izin',
                                                  style: TextStyle(
                                                    fontSize: 10,
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

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            );
                          },
                        )
                            : new Center(
                          child: new CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      );
    }else if(MediaQuery.of(context).size.width >= 400 && MediaQuery.of(context).size.height >= 700){
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 250,
                    child: FutureBuilder<List>(
                      future: karyawan,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);

                        return snapshot.hasData
                            ? ListView.builder(
                          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                          itemBuilder: (context, i) {
//                            final list = snapshot.data[i];

                            return new Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                CekPanjang(snapshot.data[i]['nama']),
                                                Text(snapshot.data[i]['nik'],
                                                  textAlign: TextAlign.left,
                                                ),
                                                Container(
                                                  height: 20,
                                                ),


                                              ],
                                            ),
                                            CekButton(snapshot.data[i]['type']),
                                          ],
                                        ),
                                      ),
//                                      Image.asset('Assets/img/Screenshot_1348.png',fit: BoxFit.fill,)
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: new Container(
                                                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                                child: Divider(
                                                  color: Colors.black,
                                                  height: 20,
                                                )),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(snapshot.data[i]['date_time'],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 10
                                            ),
                                          ),
                                          Container(
                                            child:  MaterialButton(
                                              padding: EdgeInsets.all(0.0),
                                              onPressed: (){
                                                Notif(snapshot.data[i]['gambar_file']);
//                                                setState(() {
//                                                  karyawan = _fetchKaryawan();
//                                                });
//                                                setState(() {});
//                LoginNow();
                                              },//since this is only a UI app
                                              child: Container(
                                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: <Color>[
                                                        Colors.blue[300],
                                                        Colors.blue[500],
                                                        Colors.blueAccent,
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                ),
                                                child: Text('Lihat Izin',
                                                  style: TextStyle(
                                                    fontSize: 10,
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

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            );
                          },
                        )
                            : new Center(
                          child: new CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      );
    }else{
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 250,
                    child: FutureBuilder<List>(
                      future: karyawan,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);

                        return snapshot.hasData
                            ?
                        ListView.builder(
                          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                          itemBuilder: (context, i) {
//                            final list = snapshot.data[i];

                            return new Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
//              padding: EdgeInsets.all(20),
//              margin: EdgeInsets.only(top:140),
                                child: new Container(
                                  padding: EdgeInsets.all(20),
                                  width:MediaQuery.of(context).size.width,
                                  height: 165,
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                CekPanjang(snapshot.data[i]['nama']),
                                                Text(snapshot.data[i]['nik'],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 12
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                ),


                                              ],
                                            ),
                                            CekButton(snapshot.data[i]['type']),
                                          ],
                                        ),
                                      ),
//                                      Image.asset('Assets/img/Screenshot_1348.png',fit: BoxFit.fill,)
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: new Container(
                                                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                                child: Divider(
                                                  color: Colors.black,
                                                  height: 20,
                                                )),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(snapshot.data[i]['date_time'],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 10
                                            ),
                                          ),
                                          Container(
                                            child:  MaterialButton(
                                              padding: EdgeInsets.all(0.0),
                                              onPressed: (){
                                                Notif(snapshot.data[i]['gambar_file']);
//                                                setState(() {
//                                                  karyawan = _fetchKaryawan();
//                                                });
//                                                setState(() {});
//                LoginNow();
                                              },//since this is only a UI app
                                              child: Container(
                                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: <Color>[
                                                        Colors.blue[300],
                                                        Colors.blue[500],
                                                        Colors.blueAccent,
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                ),
                                                child: Text('Lihat Izin',
                                                  style: TextStyle(
                                                    fontSize: 10,
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

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            );
                          },
                        )
                            : new Center(
                          child: new CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),
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