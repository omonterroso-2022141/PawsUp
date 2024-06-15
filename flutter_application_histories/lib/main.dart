import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:math';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class Story {
  final String username;
  List<StoryItem> items;
  bool seen;

  Story({
    required this.username,
    required this.items,
    this.seen = false,
  });
}

class StoryItem {
  final String url;
  final DateTime time;
  final bool isVideo;

  StoryItem({
    required this.url,
    required this.time,
    required this.isVideo,
  });
}

class MyApp extends StatelessWidget {
  final List<Story> stories = [
    Story(
      username: "Bachac",
      items: [
        StoryItem(
          url:
              "https://img.buzzfeed.com/buzzfeed-static/static/2017-09/13/12/asset/buzzfeed-prod-fastlane-03/sub-buzz-4660-1505320964-2.png?downsize=700%3A%2A&output-quality=auto&output-format=auto",
          time: DateTime.now().subtract(Duration(hours: 10)),
          isVideo: false,
        ),
      ],
    ),
    Story(
      username: "Yerick",
      items: [
        StoryItem(
          url:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSndVZhWXuWgeTSh0nTVxm_84bULEUYwezEQ&s",
          time: DateTime.now().subtract(Duration(hours: 3)),
          isVideo: false,
        ),
      ],
    ),
    Story(
      username: "Miguelito",
      items: [
        StoryItem(
          url: "https://fcb-abj-pre.s3.amazonaws.com/img/jugadors/MESSI.jpg",
          time: DateTime.now().subtract(Duration(hours: 3)),
          isVideo: false,
        ),
      ],
    ),
    Story(
      username: "Ruben",
      items: [
        StoryItem(
          url:
              "https://files.lamega.com.rcnra-dev.com/assets/public/styles/d_img_1200x630/public/media/image/image/2023-08/Cheems%20el%20perrito%20meme%2C%20muri%C3%B3.jpg?h=3685aca4&itok=4f9owBBd",
          time: DateTime.now().subtract(Duration(hours: 3)),
          isVideo: false,
        ),
      ],
    ),
    Story(
      username: "Joshua",
      items: [
        StoryItem(
          url:
              "https://phantom-marca-mx.unidadeditorial.es/878637848d01b60815704747ecab82ae/resize/1200/f/webp/mx/assets/multimedia/imagenes/2023/12/12/17023578484660.jpg",
          time: DateTime.now().subtract(Duration(hours: 3)),
          isVideo: false,
        ),
      ],
    ),
    Story(
      username: "Josue",
      items: [
        StoryItem(
          url:
              "https://fotografias.lasexta.com/clipping/cmsimages02/2023/04/03/D298398C-1178-4C77-A617-B741456A6C68/famoso-meme-twitter-que-inspira-logo-que-cambiado_104.jpg?crop=383,383,x149,y0&width=1200&height=1200&optimize=low&format=webply",
          time: DateTime.now().subtract(Duration(hours: 3)),
          isVideo: false,
        ),
      ],
    ),
    Story(
      username: "Brayna",
      items: [
        StoryItem(
          url:
              "https://hips.hearstapps.com/hmg-prod/images/gettyimages-1252512247-645a3670a0276.jpg?crop=1xw:1xh;center,top&resize=980:*",
          time: DateTime.now().subtract(Duration(hours: 3)),
          isVideo: false,
        ),
      ],
    ),
    Story(
      username: "Miim",
      items: [
        StoryItem(
          url:
              "https://hips.hearstapps.com/hmg-prod/images/gettyimages-1469836274-645a3672bc1be.jpg?crop=1xw:1xh;center,top&resize=980:*",
          time: DateTime.now().subtract(Duration(hours: 3)),
          isVideo: false,
        ),
      ],
    ),
    Story(
      username: "Fernando",
      items: [
        StoryItem(
          url: "https://a.espncdn.com/i/teamlogos/soccer/500/83.png",
          time: DateTime.now().subtract(Duration(hours: 3)),
          isVideo: false,
        ),
      ],
    ),
    Story(
      username: "Vanesa",
      items: [
        StoryItem(
          url:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSaSa9liAppa-xOSXyqtuB-HUFz3O4EYFLlrA&s",
          time: DateTime.now().subtract(Duration(hours: 3)),
          isVideo: false,
        ),
      ],
    ),
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
  List<StoryItem> _newItems = [];

  ImageProvider _buildImageProvider(StoryItem item) {
    try {
      if (item.url.startsWith('http')) {
        return NetworkImage(item.url);
      } else {
        return FileImage(File(item.url));
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
        _newItems.add(StoryItem(
          url: pickedFile.path,
          time: DateTime.now(),
          isVideo: false,
        ));
      });
      _addStoryItem();
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final pickedFile = await _picker.pickVideo(
      source: source,
    );
    if (pickedFile != null) {
      setState(() {
        _newItems.add(StoryItem(
          url: pickedFile.path,
          time: DateTime.now(),
          isVideo: true,
        ));
      });
      _addStoryItem();
    }
  }

  bool isStoryExpired(DateTime storyTime) {
    final now = DateTime.now();
    final difference = now.difference(storyTime);
    return difference.inHours >= 24;
  }

  void _markAsSeen(int index) {
    setState(() {
      widget.stories[index].seen = true;
    });
  }

  void _addStoryItem() {
    setState(() {
      final index =
          widget.stories.indexWhere((story) => story.username == 'New User');

      if (index != -1) {
        widget.stories[index].items.addAll(_newItems);
      } else {
        final newStory = Story(username: 'New User', items: _newItems);
        widget.stories.add(newStory);
      }
      _newItems = [];
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
                onTap: () {
                  _requestPermissionAndPickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Cámara'),
                onTap: () {
                  _requestPermissionAndPickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Grabar Video'),
                onTap: () {
                  _requestPermissionAndPickVideo(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _requestPermissionAndPickImage(ImageSource source) async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      _pickImage(source);
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _requestPermissionAndPickVideo(ImageSource source) async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      _pickVideo(source);
    } else {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permiso denegado'),
          content: Text(
              'No se han otorgado permisos para acceder a la cámara. Por favor, permite el acceso para seleccionar o tomar fotos o grabar videos.'),
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

  void _startStoryTimer(int index) {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        if (index < widget.stories.length - 1) {
          _showStory(widget.stories[index + 1]);
        } else {
          Navigator.of(context).pop();
        }
      }
    });
  }

  void _showStory(Story story) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryScreen(story: story),
      ),
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
          final firstItem = story.items.first;
          return GestureDetector(
            onTap: () {
              if (isStoryExpired(firstItem.time)) {
                _showExpiredStoryDialog();
              } else {
                _markAsSeen(index);
                _showStory(story);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: _buildImageProvider(firstItem),
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

  void _showExpiredStoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Historia expirada'),
          content: Text('Esta historia ha expirado.'),
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
}

class StoryScreen extends StatefulWidget {
  final Story story;

  const StoryScreen({required this.story});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startStoryTimer();
  }

  void _startStoryTimer() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        if (_currentIndex < widget.story.items.length - 1) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
          setState(() {
            _currentIndex++;
          });
          _startStoryTimer();
        } else {
          Navigator.of(context).pop();
        }
      }
    });
  }

  void _navigateToNextStory() {
    if (_currentIndex < widget.story.items.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentIndex++;
      });
      _startStoryTimer();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _navigateToPreviousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.username),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.story.items.length,
            itemBuilder: (context, index) {
              final item = widget.story.items[index];
              return Center(
                child: item.isVideo
                    ? VideoPlayerWidget(videoFile: File(item.url))
                    : (item.url.startsWith('http')
                        ? Image.network(item.url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity)
                        : Image.file(
                            File(item.url),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )),
              );
            },
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: _navigateToPreviousStory,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: _navigateToNextStory,
            ),
          ),
        ],
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
    duration = Random().nextInt(11) + 5;
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
