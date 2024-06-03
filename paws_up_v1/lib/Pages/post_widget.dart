import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            title: Text(' MONTERROSO'),
            subtitle: Text('6 h'),
            trailing: Icon(Icons.close),
          ),
          Image.network('https://via.placeholder.com/400x300'),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Laky, se perdió hace 5 horas es una perrita de...'),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.info),
                label: const Text('Información'),
                onPressed: () {},
              ),
              TextButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Compartir'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
