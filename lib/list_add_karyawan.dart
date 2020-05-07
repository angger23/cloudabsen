import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
//import 'package:cloudabsen/karyawan_page.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart' ;

class ListAddKaryawan extends StatefulWidget {
  ListAddKaryawan();

  @override
  _ListAddKaryawanState createState() => _ListAddKaryawanState();
}

class _ListAddKaryawanState extends State<ListAddKaryawan> {
  String stat;
  ProgressDialog pr;

  final format = DateFormat("yyyy-MM-dd");

  TextEditingController tanggal = TextEditingController();

  Future<List> getData() async {
    final response = await http.get("https://android.stikesbanyuwangi.ac.id/p/add_karyawanx");
    return json.decode(response.body);
  }

  Future<List> getData1() async {
    final response = await http.post(Uri.parse("https://android.stikesbanyuwangi.ac.id/p/add_karyawanx"),body: {
      "tanggal": tanggal.text,
    });
    return json.decode(response.body);

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

  AddNow(nik,nama,pin)async{
    pr.show();

    final response = await http.post(Uri.parse("https://android.stikesbanyuwangi.ac.id/p/add_karyawan"),body: {
      "nik": nik,
      "nama": nama,
      "pin": pin,
    });

    Future.delayed(Duration(seconds: 3)).then((value) {
      pr.hide().whenComplete(() {

        if (response.statusCode == 200) {
          setState(() {
            stat="benar";
          });
          Notif('Tambah Karyawan Berhasil');
//      return jsonDecode(response.body);
        } else {
          setState(() {
            stat="salah";
          });
          setState(() {
            getData();
            getData1();
            yaa();
            yaa1();
            Xua();
          });
          Notif('Failed to load internet');

//          throw Exception('Failed to load internet');
        }

      });
    });
  }

  Widget yaa(){
    if(tanggal.text == null || tanggal.text == ''){
      return FutureBuilder<List>(
        future: getData(),
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
                    height: 145,
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
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: <Widget>[
                              Image.asset('Assets/img/Screenshot_1354.png',fit: BoxFit.fill,width: 70,),
                              Container(
                                width: 10,
                              ),
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
                                    height: 0,
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
//                            Text(snapshot.data[i]['date_time'],
//                              textAlign: TextAlign.left,
//                              style: TextStyle(
//                                  fontSize: 10
//                              ),
//                            ),
                            Container(
                              child:  MaterialButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: (){
                                  AddNow(
                                      snapshot.data[i]['nik'],
                                      snapshot.data[i]['nama'],
                                      snapshot.data[i]['nik']
                                  );
//                                  Notif(snapshot.data[i]['gambar_file']);
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
                                  child: Text('Add Karyawan',
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
      );
    }else{
      return FutureBuilder<List>(
        future: getData1(),
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
                    height: 145,
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
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: <Widget>[
                              Image.asset('Assets/img/Screenshot_1354.png',fit: BoxFit.fill,width: 70,),
                              Container(
                                width: 10,
                              ),
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
                                    height: 0,
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
//                            Text(snapshot.data[i]['date_time'],
//                              textAlign: TextAlign.left,
//                              style: TextStyle(
//                                  fontSize: 10
//                              ),
//                            ),
                            Container(
                              child:  MaterialButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: (){
                                  AddNow(
                                      snapshot.data[i]['nik'],
                                      snapshot.data[i]['nama'],
                                      snapshot.data[i]['nik']
                                  );
//                                  Notif(snapshot.data[i]['gambar_file']);
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
                                  child: Text('Add Karyawan',
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
      );
    }
  }

  Widget yaa1(){
    if(tanggal.text == null || tanggal.text == ''){
      return FutureBuilder<List>(
        future: getData(),
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
                    height: 145,
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
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: <Widget>[
                              Image.asset('Assets/img/Screenshot_1354.png',fit: BoxFit.fill,width: 70,),
                              Container(
                                width: 10,
                              ),
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
                                    height: 0,
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
//                            Text(snapshot.data[i]['date_time'],
//                              textAlign: TextAlign.left,
//                              style: TextStyle(
//                                  fontSize: 10
//                              ),
//                            ),
                            Container(
                              child:  MaterialButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: (){
                                  AddNow(
                                      snapshot.data[i]['nik'],
                                      snapshot.data[i]['nama'],
                                      snapshot.data[i]['nik']
                                  );
//                                  Notif(snapshot.data[i]['gambar_file']);
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
                                  child: Text('Add Karyawan',
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
      );
    }else{
      return FutureBuilder<List>(
        future: getData1(),
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
                    height: 145,
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
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: <Widget>[
                              Image.asset('Assets/img/Screenshot_1354.png',fit: BoxFit.fill,width: 70,),
                              Container(
                                width: 10,
                              ),
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
                                    height: 0,
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
//                            Text(snapshot.data[i]['date_time'],
//                              textAlign: TextAlign.left,
//                              style: TextStyle(
//                                  fontSize: 10
//                              ),
//                            ),
                            Container(
                              child:  MaterialButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: (){
                                  AddNow(
                                      snapshot.data[i]['nik'],
                                      snapshot.data[i]['nama'],
                                      snapshot.data[i]['nik']
                                  );
//                                  Notif(snapshot.data[i]['gambar_file']);
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
                                  child: Text('Add Karyawan',
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
      );
    }
  }

  Widget Xua(){
    if(stat == "benar"){
      return wid300();
    }else{
      return wid300();
    }
  }

  CekData(){
    setState(() {
      getData();
      getData1();
      yaa();
      yaa1();
    });
    pr.show();
    Future.delayed(Duration(seconds: 3)).then((value) {

      pr.hide().whenComplete(() {

      });
    });
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
//              borderRadius: new BorderRadius.only(
//                bottomRight: new Radius.circular(20.0),
//                bottomLeft: new Radius.circular(20.0),
//              ),
            ),
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text("Add Karyawan",
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
                      controller: tanggal,
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
                        CekData();
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
                    child: yaa(),
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
//              borderRadius: new BorderRadius.only(
//                bottomRight: new Radius.circular(20.0),
//                bottomLeft: new Radius.circular(20.0),
//              ),
            ),
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text("Add Karyawan",
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
                      controller: tanggal,
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
                        print('sds');
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
                    child: yaa1(),
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
//              borderRadius: new BorderRadius.only(
//                bottomRight: new Radius.circular(20.0),
//                bottomLeft: new Radius.circular(20.0),
//              ),
            ),
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text("Add Karyawan",
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
                      controller: tanggal,
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
                        print('sds');
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
                    child: yaa1(),
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
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    return Scaffold(
      body: Xua(),
    );
  }
}

//class ItemList extends StatelessWidget {
//  final List list;
//  ItemList({this.list});
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return new ;
//  }
//}