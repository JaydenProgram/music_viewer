import 'package:flutter/material.dart';

class SongCover extends StatelessWidget {
  const SongCover({super.key, required this.recentlyPlayed});

  final Map<String, dynamic> recentlyPlayed;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .all(.circular(25)),
      child: Image.network(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.width / 2,
        "${recentlyPlayed["items"][0]["track"]["album"]["images"][0]["url"]}",
      ),
    );
  }
}
