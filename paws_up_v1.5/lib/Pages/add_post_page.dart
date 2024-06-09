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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Crear Publicación',
          style: TextStyle(
            color: Colors.tealAccent,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, color: Colors.tealAccent),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isMissingPet = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isMissingPet ? Colors.blue : Colors.transparent,
                      foregroundColor:
                          isMissingPet ? Colors.white : Colors.black,
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Mascota Perdida',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isMissingPet = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isMissingPet ? Colors.transparent : Colors.blue,
                      foregroundColor:
                          isMissingPet ? Colors.black : Colors.white,
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Publicación Normal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                maxLines: null,
              ),
              if (!isMissingPet) ...[
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black),
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
                  decoration: const InputDecoration(
                    labelText: 'Raza del Animal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black),
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
                    border: Border.all(color: Colors.black),
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
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
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
    );
  }
}
