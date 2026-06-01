import 'package:flutter/material.dart';

class SongCover extends StatelessWidget {
  const SongCover({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .all(.circular(25)),
      child: Image(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.width / 2,
        image: NetworkImage('https://placehold.co/600x600.jpg'),
      ),
    );
  }
}