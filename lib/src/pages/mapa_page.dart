import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrscanner_flutter/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  final map = new MapController();
  String tipoMapa = 'streets-v11';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            }
          ),
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonMapas(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
        maxZoom: 18,
        minZoom: 2,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/'
            '{id}/tiles/{z}/{x}/{y}/?access_token={accessToken}',
      additionalOptions: {
        'accessToken':'pk.eyJ1Ijoia2RldjkzIiwiYSI6ImNrYXlmdjF2bTBmcTgyd28yd3MyZGQ5emUifQ.ouwrFMfuX7BDJpJET1KFlg',
        'id': tipoMapa,
        /*streets-v11
        outdoors-v11
        light-v10
        dark-v10
        satellite-v9
        satellite-streets-v11
         */
      }
    );
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on, 
              size: 40.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
      ]
    );
  }

  Widget _crearBotonMapas(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if (tipoMapa == 'streets-v11') {
          tipoMapa = 'dark-v10';
        } else if(tipoMapa == 'dark-v10') {
          tipoMapa = 'satellite-streets-v11';
        } else {
          tipoMapa = 'streets-v11';
        }
        setState(() {});
        /*
        outdoors-v11
        light-v10
        dark-v10
        satellite-v9
        satellite-streets-v11
         */
      },
    );
  }
}