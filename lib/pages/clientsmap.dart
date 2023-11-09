import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uisample/model/client.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientsMap extends StatefulWidget {
  const ClientsMap({super.key});

  @override
  State<ClientsMap> createState() => _ClientsMapState();
}

class _ClientsMapState extends State<ClientsMap> {
  GoogleMapController? mapController;
  Set<Marker> markers = Set<Marker>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() async {
    await Hive.openBox<ClientDb>('client');
    final markerbox = Hive.box<ClientDb>('client');
    for (int i = 0; i < markerbox.length; i++) {
      ClientDb? marker = markerbox.getAt(i);
      print(markers);
      print("marker : ");
      print("place :${marker!.place} ");
      if (marker != null) {
        addMarker(
          LatLng(marker.latittude ?? 0.0, marker.longittude ?? 0.0),
          marker.place,
        );
      }
    }
    if (markers.isNotEmpty && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(markers.first.position),
      );
    }
  }

  void addMarker(LatLng latLng, String place) {
    setState(() {
      final Marker marker = Marker(
        markerId: MarkerId(place),
        position: latLng,
        infoWindow: InfoWindow(title: place),
      );
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clients Locations"),
        centerTitle: true,
        elevation: 0,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          // zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: markers,
      ),
    );
  }
}
