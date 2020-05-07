import 'package:flutter/material.dart';
import 'package:cloudabsen/homepage.dart';
import 'package:cloudabsen/rekap_absensi.dart';
import 'package:cloudabsen/form_izin.dart';
import 'package:flutter/services.dart' ;

class KaryawanPage extends StatefulWidget {
  KaryawanPage({this.nik,this.nama_karyawan,this.status,this.indexi});
  final String nik;
  final String nama_karyawan;
  final String status;
  final int indexi;

  @override
  _KaryawanPageState createState() => _KaryawanPageState();
}

class _KaryawanPageState extends State<KaryawanPage> {


  Widget getPage(int index) {
    if (index == 0) {
      return HomePage(
          nik:widget.nik,
          nama_karyawan:widget.nama_karyawan,
          status:widget.status,
      );
    }
    if (index == 1) {
      return RekapAbsensi(
        nik:widget.nik,
        nama_karyawan:widget.nama_karyawan,
        status:widget.status,
//        tanggal: '',
      );
    }

    if (index == 2) {
      return FormIzin(
        nik:widget.nik,
        nama_karyawan:widget.nama_karyawan,
        status:widget.status,
      );
    }
    // A fallback, in this case just PageOne
    return HomePage(
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
      body: getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text("Profil"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            title: Text("Rekap"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            title: Text("File Izin"),
          ),

        ],
        onTap: onTabTapped,
        currentIndex: _currentIndex,
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}