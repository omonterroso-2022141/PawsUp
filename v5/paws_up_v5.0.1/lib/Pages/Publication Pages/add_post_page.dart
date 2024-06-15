import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/categoria.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

final TextStyle heyTextStyle = TextStyle(
  fontFamily: "Hey",
  color: Colors.white, // Puedes ajustar el color aquí si es necesario
);

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
  String userToken = '';
  List<Category> categories = [];
  String? selectedCategoryId;
  String? selectedCategoryNombre;

  final String googleApiKey = 'AIzaSyBs2lOkc7xTfnd5Yf7c5UNm3i4ztaQgSPo';

  @override
  void initState() {
    super.initState();
    getUserToken();

    fetchCategories().then((data) {
      setState(() {
        categories = data;
      });
    }).catchError((error) {
      print('Error al obtener las categorías: $error');
    });

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
    final LatLng? selectedLocation = await showDialog<LatLng>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccione la ubicación'),
          content: Container(
            height: 300.0,
            width: 300.0,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    14.6622765, -90.4899868), // Cambia la posición inicial aquí
                zoom: 15,
              ),
              onTap: (LatLng latLng) {
                Navigator.of(context).pop(latLng);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (selectedLocation != null) {
      setState(() {
        this.selectedLocation = selectedLocation;
        locationController.text =
            '${selectedLocation.latitude}, ${selectedLocation.longitude}';
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(selectedLocation, 15.0),
      );
    }
  }

  Future<List<Category>> fetchCategories() async {
    print(
        'Token actual: $userToken'); // Verifica el token actual antes de la solicitud

    final response = await http.get(
      Uri.parse(
          'https://back-paws-up-cloud.vercel.app/Categoria/listCategoryUsuario'),
      headers: {'Authorization': userToken},
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      print(
          'Respuesta del servidor: $data'); // Verifica la respuesta del servidor

      final categoryData = data['categorys'];
      final category = Category.fromJson(categoryData);
      return [category];
    } else {
      print('Error en la solicitud: ${response.statusCode}');
      throw Exception('Error al obtener las categorías');
    }
  }

  Future<void> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('token') ?? '';
    });
  }

  void _submitPost({required bool someParameter}) async {
    if (userToken.isEmpty) {
      print('Token no disponible.');
      return;
    }

    if (someParameter) {
      if (_mediaFiles == null || _mediaFiles!.isEmpty) {
        print('No se ha seleccionado ninguna imagen o video.');
        return;
      }
    }

    try {
      var url = Uri.parse(
          'https://back-paws-up-cloud.vercel.app/Publicacion/addPublicacion');
      // Add headers

      var request = http.MultipartRequest('POST', url)
        ..fields['autor'] = userToken
        ..fields['descripcion'] = descriptionController.text
        ..fields['categoria'] = selectedCategoryId ?? '';

      // Agregar los archivos multimedia al cuerpo de la solicitud
      if (_mediaFiles != null && _mediaFiles!.isNotEmpty) {
        for (var file in _mediaFiles!) {
          String mimeType =
              lookupMimeType(file.path) ?? 'application/octet-stream';
          request.files.add(await http.MultipartFile.fromPath(
            'imagenes', // Nombre del campo esperado en el backend para las imágenes
            file.path,
            contentType: MediaType.parse(mimeType),
          ));
        }
      }
      request.headers['Authorization'] = userToken;

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Publicación exitosa');
      } else {
        print('Error al publicar: ${response.statusCode}');
        var responseData = await response.stream.bytesToString();
        print(responseData);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle heyTextStyle = TextStyle(
      fontFamily: "Hey",
      color: Colors.white, // Puedes ajustar el color aquí si es necesario
    );

    return Scaffold(
      backgroundColor: Colors.black,
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
                            fontFamily: "Hey"),
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
                            fontFamily: "Hey"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                if (isMissingPet) ...[
                  _buildTextField(
                    nameController,
                    'Nombre',
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(ageController, 'Edad'),
                  const SizedBox(height: 16.0),
                  _buildTextField(descriptionController, 'Descripción',
                      maxLines: 3),
                  const SizedBox(height: 16.0),
                  _buildDropdownButtonFormFieldSexo(
                      'Sexo', selectedSex, ['HEMBRA', 'MACHO'],
                      (String? newValue) {
                    setState(() {
                      selectedSex = newValue!;
                    });
                  }),
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
                    onPressed: () => _submitPost(someParameter: false),
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
                    selectedCategoryNombre,
                    categories,
                    (String? newCategoryNombre, String? newCategoryId) {
                      setState(() {
                        selectedCategoryNombre = newCategoryNombre!;
                        selectedCategoryId = newCategoryId!;
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
                    onPressed: () => _submitPost(someParameter: true),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFF5BFFD3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Publicar',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTextField(TextEditingController controller, String labelText,
      {int maxLines = 1, bool readOnly = false, VoidCallback? onTap}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(color: Colors.white), // Color del texto al escribir
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.white, // Color del texto del label
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Color(0xFF5BFFD3), // Color del borde al seleccionar
            width: 2.0, // Grosor del borde al seleccionar
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Colors.white, // Color del borde cuando no está seleccionado
            width: 1.0, // Grosor del borde cuando no está seleccionado
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Color(0xFF5BFFD3), // Color del borde al estar enfocado
            width: 2.0, // Grosor del borde al estar enfocado
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButtonFormFieldSexo(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      style: const TextStyle(color: Color.fromARGB(255, 68, 190, 158)),
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

  Widget _buildDropdownButtonFormField(
    String label,
    String? value,
    List<Category> categories,
    void Function(String?, String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      style: const TextStyle(color: Color.fromARGB(255, 68, 190, 158)),
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
      items: categories.map<DropdownMenuItem<String>>((Category category) {
        return DropdownMenuItem<String>(
          value: category.nombre,
          child: Text(category.nombre),
        );
      }).toList(),
      onChanged: (String? newValue) {
        // Busca la categoría correspondiente al nombre seleccionado
        final selectedCategory = categories.firstWhere(
          (category) => category.nombre == newValue,
          orElse: () => Category(
              id: '',
              nombre: ''), // Manejar caso donde no se encuentra la categoría
        );
        // Llama a la función externa pasando el nombre y el _id de la categoría
        onChanged(newValue, selectedCategory.id);
      },
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

// Esta función puede ayudar a determinar el tipo MIME basado en la extensión del archivo
String lookupMimeType(String path) {
  final extension = path.split('.').last.toLowerCase();
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'mp4':
      return 'video/mp4';
    case 'avi':
      return 'video/x-msvideo';
    case 'mov':
      return 'video/quicktime';
    default:
      return 'application/octet-stream';
  }
}
