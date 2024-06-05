import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  _MapGoogleState createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle>
    with SingleTickerProviderStateMixin {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = const LatLng(14.64072, -90.51327);
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  BitmapDescriptor? customIcon; // Variable para almacenar tu icono personalizado

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
    setCustomMarker(); // Carga tu imagen personalizada
  }

  void setCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'images/logo.png', // Ruta a tu imagen personalizada
    );
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
          icon: customIcon!, // Usa tu imagen personalizada como icono
        ),
      );
    });
    _animationController.forward();
  }
  void _showPetDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      builder: (context) {
        return SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.black, // Cambia el color de la tarjeta a negro
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buscamos a Oreo',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5BFFD3)), // Cambia el color del texto a rojo
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'GFXV+G72, Guatemala City, Gua...',
                              style: TextStyle(fontSize: 14, color: Colors.white), // Cambia el color del texto a blanco
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              'Perdido hace 5 meses',
                              style: TextStyle(fontSize: 12, color: Color(0xFF5BFFD3)), // Cambia el color del texto a blanco
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Descripción:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF5BFFD3)), // Cambia el color del texto a blanco
                  ),
                  const SizedBox(height: 4.0), // Reducir el espacio después del título
                  GestureDetector(
                    onTap: () {
                      // Navegar a la página con información detallada
                      // Aquí puedes agregar la lógica de navegación
                    },
                    child: Text(
                      'Oreo es un perro de raza Labrador Retriever de color negro. Tiene un collar rojo y es muy amigable con las personas. Se perdió en el área de la Ciudad de Guatemala.',
                      style: TextStyle(fontSize: 14, color: Colors.white), // Cambia el color del texto a blanco
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Image.asset(
                              'images/chat.png', // Ruta a tu imagen
                              width: 50, // Ancho de la imagen
                              height: 50, // Altura de la imagen
                            ),
                            onPressed: () {
                              // Tu código aquí
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: FloatingActionButton(
                onPressed: _addMarker,
                tooltip: 'Agregar marcador',
                backgroundColor: Colors.black,
                child: Image.asset(
                  'images/logo.png', // Ruta a tu imagen
                  width: 70, // Ancho de la imagen
                  height: 70, // Altura de la imagen
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
