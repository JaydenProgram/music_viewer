import 'package:flutter/material.dart';

class SongInformation extends StatelessWidget {
  const SongInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Text(
          style: TextStyle(fontSize: 32, fontWeight: .bold),
          "Song title is here",
        ),
        Text(style: TextStyle(fontSize: 24, fontWeight: .normal), "Artist"),
      ],
    );
  }
}