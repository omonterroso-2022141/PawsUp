import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'CATEGORIAS',
          style: TextStyle(
            color: Colors.tealAccent,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const CategorySection(
              title: 'Restaurantes',
              posts: [
                PostCard(
                  user: 'LUIS MONTERROSO',
                  time: '6h',
                  content: 'Este café es muy bueno, 100% recomendado',
                  imageUrl: 'https://via.placeholder.com/150',
                ),
                PostCard(
                  user: 'LUIS MONTERROSO',
                  time: '6h',
                  content: 'Este lugar es Pet Friendly 🐾',
                  imageUrl: 'https://via.placeholder.com/150',
                ),
                PostCard(
                  user: 'LUIS MONTERROSO',
                  time: '6h',
                  content: 'Sus comidas son muy buenas',
                  imageUrl: 'https://via.placeholder.com/150',
                ),
              ],
            ),
            const CategorySection(
              title: 'Tienda de productos de mascotas',
              posts: [
                PostCard(
                  user: 'LUIS MONTERROSO',
                  time: '6h',
                  content: 'Hay muchas productos interesantes',
                  imageUrl: 'https://via.placeholder.com/150',
                ),
                PostCard(
                  user: 'LUIS MONTERROSO',
                  time: '6h',
                  content: 'Los precios están algo elevados 🤑',
                  imageUrl: 'https://via.placeholder.com/150',
                ),
                PostCard(
                  user: 'LUIS MONTERROSO',
                  time: '6h',
                  content: 'Gran variedad de productos',
                  imageUrl: 'https://via.placeholder.com/150',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String title;
  final List<PostCard> posts;

  const CategorySection({
    required this.title,
    required this.posts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: posts,
          ),
        ),
      ],
    );
  }
}

class PostCard extends StatelessWidget {
  final String user;
  final String time;
  final String content;
  final String imageUrl;

  const PostCard({
    required this.user,
    required this.time,
    required this.content,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.info, size: 20),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
