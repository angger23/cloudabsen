import 'package:flutter/material.dart';
import 'package:cloudabsen/daftar_karyawan.dart';
import 'package:cloudabsen/list_add_karyawan.dart';
import 'package:flutter/services.dart' ;
class ListKaryawan extends StatefulWidget {
  ListKaryawan();

  @override
  _ListKaryawanState createState() => _ListKaryawanState();
}

class _ListKaryawanState extends State<ListKaryawan> {
  int i = 0;
  var pages = [
    new DaftarKaryawan(),
    new ListAddKaryawan(),
  ];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: pages[i],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text("Daftar Karyawan"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            title: Text("Add Karyawan"),
          ),
        ],
        currentIndex: i,
//        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            i = index;
          });
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}