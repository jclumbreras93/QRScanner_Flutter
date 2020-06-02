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
        'accessToken':'<TOKEN>',
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
        print('Hola');
        if (tipoMapa == 'streets-v11') {
          print(tipoMapa);
          tipoMapa = 'dark-v10';
        } else if(tipoMapa == 'dark-v10') {
          print(tipoMapa);
          tipoMapa = 'satellite-streets-v11';
        } else {
          print(tipoMapa);
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

/*
return TileLayerOptions(
        urlTemplate: 'https://api.tiles.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
        'accessToken':'pk.eyJ1Ijoiam9yZ2VncmVnb3J5IiwiYSI6ImNrODk5aXE5cjA0c2wzZ3BjcTA0NGs3YjcifQ.H9LcQyP_-G9sxhaT5YbVow',
        'id': 'mapbox.streets'
        }
);

*/