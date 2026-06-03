import 'package:flutter/material.dart';

class SongInformation extends StatelessWidget {
  const SongInformation({super.key, required this.recentlyPlayed});

  final Map<String, dynamic> recentlyPlayed;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Text(
          style: TextStyle(fontSize: 32, fontWeight: .bold),
          "${recentlyPlayed["items"][0]["track"]["album"]["name"]}",
        ),
        Text(
          style: TextStyle(fontSize: 24, fontWeight: .normal),
          "${recentlyPlayed["items"][0]["track"]["album"]["artists"][0]["name"]}",
        ),
      ],
    );
  }
}
