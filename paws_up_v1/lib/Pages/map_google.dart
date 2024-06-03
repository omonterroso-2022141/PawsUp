import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapGoogle extends StatelessWidget {
  const MapGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PawsMap'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(14.64072, -90.51327),
              zoom: 11.0,
            ),
            onMapCreated: (GoogleMapController controller) {},
          ),
        ],
      ),
    );
  }
}
