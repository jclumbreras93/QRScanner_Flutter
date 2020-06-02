import 'dart:async';

import 'package:qrscanner_flutter/src/providers/db_provider.dart';

class ScansBloc {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    //Obtener Scans de la Base de datos
    obtenerScans();
  }
  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream;


  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.sink.add( await DBPRovider.db.getTodosScans() );
  }

  agregarScan(ScanModel scan) async {
    await DBPRovider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBPRovider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScansTODOS() async {
    await DBPRovider.db.deleteAll();
    obtenerScans();
  }

}