import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const kGoogleApiKey = "AIzaSyBs2lOkc7xTfnd5Yf7c5UNm3i4ztaQgSPo";

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  _MapGoogleState createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle>
    with SingleTickerProviderStateMixin {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition =
      const LatLng(14.625718299308714, -90.53585792927943);
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isSatellite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _addMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'Mascota Perdida',
            snippet: 'Toca para más información',
            onTap: () {
              _showPetDetails();
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
    _animationController.forward();
  }

  void _showPetDetails() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Detalles de la Mascota Perdida',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('Laky, se perdió hace 5 horas es una perrita de...'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.info),
                      label: const Text('Más Información'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check),
                      label: const Text('Encontrado'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSearch() async {
    var place = await showSearch(
      context: context,
      delegate: AddressSearch(_mapController),
    );
    if (place != null) {
      List<Location> locations = await locationFromAddress(place);
      if (locations.isNotEmpty) {
        final latLng = LatLng(locations[0].latitude, locations[0].longitude);
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: latLng,
              zoom: 15,
            ),
          ),
        );

        setState(() {
          _lastMapPosition = latLng;
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId(_lastMapPosition.toString()),
              position: _lastMapPosition,
              infoWindow: InfoWindow(
                title: place,
                snippet: '',
              ),
            ),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(14.64072, -90.51327),
              zoom: 11.0,
            ),
            mapType: _isSatellite ? MapType.satellite : MapType.normal,
            markers: _markers,
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove,
            onLongPress: (LatLng position) {
              setState(() {
                _lastMapPosition = position;
              });
              _addMarker();
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 8.0,
              borderRadius: BorderRadius.circular(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onTap: _handleSearch,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Buscar dirección...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(_isSatellite ? Icons.map : Icons.satellite),
                      onPressed: () {
                        setState(() {
                          _isSatellite = !_isSatellite;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMarker,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_location),
      ),
    );
  }
}

class AddressSearch extends SearchDelegate<String> {
  final GoogleMapController mapController;

  AddressSearch(this.mapController);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      title: Text(query),
      onTap: () async {
        List<Location> locations = await locationFromAddress(query);
        if (locations.isNotEmpty) {
          final latLng = LatLng(locations[0].latitude, locations[0].longitude);
          close(context, query);
          // Focus map on the selected location
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: latLng,
                zoom: 15,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: _fetchSuggestions(query),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(snapshot.data![index]),
              onTap: () async {
                List<Location> locations =
                    await locationFromAddress(snapshot.data![index]);
                if (locations.isNotEmpty) {
                  final latLng =
                      LatLng(locations[0].latitude, locations[0].longitude);
                  close(context, snapshot.data![index]);
                  // Focus map on the selected location
                  mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: latLng,
                        zoom: 15,
                      ),
                    ),
                  );
                }
              },
            );
          },
          itemCount: snapshot.data!.length,
        );
      },
    );
  }

  Future<List<String>> _fetchSuggestions(String input) async {
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$kGoogleApiKey&components=country:gt'),
    );

    if (response.statusCode == 200) {
      final List predictions = json.decode(response.body)['predictions'];
      return predictions.map<String>((p) => p['description']).toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }
}
