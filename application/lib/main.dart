import 'package:flutter/material.dart';
import 'package:music_viewer/screens/music_view.dart';
import 'package:music_viewer/screens/spotify_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () async {
                try {
                  final playerInfo =
                      await startSpotifyAuthFlow(); //await the profile from the spotify backend

                  //if there is no profile
                  if (playerInfo == null) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not load profile')),
                    );
                    return;
                  }

                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MusicView(recentlyPlayed: playerInfo!),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Auth failed: $e')));
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                ),
              ),
              child: const Text("test"),
            ),
          ),
        ),
      ),
    );
  }
}
