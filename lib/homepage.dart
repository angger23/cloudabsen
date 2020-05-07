import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloudabsen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cloudabsen/form_scan_in.dart';
import 'package:flutter/services.dart' ;
import 'package:cloudabsen/form_telat.dart';
import 'package:cloudabsen/form_cepat.dart';

class HomePage extends StatefulWidget {
  HomePage({this.nik,this.nama_karyawan,this.status});
  final String nik;
  final String nama_karyawan;
  final String status;


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Logout2(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  Logout()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("nik");
    Logout2();
  }

  Future<List> karyawan;

  String hadir;
  String izin;
  String persen;




  @override
  void initState() {
    super.initState();
    karyawan = _fetchKaryawan();
    CekPersentase();
  }


  CekPersentase()async{
    final response = await http.post("https://android.stikesbanyuwangi.ac.id/p/presentase", body: {
      "nik": widget.nik,
    });
    var datauser = jsonDecode(response.body);
    setState(() {
      hadir= datauser[0]['hadir'].toString();
      izin= datauser[0]['izin'].toString();
      persen= datauser[0]['persen'].toString();
    });

  }

  Future<List> _fetchKaryawan() async {
//    var response = await http.get(uri);

    final response = await http.post(Uri.parse("https://android.stikesbanyuwangi.ac.id/p/absen_hari_ini21"),body: {
      "pencarian": 'Scan In',
      "nik": widget.nik,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load internet');
    }
  }

  Future<void> notifx() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gagal'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Gagal Koneksi ke server.',style: TextStyle(
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

  Future<void> notify() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Absen By Phone Ditutup'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Saat ini tidak terjadi pemadaman di STIKES Banyuwangi',style: TextStyle(
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

  cekListrik()async{
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormScanIn(
              nik:widget.nik,
              nama_karyawan:widget.nama_karyawan,
              status:widget.status,
            )
        )
    );
//    final response = await http.post("https://android.stikesbanyuwangi.ac.id/p/mati_listrik");
//      if(response.statusCode == 200) {
//        var datauser = jsonDecode(response.body);
//        if(datauser['listrik'] == 'mati'){
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => FormScanIn(
//                    nik:widget.nik,
//                    nama_karyawan:widget.nama_karyawan,
//                    status:widget.status,
//                  )
//              )
//          );
//        }else{
//          notify();
//        }
//      }else{
//        notifx();
//      }

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

  Widget CekButton(tipe,hours,min,tanggalx){

    if(tipe == 'Scan In'){
      if(hours == 08){
        if(min > 30){
          return Container(
            child:  MaterialButton(
              padding: EdgeInsets.all(0.0),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormTelat(
                          nik:widget.nik,
                          nama_karyawan:widget.nama_karyawan,
                          status:widget.status,
                          tanggal:tanggalx
                        )
                    )
                );
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
                child: Text('Terlambat',
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormTelat(
                            nik:widget.nik,
                            nama_karyawan:widget.nama_karyawan,
                            status:widget.status,
                            tanggal:tanggalx
                        )
                    )
                );
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
        }
      }else if(hours >= 08){
        return Container(
          child:  MaterialButton(
            padding: EdgeInsets.all(0.0),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FormTelat(
                          nik:widget.nik,
                          nama_karyawan:widget.nama_karyawan,
                          status:widget.status,
                          tanggal:tanggalx
                      )
                  )
              );
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
              child: Text('Terlambat',
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
      }
    }else{
      if(hours <= 15){
        return Container(
          child:  MaterialButton(
            padding: EdgeInsets.all(0.0),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FormCepat(
                          nik:widget.nik,
                          nama_karyawan:widget.nama_karyawan,
                          status:widget.status,
                          tanggal:tanggalx
                      )
                  )
              );
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
              child: Text('Pulang Cepat',
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
      }
    }
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


  Widget wi300(){
    if(MediaQuery.of(context).size.width <= 400 && MediaQuery.of(context).size.height <= 700) {
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
              borderRadius: new BorderRadius.only(
                bottomRight: new Radius.circular(20.0),
                bottomLeft: new Radius.circular(20.0),
              ),
            ),
            height: 160,
            width: MediaQuery.of(context).size.width,
          ),

          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:120),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(height: 50,),
                  Text(widget.nama_karyawan.toUpperCase(),style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400
                  ),
                  ),
                  Text('NIK: '+widget.nik,style: TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400
                  ),),
                  Container(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
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
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Hadir',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              ' | ',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              (hadir == null) ? '' : hadir,style: TextStyle(
                                fontSize: 8,
                                color: Colors.blue,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 8,),
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
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
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Izin',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              ' | ',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              (izin == null) ? '' : izin,style: TextStyle(
                                fontSize: 8,
                                color: Colors.blue,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 8,),
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
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
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '%',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              ' | ',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              (persen == null) ? '' : persen,style: TextStyle(
                                fontSize: 8,
                                color: Colors.blue,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
//                      Expanded(
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Text('ERIK TOGA',style: TextStyle(
//                              fontSize: 20,
//                              color: Colors.black54,
//                              fontWeight: FontWeight.w400
//                            ),),
//
//                          ],
//                        ),
//                      ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: new Container(
                    width:120,
                    height:120,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
//                                  color: Colors.blue,
                                ),
                                child: Padding(
                                    padding : EdgeInsets.all(20.0),
                                    child: Image.asset('Assets/img/avatar.png',)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 280),
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
                            height: 130,
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
                                      CekButton(snapshot.data[i]['type'],int.parse(snapshot.data[i]['hours']),int.parse(snapshot.data[i]['min']),snapshot.data[i]['date_time']),
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
                                Text(snapshot.data[i]['date_time'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 10
                                  ),
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

          Positioned(
//            top: 100.0,
            left: 0.1,
            right: 0.1,
            child: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: new IconThemeData(color: Colors.white),
              title: Text("Profil",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
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
                  Colors.blue[500],
                ],
              ),
              borderRadius: new BorderRadius.only(
                bottomRight: new Radius.circular(20.0),
                bottomLeft: new Radius.circular(20.0),
              ),
            ),
            height: 200,
            width: MediaQuery.of(context).size.width,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(height: 50,),
                  Text(widget.nama_karyawan.toUpperCase(),style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400
                  ),
                  ),
                  Text('NIK: '+widget.nik,style: TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400
                  ),),
                  Container(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
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
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Hadir',style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              ' | ',style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              (hadir == null) ? '' : hadir,style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 8,),
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
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
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Izin',style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              ' | ',style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              (izin == null) ? '' : izin,style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 8,),
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
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
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '%',style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              ' | ',style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              (persen == null) ? '' : persen,style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
//                      Expanded(
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Text('ERIK TOGA',style: TextStyle(
//                              fontSize: 20,
//                              color: Colors.black54,
//                              fontWeight: FontWeight.w400
//                            ),),
//
//                          ],
//                        ),
//                      ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: new Container(
                    width:120,
                    height:120,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
//                                  color: Colors.blue,
                                ),
                                child: Padding(
                                    padding : EdgeInsets.all(20.0),
                                    child: Image.asset('Assets/img/avatar.png',)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 320),
            child: SizedBox(
              height: 350,
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
                            height: 140,
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
                                      CekButton(snapshot.data[i]['type'],int.parse(snapshot.data[i]['hours']),int.parse(snapshot.data[i]['min']),snapshot.data[i]['date_time']),
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
                                Text(snapshot.data[i]['date_time'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 10
                                  ),
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

          Positioned(
//            top: 100.0,
            left: 0.1,
            right: 0.1,
            child: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: new IconThemeData(color: Colors.white),
              title: Text("Profil",
                style: TextStyle(
                  color: Colors.white,
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
              borderRadius: new BorderRadius.only(
                bottomRight: new Radius.circular(20.0),
                bottomLeft: new Radius.circular(20.0),
              ),
            ),
            height: 160,
            width: MediaQuery.of(context).size.width,
          ),

          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:120),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(height: 50,),
                  Text(widget.nama_karyawan.toUpperCase(),style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400
                  ),
                  ),
                  Text('NIK: '+widget.nik,style: TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400
                  ),),
                  Container(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
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
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Hadir',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              ' | ',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              (hadir == null) ? '' : hadir,style: TextStyle(
                                fontSize: 8,
                                color: Colors.blue,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 8,),
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
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
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Izin',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              ' | ',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              (izin == null) ? '' : izin,style: TextStyle(
                                fontSize: 8,
                                color: Colors.blue,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 8,),
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
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
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '%',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              ' | ',style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                            Text(
                              (persen == null) ? '' : persen,style: TextStyle(
                                fontSize: 8,
                                color: Colors.blue,
                                fontWeight: FontWeight.w400
                            ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
//                      Expanded(
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Text('ERIK TOGA',style: TextStyle(
//                              fontSize: 20,
//                              color: Colors.black54,
//                              fontWeight: FontWeight.w400
//                            ),),
//
//                          ],
//                        ),
//                      ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: new Container(
                    width:120,
                    height:120,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
//                                  color: Colors.blue,
                                ),
                                child: Padding(
                                    padding : EdgeInsets.all(20.0),
                                    child: Image.asset('Assets/img/avatar.png',)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 280),
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
                            height: 130,
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
                                      CekButton(snapshot.data[i]['type'],int.parse(snapshot.data[i]['hours']),int.parse(snapshot.data[i]['min']),snapshot.data[i]['date_time']),
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
                                Text(snapshot.data[i]['date_time'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 10
                                  ),
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

          Positioned(
//            top: 100.0,
            left: 0.1,
            right: 0.1,
            child: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: new IconThemeData(color: Colors.white),
              title: Text("Profil",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
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
    return Scaffold(
      body: wi300(),
      floatingActionButton: FloatingActionButton(
        tooltip: "Absen By Phone",
        onPressed: () {
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => FormTelat(
//                      nik:widget.nik,
//                      nama_karyawan:widget.nama_karyawan,
//                      status:widget.status,
//                      tanggal:"2020-02-22 08:40:00"
//                  )
//              )
//          );
          cekListrik();
        },
        child: Icon(Icons.phone_android),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}