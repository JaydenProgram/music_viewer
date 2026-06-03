// music_view.dart
import 'package:flutter/material.dart';
import 'package:music_viewer/widgets/song_cover.dart';
import 'package:music_viewer/widgets/song_information.dart';

class MusicView extends StatelessWidget {
  const MusicView({super.key, required this.recentlyPlayed});

  final Map<String, dynamic> recentlyPlayed;

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.dark,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, _) {
        return MaterialApp(
          title: 'Viewer',
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color.fromARGB(255, 30, 30, 30),
          ),
          themeMode: currentMode,
          debugShowCheckedModeBanner: false,
          home: MyMusicView(
            title: 'Flutter Demo Home Page',
            recentlyPlayed: recentlyPlayed,
          ),
        );
      },
    );
  }
}

class MyMusicView extends StatefulWidget {
  const MyMusicView({
    super.key,
    required this.title,
    required this.recentlyPlayed,
  });

  final String title;
  final Map<String, dynamic> recentlyPlayed;

  @override
  State<MyMusicView> createState() => _MyMusicViewState();
}

class _MyMusicViewState extends State<MyMusicView> {
  @override
  Widget build(BuildContext context) {
    final recentlyPlayed = widget.recentlyPlayed;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              MusicView.themeNotifier.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              MusicView.themeNotifier.value =
                  MusicView.themeNotifier.value == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SongCover(recentlyPlayed: recentlyPlayed),
            const SizedBox(width: 16),
            SongInformation(recentlyPlayed: recentlyPlayed),
          ],
        ),
      ),
    );
  }
}
