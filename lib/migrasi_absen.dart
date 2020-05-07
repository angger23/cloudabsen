import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
//import 'package:cloudabsen/daftar_karyawan.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart' ;

class MigrasiAbsen extends StatefulWidget {

  final tanggalMigra;

  MigrasiAbsen({this.tanggalMigra});

  @override
  _MigrasiAbsenState createState() => _MigrasiAbsenState();
}

class _MigrasiAbsenState extends State<MigrasiAbsen> {
  ProgressDialog pr;

  final format = DateFormat("yyyy-MM-dd");


  Future<List> karyawan;


  TextEditingController tanggal_migrasi = TextEditingController();
  @override
  void initState() {
    super.initState();
    karyawan = _fetchKaryawan();
    tanggal_migrasi.text=widget.tanggalMigra;
  }

  Future<void> Notif(msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
//          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

                Text(msg),
              ],
            ),
          ),
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

  CariData()async{
//    http.Response response = await http.post(Uri.parse("https://android.stikesbanyuwangi.ac.id/welcome/pencarian_migrasi2"),body: {
//      "pencarian": tanggal_migrasi.text,
//    });
//    var data = jsonDecode(response.body);
//    print(data.toString());
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MigrasiAbsen(
      tanggalMigra:tanggal_migrasi.text,
    )));
  }

  MigrateNow()async{
    pr.show();

    final response = await http.post(Uri.parse("https://android.stikesbanyuwangi.ac.id/p/migrasi_absen"),body: {
      "pencarian": widget.tanggalMigra,
    });

    Future.delayed(Duration(seconds: 3)).then((value) {
      pr.hide().whenComplete(() {

        if (response.statusCode == 200) {
          Notif('Migrasi Berhasil');
//      return jsonDecode(response.body);
        } else {
          Notif('Failed to load internet');

//          throw Exception('Failed to load internet');
        }

      });
    });
  }


  Future<List> _fetchKaryawan() async {
    final response = await http.post(Uri.parse("https://android.stikesbanyuwangi.ac.id/welcome/pencarian_migrasi2"),body: {
      "pencarian": widget.tanggalMigra,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load internet');
    }
  }

//  Future<List> getData() async {
//    final response = await http.get("https://android.stikesbanyuwangi.ac.id/welcome/get_data_karyawan");
//    return json.decode(response.body);
//  }

//  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
//    RaisedButton button = RaisedButton(onPressed: () {
//      setState(() {});
//    }, child: Text('Refresh'),);
//    //.. here create widget with snapshot data and with necessary button
//  }

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
            child: Text(tipe.toString(),
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
            child: Text(tipe.toString(),
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.blueAccent,
                  Color(0xff047bf9),
                ],
              ),
            ),
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text("Migrasi Absen",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto-Regular',
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:70),
            child: new Container(
              padding: EdgeInsets.all(10),
              width:MediaQuery.of(context).size.width,
              height: 70,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width:200,
                    child: DateTimeField(
                      controller: tanggal_migrasi,
                      decoration: new InputDecoration(
                        labelStyle: TextStyle(
                            fontSize: 13
                        ),
                        labelText: "Pilih Tanggal",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      format: format,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                    ),
                  ),
                  Container(width: 10,),
                  Container(
                    width: 50,
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.blue,
                      icon: Icon(Icons.search),
                      onPressed: (){
                        CariData();

//                        print('sds');
//                    Logout();
                      },
                    ),
//                    child: RaisedButton(
//                      padding: const EdgeInsets.all(5.0),
//                      textColor: Colors.white,
//                      color: Colors.blue[500],
//                      onPressed: (){
////                        CariGan();
////                    TambahData();
//                      },
//                      child: new Icon(Icons.search),
//                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top:160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 250,
                    child: (tanggal_migrasi.text == "") ? Container(
//                      child: Text('pilih tanggal'),
                    )  : FutureBuilder<List>(
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

              ],
            ),
          ),
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
            ),
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text("Migrasi Absen",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto-Regular',
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:70),
            child: new Container(
              padding: EdgeInsets.all(10),
              width:MediaQuery.of(context).size.width,
              height: 70,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width:280,
                    child: DateTimeField(
                      controller: tanggal_migrasi,
                      decoration: new InputDecoration(
                        labelText: "Pilih Tanggal",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.0),
                        ),
                      ),
                      format: format,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                    ),
                  ),
                  Container(width: 10,),
                  Container(
                    width: 50,
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.blue,
                      icon: Icon(Icons.search),
                      onPressed: (){
//                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MigrasiAbsen(
//                          tanggalMigra:'',
//                        )));
                        CariData();
//                    Logout();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top:160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 250,
                    child: (widget.tanggalMigra == "") ? Container(
//                      child: Text('pilih tanggal'),
                    ) : FutureBuilder<List>(
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

              ],
            ),
          ),
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
                  Color(0xff047bf9),
                ],
              ),
            ),
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text("Migrasi Absen",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto-Regular',
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:70),
            child: new Container(
              padding: EdgeInsets.all(10),
              width:MediaQuery.of(context).size.width,
              height: 70,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width:280,
                    child: DateTimeField(
                      controller: tanggal_migrasi,
                      decoration: new InputDecoration(
                        labelText: "Pilih Tanggal",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.0),
                        ),
                      ),
                      format: format,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                    ),
                  ),
                  Container(width: 10,),
                  Container(
                    width: 50,
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.blue,
                      icon: Icon(Icons.search),
                      onPressed: (){
//                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MigrasiAbsen(
//                          tanggalMigra:'',
//                        )));
                        CariData();
//                    Logout();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top:160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 250,
                    child: (widget.tanggalMigra == "") ? Container(
//                      child: Text('pilih tanggal'),
                    ) : FutureBuilder<List>(
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

              ],
            ),
          ),
        ],
      );
    }
  }

  Widget Floating(){
    if(tanggal_migrasi.text == ""){

    }else{
      if(MediaQuery.of(context).size.width <= 400 && MediaQuery.of(context).size.height <= 700){
        return MaterialButton(
          padding: EdgeInsets.all(0.0),
          onPressed: (){
            MigrateNow();
//          setState(() {
//            karyawan = _fetchKaryawan();
//          });
//                                                setState(() {});
//                LoginNow();
          },//since this is only a UI app
          child: Container(
            padding: EdgeInsets.all(13),
//          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
            child: Text('Migrasi Absensi',
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
        );
      }else if(MediaQuery.of(context).size.width >= 400 && MediaQuery.of(context).size.height >= 700){
        return MaterialButton(
          padding: EdgeInsets.all(0.0),
          onPressed: (){
            MigrateNow();

//          setState(() {
//            karyawan = _fetchKaryawan();
//          });
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
            child: Text('Migrasi Absensi',
              style: TextStyle(
                fontSize: 13,
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
        );
      }else{
        return MaterialButton(
          padding: EdgeInsets.all(0.0),
          onPressed: (){
            MigrateNow();

//          setState(() {
//            karyawan = _fetchKaryawan();
//          });
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
            child: Text('Migrasi Absensi',
              style: TextStyle(
                fontSize: 13,
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
        );
      }
    }


  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    return Scaffold(
      body: wid300(),
        floatingActionButton: Container(
            child: Floating()),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    );
  }
}
