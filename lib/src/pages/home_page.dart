import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qrscanner_flutter/src/bloc/scans_bloc.dart';
import 'package:qrscanner_flutter/src/models/scan_model.dart';

import 'package:qrscanner_flutter/src/pages/direcciones_page.dart';
import 'package:qrscanner_flutter/src/pages/mapas_page.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrscanner_flutter/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever), 
            onPressed: scansBloc.borrarScansTODOS
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> _scanQR(context),
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async{
    // https://www.google.es/
    // geo:41.38005795448842,2.1579716984524833
 
    dynamic futureString = 'https://www.google.es/';

    //try {
    //  futureString = await BarcodeScanner.scan();
    //} catch (e) {
    //  futureString = e.toString();
    //}
    //print('Future String: ${futureString.rawContent}');
//
    if (futureString != null) {

      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);  

      final scan2 = ScanModel(valor: 'geo:41.38005795448842,2.1579716984524833');
      scansBloc.agregarScan(scan2);


      if(Platform.isIOS) {

        Future.delayed(Duration(milliseconds: 750), (){
          utils.abrirScan(context, scan);
        });
      } else {
        utils.abrirScan(context, scan);
      }
    }

  }

  Widget _callPage(int paginaActual) {

    switch (paginaActual) {
      case 0: return MapasPage();
      case 1: return DireccionesPage();
      default: return MapasPage();
    }  

  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones'),
        ),
      ]
    );
  }
}
