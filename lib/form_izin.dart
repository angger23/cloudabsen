import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloudabsen/login.dart';
import 'package:flutter/services.dart' ;


class FormIzin extends StatefulWidget {
  FormIzin({this.nik,this.nama_karyawan,this.status});
  final String nik;
  final String nama_karyawan;
  final String status;


  @override
  _FormIzinState createState() => _FormIzinState();
}

class _FormIzinState extends State<FormIzin> {
  ProgressDialog pr;

  Logout2(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  Logout()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("nik");
    Logout2();
  }


  final format = DateFormat("yyyy-MM-dd");

  String cuti;

  TextEditingController tanggalIzin = TextEditingController();
  TextEditingController tanggalIzinx = TextEditingController();

  String JenisIzin;

  File imageURI;
  static final String uploadEndPoint =
      'https://android.stikesbanyuwangi.ac.id/p/ijinx2/';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Data Gagal Masuk';


  getImageFromCamera() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 20);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  Future<void> Notif(alertx) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
//          title: Text('Alert'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(alertx.toString(),style: TextStyle(
                  fontSize: 17
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

  CekCuti(nilai)async{
    final response = await http.post("https://android.stikesbanyuwangi.ac.id/p/cek_cuti", body: {
      "nik": widget.nik,
    });
    var datauser = jsonDecode(response.body);
    setState(() {
      cuti= datauser['cuti'].toString();
    });
    if(datauser['cuti'] == '0'){
      Notif2();
    }else{
      setState(() {
        JenisIzin = nilai;
      });
    }
  }


  Future<void> Notif2() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Batas Cuti Sudah 12 Kali !'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Anda sudah menggunakan hak cuti mencapai batas maksimal.',style: TextStyle(
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


  startUpload() {
//    print(tanggalIzin.text);
//    print(tanggalIzin2.text);
    setStatus('Uploading Image...');
    if(tanggalIzin.text == null || tanggalIzin.text == ''){
      Notif('Belum Mengisi Tanggal !');
    }else if (tanggalIzinx.text == null || tanggalIzinx.text == '') {
      Notif('Belum Mengisi Tanggal !');
    }else if (JenisIzin == null || JenisIzin == '') {
      Notif('Belum Memilih Jenis');
    }else if (null == tmpFile) {
      Notif('Gambar Kosong !');
//      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;

    upload(fileName);

  }


  upload(String fileName) async{
    var hasil;
    pr.show();
    final response = await http.post(uploadEndPoint, body: {
      "tanggal": tanggalIzin.text,
      "tanggal2": tanggalIzinx.text,
      "status_izin": JenisIzin,
      "image": base64Image,
      "name": fileName,
      "nik": widget.nik,
    });
//    var datauser = jsonDecode(response.body);

    if(response.statusCode == 200){
      hasil = response.body;
    }else{
      hasil = errMessage;
    }

    Future.delayed(Duration(seconds: 3)).then((value) {
      pr.hide().whenComplete(() {
        Notif(hasil.toString());
      });
    });

  }



  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
//          print(base64Image);
          return Container(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Container();
        }
      },
    );
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
                      Text('Halaman ini digunakan untuk izin pribadi seperti',style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Cuti, Sakit, Dinas Luar dan Bimbingan',style: TextStyle(
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
//              height: 70,
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
                  Text(
                    'Pilih Tanggal Izin',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto-Light',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width:140,
                        child: DateTimeField(
                          controller: tanggalIzin,
                          decoration: new InputDecoration(
                            labelText: "Tanggal Awal",
                            hintStyle: TextStyle(
                                fontSize: 10
                            ),
                            labelStyle: TextStyle(
                              fontSize: 13
                            ),
                            fillColor: Colors.white,
//                            border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(5),
//                            ),
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
                      Icon(
                        Icons.remove,
                        size: 20,
                      ),
                      Container(
                        width:140,
                        child: DateTimeField(
                          controller: tanggalIzinx,
                          decoration: new InputDecoration(
                            labelText: "Tanggal Akhir",
                            hintStyle: TextStyle(
                              fontSize: 10
                            ),
                            labelStyle: TextStyle(
                                fontSize: 13
                            ),
                            fillColor: Colors.white,
//                            border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(10),
//                            ),
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
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  OutlineDropdownButton(
                    hint: Text("Pilih Jenis Izin"),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        child: Text("Izin Pribadi"),
                        value: "Izin Pribadi",
                      ),
                      DropdownMenuItem(
                        child: Text("Dinas Luar"),
                        value: "Dinas Luar",
                      ),
                      DropdownMenuItem(
                        child: Text("Bimbingan"),
                        value: "Bimbingan",
                      ),
                      DropdownMenuItem(
                        child: Text("Cuti"),
                        value: "Cuti",
                      ),
                      DropdownMenuItem(
                        child: Text("Surat Dokter"),
                        value: "Surat Dokter",
                      )
                    ],
                    value: JenisIzin,
                    onChanged: (nilai){
                      if(nilai == "Izin Pribadi") {
                        CekCuti(nilai);
//                        Notif2();
                      }else if(nilai == "Cuti"){
                        CekCuti(nilai);
                      }else{
                        setState(() {
                          JenisIzin = nilai;
                        });
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: new Container(
                          height:100,
                          width:250,
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
                              getImageFromCamera();
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => KelolaBarang()
//                                  )
//                              );
                            },
                            child: new Center(
                              child: Padding(
                                padding : EdgeInsets.all(8.0),
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
                                              color: Colors.blue,
                                            ),
                                            child: Padding(
                                              padding : EdgeInsets.all(16.0),
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 20.0,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding : EdgeInsets.fromLTRB(0, 8, 0, 4),
                                              child: Text('CAMERA',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
//                                                  fontFamily: 'Roboto-Bold',
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
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
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),

                  showImage(),

//                  Text(
//                    status,
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      color: Colors.green,
//                      fontWeight: FontWeight.w500,
//                      fontSize: 20.0,
//                    ),
//                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){
                      startUpload();
//                      upload(imageURI);
                    },
                    child: new Text("UPLOAD"),
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
              title: Text("Form Izin",
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
                      Text('Halaman ini digunakan untuk izin pribadi seperti',style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Cuti, Sakit, Dinas Luar dan Bimbingan',style: TextStyle(
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
//              height: 70,
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
                  Text(
                    'Pilih Tanggal Izin',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Roboto-Light',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width:140,
                        child: DateTimeField(
                          controller: tanggalIzin,
                          decoration: new InputDecoration(
                            labelText: "Tanggal Awal",
                            hintStyle: TextStyle(
                                fontSize: 10
                            ),
                            labelStyle: TextStyle(
                                fontSize: 13
                            ),
                            fillColor: Colors.white,
//                            border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(5),
//                            ),
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
                      Icon(
                        Icons.remove,
                        size: 20,
                      ),
                      Container(
                        width:140,
                        child: DateTimeField(
                          controller: tanggalIzinx,
                          decoration: new InputDecoration(
                            labelText: "Tanggal Akhir",
                            hintStyle: TextStyle(
                                fontSize: 10
                            ),
                            labelStyle: TextStyle(
                                fontSize: 13
                            ),
                            fillColor: Colors.white,
//                            border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(10),
//                            ),
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
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  OutlineDropdownButton(
                    hint: Text("Pilih Jenis Izin"),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        child: Text("Izin Pribadi"),
                        value: "Izin Pribadi",
                      ),
                      DropdownMenuItem(
                        child: Text("Dinas Luar"),
                        value: "Dinas Luar",
                      ),
                      DropdownMenuItem(
                        child: Text("Bimbingan"),
                        value: "Bimbingan",
                      ),
                      DropdownMenuItem(
                        child: Text("Cuti"),
                        value: "Cuti",
                      ),
                      DropdownMenuItem(
                        child: Text("Surat Dokter"),
                        value: "Surat Dokter",
                      )
                    ],
                    value: JenisIzin,
                    onChanged: (nilai){
                      if(nilai == "Izin Pribadi") {
                        CekCuti(nilai);
//                        Notif2();
                      }else if(nilai == "Cuti"){
                        CekCuti(nilai);
                      }else{
                        setState(() {
                          JenisIzin = nilai;
                        });
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: new Container(
                          height:140,
                          width:330,
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
                              getImageFromCamera();
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => KelolaBarang()
//                                  )
//                              );
                            },
                            child: new Center(
                              child: Padding(
                                padding : EdgeInsets.all(8.0),
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
                                              color: Colors.blue,
                                            ),
                                            child: Padding(
                                              padding : EdgeInsets.all(16.0),
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 30.0,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding : EdgeInsets.fromLTRB(0, 8, 0, 4),
                                              child: Text('CAMERA',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20.0,
//                                                  fontFamily: 'Roboto-Regular',
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
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
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),

                  showImage(),

//                  Text(
//                    status,
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      color: Colors.green,
//                      fontWeight: FontWeight.w500,
//                      fontSize: 20.0,
//                    ),
//                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){
                      startUpload();
//                      upload(imageURI);
                    },
                    child: new Text("UPLOAD"),
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
              title: Text("Form Izin",
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
                      Text('Halaman ini digunakan untuk izin pribadi seperti',style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Cuti, Sakit, Dinas Luar dan Bimbingan',style: TextStyle(
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
//              height: 70,
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
                  Text(
                    'Pilih Tanggal Izin',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto-Light',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width:140,
                        child: DateTimeField(
                          controller: tanggalIzin,
                          decoration: new InputDecoration(
                            labelText: "Tanggal Awal",
                            hintStyle: TextStyle(
                                fontSize: 10
                            ),
                            labelStyle: TextStyle(
                                fontSize: 13
                            ),
                            fillColor: Colors.white,
//                            border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(5),
//                            ),
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
                      Icon(
                        Icons.remove,
                        size: 20,
                      ),
                      Container(
                        width:140,
                        child: DateTimeField(
                          controller: tanggalIzinx,
                          decoration: new InputDecoration(
                            labelText: "Tanggal Akhir",
                            hintStyle: TextStyle(
                                fontSize: 10
                            ),
                            labelStyle: TextStyle(
                                fontSize: 13
                            ),
                            fillColor: Colors.white,
//                            border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(10),
//                            ),
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
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  OutlineDropdownButton(
                    hint: Text("Pilih Jenis Izin"),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        child: Text("Izin Pribadi"),
                        value: "Izin Pribadi",
                      ),
                      DropdownMenuItem(
                        child: Text("Dinas Luar"),
                        value: "Dinas Luar",
                      ),
                      DropdownMenuItem(
                        child: Text("Bimbingan"),
                        value: "Bimbingan",
                      ),
                      DropdownMenuItem(
                        child: Text("Cuti"),
                        value: "Cuti",
                      ),
                      DropdownMenuItem(
                        child: Text("Surat Dokter"),
                        value: "Surat Dokter",
                      )
                    ],
                    value: JenisIzin,
                    onChanged: (nilai){
                      if(nilai == "Izin Pribadi") {
                        CekCuti(nilai);
//                        Notif2();
                      }else if(nilai == "Cuti"){
                        CekCuti(nilai);
                      }else{
                        setState(() {
                          JenisIzin = nilai;
                        });
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: new Container(
                          height:100,
                          width:250,
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
                              getImageFromCamera();
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => KelolaBarang()
//                                  )
//                              );
                            },
                            child: new Center(
                              child: Padding(
                                padding : EdgeInsets.all(8.0),
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
                                              color: Colors.blue,
                                            ),
                                            child: Padding(
                                              padding : EdgeInsets.all(16.0),
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 20.0,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding : EdgeInsets.fromLTRB(0, 8, 0, 4),
                                              child: Text('CAMERA',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
//                                                  fontFamily: 'Roboto-Bold',
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
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
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),

                  showImage(),

//                  Text(
//                    status,
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      color: Colors.green,
//                      fontWeight: FontWeight.w500,
//                      fontSize: 20.0,
//                    ),
//                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){
                      startUpload();
//                      upload(imageURI);
                    },
                    child: new Text("UPLOAD"),
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
              title: Text("Form Izin",
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
}