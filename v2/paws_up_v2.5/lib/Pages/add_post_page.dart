import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  bool isMissingPet = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  String selectedCategory = 'Adoptar o Adopción';
  String selectedSex = '';
  bool _mapLoading = true;

  @override
  void initState() {
    super.initState();
    mapController = null;
    selectedLocation = null;
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _mapLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.black, // Fondo negro
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isMissingPet = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              backgroundColor:
                              isMissingPet ? Color(0xFF5BFFD3) : Colors.grey,
                              foregroundColor:
                              isMissingPet ? Colors.black : Colors.black,
                              side: BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Mascota Perdida',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isMissingPet = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              backgroundColor:
                              isMissingPet ? Colors.grey : Color(0xFF5BFFD3),
                              foregroundColor:
                              isMissingPet ? Colors.white : Colors.black,
                              side: BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Publicación Normal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: titleController,
                      style: TextStyle(color: Colors.white), // Texto blanco
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        labelStyle: TextStyle(color: Color(0xFF5BFFD3)), // Texto azul claro
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Color(0xFF5BFFD3)), // Borde azul claro
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: descriptionController,
                      style: TextStyle(color: Colors.white), // Texto blanco
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: TextStyle(color: Color(0xFF5BFFD3)), // Texto azul claro
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Color(0xFF5BFFD3)), // Borde azul claro
                        ),
                      ),
                      maxLines: null,
                    ),
                    if (!isMissingPet) ...[
                const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              style: TextStyle(color: Colors.white),
              // Texto blanco
              decoration: const InputDecoration(
                labelText: 'Categoría',
                labelStyle: TextStyle(color: Color(0xFF5BFFD3)),
                // Texto azul claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide:
                  BorderSide(color: Color(0xFF5BFFD3)), // Borde azul claro
                ),
              ),
              items: <String>[
                'Adoptar o Adopción',
                'Vida Cotidiana',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Color(0xFF5BFFD3),
                side: BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Adjuntar Imágenes o Videos'),
            ),
            ],
            if (isMissingPet) ...[
        const SizedBox(height: 16.0),
    TextFormField(
    controller: breedController,
    style: TextStyle(color: Colors.white), // Texto blanco
    decoration: const InputDecoration(
    labelText: 'Raza del Animal',
    labelStyle: TextStyle(color: Color(0xFF5BFFD3)),
    // Texto azul claro
    border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide:
    BorderSide(color: Color(0xFF5BFFD3)), // Borde azul claro
    ),
    ),
    ),
    const SizedBox(height: 16.0),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    ChoiceChip(
    avatar: const Icon(Icons.male, color: Colors.blue),
    label: const Text('Macho'),
    selected: selectedSex == 'Macho',
    onSelected: (bool selected) {
    setState(() {
    selectedSex = selected ? 'Macho' : '';
    });
    },
    ),
    ChoiceChip(
    avatar: const Icon(Icons.female, color: Colors.pink),
    label: const Text('Hembra'),
    selected: selectedSex == 'Hembra',
    onSelected: (bool selected) {
    setState(() {
    selectedSex = selected ? 'Hembra' : '';
    });
    },
    ),
    ],
    ),
    const SizedBox(height: 16.0),
    ElevatedButton(
    onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Color(0xFF5BFFD3),
        side: BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text('Adjuntar Foto'),
    ),
              const SizedBox(height: 16.0),
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFF5BFFD3)), // Borde azul claro
                ),
                child: _mapLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0.0, 0.0),
                    zoom: 15,
                  ),
                  onMapCreated: _onMapCreated,
                  onTap: (LatLng location) {
                    setState(() {
                      selectedLocation = location;
                    });
                  },
                  markers: selectedLocation != null
                      ? Set<Marker>.from([
                    Marker(
                      markerId:
                      const MarkerId('selected_location'),
                      position: selectedLocation!,
                    ),
                  ])
                      : Set<Marker>(),
                ),
              ),
            ],
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            String title = titleController.text;
                            String description = descriptionController.text;
                            String category = selectedCategory;
                            String breed = breedController.text;
                            String sex = selectedSex;
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, // Texto blanco
                            backgroundColor: Color(0xFF5BFFD3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Publicar'),
                        ),
                      ],
                    ),
                ),
            ),
        ),
    );
  }
}

