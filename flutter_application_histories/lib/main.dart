import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class Story {
  final String username;
  final String url;
  final DateTime time;
  final bool isVideo;
  bool seen;

  Story({
    required this.username,
    required this.url,
    required this.time,
    required this.isVideo,
    this.seen = false,
  });
}

class MyApp extends StatelessWidget {
  final List<Story> stories = [
    Story(
      username: "Bachac",
      url:
          "https://img.buzzfeed.com/buzzfeed-static/static/2017-09/13/12/asset/buzzfeed-prod-fastlane-03/sub-buzz-4660-1505320964-2.png?downsize=700%3A%2A&output-quality=auto&output-format=auto",
      time: DateTime.now().subtract(Duration(hours: 10)),
      isVideo: false,
    ),
    Story(
        username: "Yerick",
        url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSndVZhWXuWgeTSh0nTVxm_84bULEUYwezEQ&s",
        time: DateTime.now().subtract(Duration(hours: 3)),
        isVideo: false),
    Story(
        username: "Miguelito",
        url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGv0ZIrLidHrXmxdSY38qwW3_FyQZhJo-sFQ&s",
        time: DateTime.now().subtract(Duration(hours: 10)),
        isVideo: false),
    Story(
        username: "Ruben",
        url:
            "https://i0.wp.com/dibujokawaii.com/wp-content/uploads/2022/12/como-dibujar-pinguino-kawaii.png?w=1000&ssl=1",
        time: DateTime.now().subtract(Duration(hours: 10)),
        isVideo: false),
    Story(
        username: "Joshua",
        url: "https://media.tenor.com/MjYaFKjKQakAAAAM/dapper-dog.gif",
        time: DateTime.now().subtract(Duration(hours: 10)),
        isVideo: false),
    Story(
        username: "Josue",
        url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyXzjjPPHwioU-Wr_NEE7UTmQUejmqE9HEwA&s",
        time: DateTime.now().subtract(Duration(hours: 10)),
        isVideo: false),
    Story(
        username: "Brayna",
        url:
            "https://hips.hearstapps.com/hmg-prod/images/gettyimages-1252512247-645a3670a0276.jpg?crop=1xw:1xh;center,top&resize=980:*",
        time: DateTime.now().subtract(Duration(hours: 10)),
        isVideo: false),
    Story(
        username: "Miim",
        url:
            "https://hips.hearstapps.com/hmg-prod/images/gettyimages-1469836274-645a3672bc1be.jpg?crop=1xw:1xh;center,top&resize=980:*",
        time: DateTime.now().subtract(Duration(hours: 10)),
        isVideo: false),
    Story(
        username: "Fernando",
        url:
            "https://m.media-amazon.com/images/I/61pHnfSM6CL._AC_UF894,1000_QL80_.jpg",
        time: DateTime.now().subtract(Duration(hours: 10)),
        isVideo: false),
    Story(
        username: "Vanesa",
        url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpcnUd4DnHAsDY3i3_Cf2GEUp_ungbJ30i6-DqrVw8KVY-RbLDfXfGgdlO8kPT9YuB5UQ&usqp=CAU",
        time: DateTime.now().subtract(Duration(hours: 10)),
        isVideo: false)
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Historias',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(stories: stories),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Story> stories;

  MyHomePage({required this.stories});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  XFile? _videoFile;

  ImageProvider _buildImageProvider(Story story) {
    try {
      if (story.url.startsWith('http')) {
        return NetworkImage(story.url);
      } else {
        return FileImage(File(story.url));
      }
    } catch (e) {
      print('Error loading image: $e');
      return AssetImage('assets/error_image.png');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      _addStory(imagePath: pickedFile.path);
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final pickedFile = await _picker.pickVideo(
      source: source,
    );
    if (pickedFile != null) {
      setState(() {
        _videoFile = pickedFile;
      });
      _addStory(videoPath: pickedFile.path);
    }
  }

  bool isStoryExpired(DateTime storyTime) {
    final now = DateTime.now();
    final difference = now.difference(storyTime);
    return difference.inHours >= 24;
  }

  void _showExpiredStoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Historia no disponible'),
          content: Text('Esta historia ya no está disponible.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addStory({String? imagePath, String? videoPath}) {
    if (imagePath != null || videoPath != null) {
      final now = DateTime.now();
      final newStory = Story(
        username: "Yo",
        url: imagePath ?? videoPath!,
        time: now,
        isVideo: videoPath != null,
      );
      setState(() {
        widget.stories.insert(0, newStory);
      });
    }
  }

  void _markAsSeen(int index) {
    setState(() {
      widget.stories[index].seen = true;
    });
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galería'),
                onTap: () async {
                  var status = await Permission.photos.status;
                  if (!status.isGranted) {
                    if (await Permission.photos.request().isGranted) {
                      _pickImage(ImageSource.gallery);
                    } else {
                      _showPermissionDialog();
                    }
                  } else {
                    _pickImage(ImageSource.gallery);
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Cámara'),
                onTap: () async {
                  var status = await Permission.camera.status;
                  if (!status.isGranted) {
                    if (await Permission.camera.request().isGranted) {
                      _pickImage(ImageSource.camera);
                    } else {
                      _showPermissionDialog();
                    }
                  } else {
                    _pickImage(ImageSource.camera);
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Grabar video'),
                onTap: () async {
                  var status = await Permission.camera.status;
                  if (!status.isGranted) {
                    if (await Permission.camera.request().isGranted) {
                      _pickVideo(ImageSource.camera);
                    } else {
                      _showPermissionDialog();
                    }
                  } else {
                    _pickVideo(ImageSource.camera);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permiso necesario'),
          content: Text(
              'Es necesario permitir el acceso a la cámara y a la galería para seleccionar o tomar fotos o grabar videos.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historias'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.stories.length,
        itemBuilder: (BuildContext context, int index) {
          final story = widget.stories[index];
          return GestureDetector(
            onTap: () {
              if (isStoryExpired(story.time)) {
                _showExpiredStoryDialog();
              } else {
                _markAsSeen(index);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryScreen(story: story),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: _buildImageProvider(
                            story), // Utiliza el método _buildImageProvider
                        radius: 30,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: story.seen ? Colors.grey : Colors.cyan,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(story.username),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPicker(context),
        child: Icon(Icons.camera),
      ),
    );
  }
}

class StoryScreen extends StatelessWidget {
  final Story story;

  const StoryScreen({required this.story});

  @override
  Widget build(BuildContext context) {
    final int duration = Random().nextInt(11) + 5;

    return Scaffold(
      appBar: AppBar(
        title: Text(story.username),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: story.isVideo
            ? VideoPlayerWidget(videoFile: File(story.url))
            : (story.url.startsWith('http')
                ? Image.network(story.url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity)
                : Image.file(
                    File(story.url),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  const VideoPlayerWidget({required this.videoFile});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late int duration;

  @override
  void initState() {
    super.initState();
    duration =
        Random().nextInt(11) + 5; // Random duration between 5 and 15 seconds
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        _startTimer();
      });
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: duration), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
