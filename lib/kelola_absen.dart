import 'package:flutter/material.dart';
import 'package:cloudabsen/kelola_absen_masuk.dart';
import 'package:cloudabsen/kelola_absen_pulang.dart';
import 'package:cloudabsen/kelola_alpa.dart';
import 'package:cloudabsen/kelola_izin.dart';
import 'package:flutter/services.dart' ;

class KelolaAbsen extends StatefulWidget {
  KelolaAbsen({this.nik,this.nama_karyawan,this.status});
  final String nik;
  final String nama_karyawan;
  final String status;

  @override
  _KelolaAbsenState createState() => _KelolaAbsenState();
}

class _KelolaAbsenState extends State<KelolaAbsen> {


  Widget getPage(int index) {
    if (index == 0) {
      return KelolaMasuk(
        nik:widget.nik,
        nama_karyawan:widget.nama_karyawan,
        status:widget.status,
      );
    }
    if (index == 1) {
      return KelolaPulang(
        nik:widget.nik,
        nama_karyawan:widget.nama_karyawan,
        status:widget.status,
      );
    }

    if (index == 2) {
      return KelolaIzin(
        nik:widget.nik,
        nama_karyawan:widget.nama_karyawan,
        status:widget.status,
      );
    }

    if (index == 3) {
      return KelolaAlpha(
        nik:widget.nik,
        nama_karyawan:widget.nama_karyawan,
        status:widget.status,
      );
    }
    // A fallback, in this case just PageOne
    return KelolaMasuk(
      nik:widget.nik,
      nama_karyawan:widget.nama_karyawan,
      status:widget.status,
    );
  }

  int _currentIndex = 0;

  onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.blue,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Hari Ini",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Roboto-Regular',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fingerprint),
            title: Text("Masuk"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_missed_outgoing),
            title: Text("Pulang"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            title: Text("Absen"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            title: Text("Belum Scan"),
          ),

        ],
        onTap: onTabTapped,
        currentIndex: _currentIndex,
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}