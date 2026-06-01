import 'package:flutter/material.dart';
import 'package:music_viewer/widgets/song_cover.dart';
import 'package:music_viewer/widgets/song_information.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.dark,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, _) {
        return MaterialApp(
          title: 'Viewer',
          theme: ThemeData(
            brightness: .light,
            scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
            textTheme: TextTheme(),
          ),
          darkTheme: ThemeData(
            brightness: .dark,
            scaffoldBackgroundColor: Color.fromARGB(255, 30, 30, 30),
            textTheme: TextTheme(),
          ),
          themeMode: currentMode,
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: .fromARGB(0, 0, 0, 0),
        actions: [
          IconButton(
            icon: Icon(
              MyApp.themeNotifier.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              MyApp.themeNotifier.value =
                  MyApp.themeNotifier.value == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: .center,
          spacing: 16,
          children: [SongCover(), SongInformation()],
        ),
      ),
    );
  }
}