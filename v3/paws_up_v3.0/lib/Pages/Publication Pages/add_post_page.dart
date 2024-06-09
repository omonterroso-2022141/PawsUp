import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  bool isMissingPet = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String? selectedSex;
  bool _mapLoading = true;
  List<XFile>? _mediaFiles;

  final String googleApiKey = 'AIzaSyBs2lOkc7xTfnd5Yf7c5UNm3i4ztaQgSPo';

  @override
  void initState() {
    super.initState();
    mapController = null;
    selectedLocation = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _mapLoading = false;
    });
  }

  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = await picker.pickImage(source: ImageSource.gallery);
    if (media != null) {
      setState(() {
        _mediaFiles = [media];
      });
    }
  }

  Future<List<Prediction>> _fetchPlacePredictions(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        return (json['predictions'] as List)
            .map((p) => Prediction.fromJson(p))
            .toList();
      } else {
        throw Exception('Failed to fetch place predictions');
      }
    } else {
      throw Exception('Failed to fetch place predictions');
    }
  }

  Future<LatLng> _getLatLngFromPlaceId(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        final location = json['result']['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      } else {
        throw Exception('Failed to fetch place details');
      }
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  Future<void> _searchLocation() async {
    final Prediction? p = await showSearch<Prediction?>(
      context: context,
      delegate: PlacesAutocompleteDelegate(_fetchPlacePredictions),
    );

    if (p != null) {
      final LatLng latLng = await _getLatLngFromPlaceId(p.placeId!);

      setState(() {
        selectedLocation = latLng;
        locationController.text = p.description!;
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(selectedLocation!, 15.0),
      );
    }
  }

  void _submitPost() async{
    String name = nameController.text;
    String age = ageController.text;
    String description = descriptionController.text;
    String location = locationController.text;
    String sex = selectedSex ?? '';

    // Construye el cuerpo de la solicitud
    Map<String, dynamic> postData = {
      'descripcion': description,
      // Agrega cualquier otro campo necesario
    };

    // Realiza la solicitud HTTP al backend
    final response = await http.post(
      'https://back-paws-up-cloud.vercel.app/Publicacion/addPublicacion' as Uri,
      body: postData,
    );

    // Verifica si la solicitud fue exitosa
    if (response.statusCode == 200) {
      // Maneja la respuesta del backend
      print('Publicación agregada correctamente');
    } else {
      // Maneja el caso en que la solicitud no sea exitosa
      print('Error al agregar la publicación: ${response.statusCode}');
    }
      // Implement the logic to handle the form submission
      // You can send this data to your backend or further process it as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        backgroundColor: isMissingPet
                            ? const Color(0xFF5BFFD3)
                            : Colors.grey,
                        foregroundColor:
                            isMissingPet ? Colors.black : Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Mascota Perdida',
                        style: TextStyle(
                          fontSize: 14,
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        backgroundColor: isMissingPet
                            ? Colors.grey
                            : const Color(0xFF5BFFD3),
                        foregroundColor:
                            isMissingPet ? Colors.white : Colors.black,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Publicación Normal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                if (isMissingPet) ...[
                  _buildTextField(nameController, 'Nombre'),
                  const SizedBox(height: 16.0),
                  _buildTextField(ageController, 'Edad'),
                  const SizedBox(height: 16.0),
                  _buildTextField(descriptionController, 'Descripción',
                      maxLines: 3),
                  const SizedBox(height: 16.0),
                  _buildDropdownButtonFormField(
                    'Sexo',
                    selectedSex,
                    ['HEMBRA', 'MACHO', 'TERRENEITOR'],
                    (String? newValue) {
                      setState(() {
                        selectedSex = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _pickMedia,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFF5BFFD3),
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Adjuntar Foto'),
                  ),
                  const SizedBox(height: 16.0),
                  _mediaFiles != null && _mediaFiles!.isNotEmpty
                      ? Image.file(File(_mediaFiles!.first.path))
                      : Container(),
                  const SizedBox(height: 16.0),
                  _buildTextField(locationController, 'Ubicación',
                      readOnly: true, onTap: _searchLocation),
                  const SizedBox(height: 16.0),
                  Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF5BFFD3)),
                    ),
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(0.0, 0.0),
                        zoom: 15,
                      ),
                      onMapCreated: _onMapCreated,
                      markers: selectedLocation != null
                          ? {
                              Marker(
                                markerId: const MarkerId('selected_location'),
                                position: selectedLocation!,
                              ),
                            }
                          : {},
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitPost,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFF5BFFD3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Publicar'),
                  ),
                ] else ...[
                  _buildTextField(nameController, 'Título'),
                  const SizedBox(height: 16.0),
                  _buildTextField(descriptionController, 'Descripción',
                      maxLines: 3),
                  const SizedBox(height: 16.0),
                  _buildDropdownButtonFormField(
                    'Categoría',
                    selectedSex,
                    ['Adoptar o Adopción', 'Vida Cotidiana'],
                    (String? newValue) {
                      setState(() {
                        selectedSex = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _pickMedia,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFF5BFFD3),
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Adjuntar Imágenes o Videos'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitPost,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFF5BFFD3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Publicar'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, bool readOnly = false, VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF5BFFD3)),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF5BFFD3)),
        ),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildDropdownButtonFormField(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF5BFFD3)),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF5BFFD3)),
        ),
      ),
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class PlacesAutocompleteDelegate extends SearchDelegate<Prediction?> {
  final Future<List<Prediction>> Function(String) fetchPlacePredictions;

  PlacesAutocompleteDelegate(this.fetchPlacePredictions);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder<List<Prediction>>(
      future: fetchPlacePredictions(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final prediction = results[index];
            return ListTile(
              title: Text(prediction.description ?? ''),
              onTap: () => close(context, prediction),
            );
          },
        );
      },
    );
  }
}

class Prediction {
  final String? description;
  final String? placeId;

  Prediction({this.description, this.placeId});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}
