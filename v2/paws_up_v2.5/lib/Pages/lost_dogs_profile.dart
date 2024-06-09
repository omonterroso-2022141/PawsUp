import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LostDogsProfile extends StatelessWidget {
  const LostDogsProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/fondebb.png"), // Ruta a tu imagen de fondo
          fit: BoxFit.cover,
        ),
      ),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return const PostWidget();
        },
      ),
    );
  }
}

class PostWidget extends StatefulWidget {
  const PostWidget({super.key});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInFadeOut;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeInFadeOut =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
            .animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeInFadeOut,
      child: SlideTransition(
        position: _slideAnimation,
        child: Card(
          color: Colors.black,
          margin: const EdgeInsets.all(8), // Reduced margin
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Reduced border radius
          ),
          elevation: 4, // Slightly reduced elevation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                      radius: 18, // Reduced radius
                    ),
                    const SizedBox(width: 8), // Reduced space between elements
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lo publique yo',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16, // Reduced font size
                              fontFamily: "Hey"
                          ),
                        ),
                        SizedBox(height: 2), // Reduced space between texts
                        Text('6 h', style: TextStyle(fontSize: 10,
                          color: Colors.white,)),
                      ],
                    ),
                    const Spacer(),
                    Theme(
                      data: Theme.of(context).copyWith(
                        iconTheme: IconThemeData(color: Color(0xFF5BFFD3)), // Cambia el color a rojo
                      ),
                      child: PopupMenuButton<String>(
                        onSelected: (String value) {},
                        itemBuilder: (BuildContext context) {
                          return {'Reportar', 'Ocultar'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)), // Reduced border radius
                  child: Image.network(
                    'https://via.placeholder.com/400x300',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250, // Significantly reduced height
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0), // Reduced padding
                child: Text(
                  'Laky, se perdió hace 5 horas es una perrita de...',
                  style: TextStyle(fontSize: 14, // Reduced font size
                      color: Colors.white,
                      fontFamily: "Hey"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Reduced horizontal padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.bone,
                              color: Color(0xFF5BFFD3)),
                          onPressed: () {},
                        ),
                        const Text('123',
                          style: TextStyle(fontSize: 14, // Reduced font size
                            color: Colors.white,),),
                        const SizedBox(width: 12), // Reduced space between icons
                        IconButton(
                          icon: const Icon(Icons.comment_outlined,
                              color: Color(0xFF5BFFD3)),
                          onPressed: () {},
                        ),
                        const Text('45',
                          style: TextStyle(fontSize: 14, // Reduced font size
                            color: Colors.white,),),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info, color: Color(0xFF5BFFD3)),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Color(0xFF5BFFD3)),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
