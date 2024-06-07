import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class Story {
  final String username;
  final String url;
  final String time;
  final bool isVideo;
  bool seen;

  Story(
      {required this.username,
      required this.url,
      required this.time,
      required this.isVideo,
      this.seen = false});
}

class MyApp extends StatelessWidget {
  final List<Story> stories = [
    Story(
        username: "Bachac",
        url:
            "https://img.buzzfeed.com/buzzfeed-static/static/2017-09/13/12/asset/buzzfeed-prod-fastlane-03/sub-buzz-4660-1505320964-2.png?downsize=700%3A%2A&output-quality=auto&output-format=auto",
        time: "Hace 10 horas",
        isVideo: false),
    Story(
        username: "Yerick",
        url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSndVZhWXuWgeTSh0nTVxm_84bULEUYwezEQ&s",
        time: "Hace 3 horas",
        isVideo: false),
    Story(
        username: "Miguelito",
        url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGv0ZIrLidHrXmxdSY38qwW3_FyQZhJo-sFQ&s",
        time: "Hace 2 horas",
        isVideo: false),
    Story(
        username: "Ruben",
        url:
            "https://i0.wp.com/dibujokawaii.com/wp-content/uploads/2022/12/como-dibujar-pinguino-kawaii.png?w=1000&ssl=1",
        time: "Hace 2 horas",
        isVideo: false),
    Story(
        username: "Joshua",
        url: "https://media.tenor.com/MjYaFKjKQakAAAAM/dapper-dog.gif",
        time: "Hace 2 horas",
        isVideo: false),
    Story(
        username: "Josue",
        url:
            "https://png.pngtree.com/thumb_back/fh260/background/20230527/pngtree-dog-s-face-looking-up-at-the-camera-image_2677403.jpg",
        time: "Hace 2 horas",
        isVideo: false),
    Story(
        username: "Brayna",
        url:
            "https://hips.hearstapps.com/hmg-prod/images/gettyimages-1252512247-645a3670a0276.jpg?crop=1xw:1xh;center,top&resize=980:*",
        time: "Hace 2 horas",
        isVideo: false),
    Story(
        username: "Miim",
        url:
            "https://hips.hearstapps.com/hmg-prod/images/gettyimages-1469836274-645a3672bc1be.jpg?crop=1xw:1xh;center,top&resize=980:*",
        time: "Hace 2 horas",
        isVideo: false),
    Story(
        username: "Fernando",
        url:
            "https://m.media-amazon.com/images/I/61pHnfSM6CL._AC_UF894,1000_QL80_.jpg",
        time: "Hace 2 horas",
        isVideo: false),
    Story(
        username: "Vanesa",
        url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpcnUd4DnHAsDY3i3_Cf2GEUp_ungbJ30i6-DqrVw8KVY-RbLDfXfGgdlO8kPT9YuB5UQ&usqp=CAU",
        time: "Hace 2 horas",
        isVideo: false),
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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );
    setState(() {
      _imageFile = pickedFile;
    });
    if (_imageFile != null) {
      _addStory(imagePath: _imageFile!.path);
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final pickedFile = await _picker.pickVideo(
      source: source,
    );
    setState(() {
      _videoFile = pickedFile;
    });
    if (_videoFile != null) {
      _addStory(videoPath: _videoFile!.path);
    }
  }

  bool isStoryExpired(String time) {
    try {
    final storyTime = DateTime.parse(time);
    final now = DateTime.now();
    final difference = now.difference(storyTime);
    return difference.inHours >= 24;
    } catch (e) {
      print('Error parsig time: $e');
      return false;
    }
  } 

  void _showExpiredStoryDialog() {
    showDialog(context: context, 
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
    final now = DateTime.now();
    final newStory = Story(
      username: "Yo",
      url: imagePath ?? videoPath!,
      time: "Hace unos momentos",
      isVideo: videoPath != null,
    );

    setState(() {
      widget.stories.insert(0, newStory);
    });
  }

  void _markAsSeen(int index) {
    setState(() {
      widget.stories[index].seen = true;
    });
  }

  void _showPicker(context) {
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
                  builder: (context) =>
                      StoryScreen(story: story),
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
                    backgroundImage: story.isVideo
                        ? AssetImage('assets/video_icon.png')
                        : NetworkImage(story.url),
                    radius: 30,
                  ),
                    Container(
                      decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: story.seen ? Colors.grey : Colors.cyan,
                        width: 3.0,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(story.username),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (story.isVideo)
              VideoPlayerWidget(videoFile: XFile(story.url))
            else
              CircleAvatar(
                backgroundImage: FileImage(File(story.url)),
                radius: 100,
              ),
            SizedBox(height: 20),
            Text(
              story.username,
              style: TextStyle(fontSize: 19, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final XFile videoFile;

  const VideoPlayerWidget({required this.videoFile});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoFile.path))
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // Auto-play the video
        _controller.setLooping(true); // Loop the video
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
    super.dispose();
    _controller.dispose();
  }
}
