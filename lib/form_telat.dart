import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloudabsen/login.dart';
import 'package:flutter/services.dart' ;

class FormTelat extends StatefulWidget {
  FormTelat({this.nik,this.nama_karyawan,this.status,this.tanggal});
  final String nik;
  final String nama_karyawan;
  final String status;
  final String tanggal;


  @override
  _FormTelatState createState() => _FormTelatState();
}

class _FormTelatState extends State<FormTelat> {
  TextEditingController alasanIzin = TextEditingController();
  ProgressDialog pr;

  File imageURI;
  static final String uploadEndPoint =
      'https://android.stikesbanyuwangi.ac.id/p/form_telatx';
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


  Logout2(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  Logout()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("nik");
    Logout2();
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

  startUpload() {
//    print(tanggalIzin.text);
//    print(tanggalIzin2.text);
    setStatus('Uploading Image...');
    if(alasanIzin.text == null || alasanIzin.text == ''){
      Notif('Alasan belum terisi!');
    }else if (null == tmpFile) {
      Notif('Gambar Kosong !');
//      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;

    upload(fileName);

  }

  upload(String fileName) async{
    if(stat_telat == 'no'){
      pr.show();
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {
          notifyxx();
        });
      });
    }else{
      var hasil;
      pr.show();
      final response = await http.post(Uri.parse(uploadEndPoint),body: {
        "nik":widget.nik,
        "alasan": alasanIzin.text,
        "tanggal":widget.tanggal,
        "image": base64Image,
        "name": fileName,
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

  Future<void> notify() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data Berhasil Masuk !'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
//                Text('Yaa',style: TextStyle(
//                fontSize: 12
//                ),),
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

  Future<void> notifyx() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data Gagal Masuk !'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
//                Text('Yaa',style: TextStyle(
//                fontSize: 12
//                ),),
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

  Future<void> notifyxx() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Anda sudah memasukkan alasan !'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
//                Text('Yaa',style: TextStyle(
//                fontSize: 12
//                ),),
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

  String stat_telat;

  @override
  void initState() {
    super.initState();
    CekTelat();
  }

  CekTelat()async{
    final response = await http.post("https://android.stikesbanyuwangi.ac.id/p/cek_telat", body: {
      "nik": widget.nik,
      "tanggal":widget.tanggal,
    });
    var datauser = jsonDecode(response.body);
    setState(() {
      stat_telat= datauser['stat'].toString();
    });
//  print(stat_telat);
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
                      Text('Halaman ini digunakan untuk mengisi form keterlambatan',style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Jika anda terlambat absen',style: TextStyle(
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
//              height: 400,
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
                    'Alasan Keterlambatan',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto-Light',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: alasanIzin,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: new InputDecoration(
//                     Text: "Alasan keterlambatan",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text(
                    'Foto Bukti Alasan',
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: new Container(
                          height:140,
                          width:290,
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
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){
//                      formTelat();
                      startUpload();
//                      upload(imageURI);
                    },
                    child: new Text("MASUKKAN ALASAN"),
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
              title: Text("Form Keterlambatan",
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
                      Text('Halaman ini digunakan untuk mengisi form keterlambatan',style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Jika anda terlambat absen',style: TextStyle(
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
//              height: 400,
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
                    'Alasan Keterlambatan',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto-Light',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: alasanIzin,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: new InputDecoration(
//                     Text: "Alasan keterlambatan",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text(
                    'Foto Bukti Alasan',
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: new Container(
                          height:140,
                          width:400,
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
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){
//                      formTelat();
                      startUpload();
//                      upload(imageURI);
                    },
                    child: new Text("MASUKKAN ALASAN"),
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
              title: Text("Form Keterlambatan",
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
                      Text('Halaman ini digunakan untuk mengisi form keterlambatan',style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontWeight: FontWeight.w700
                      ),),
                      Text('Jika anda terlambat absen',style: TextStyle(
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
//              height: 400,
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
                    'Alasan Keterlambatan',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto-Light',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: alasanIzin,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: new InputDecoration(
//                     Text: "Alasan keterlambatan",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text(
                    'Foto Bukti Alasan',
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: new Container(
                          height:140,
                          width:290,
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
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){
//                      formTelat();
                      startUpload();
//                      upload(imageURI);
                    },
                    child: new Text("MASUKKAN ALASAN"),
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
              title: Text("Form Keterlambatan",
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