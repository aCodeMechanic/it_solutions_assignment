import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imageUrl = ''; // Stores the URL entered by the user
  String imageToShow = ''; // Stores the URL entered by the user
  bool isMenuOpen = false; // Stores the state of the popup menu
  bool isFullScreen = false; // Stores the state of the fullscreen mode
  // Function to toggle fullscreen mode
  void enterFullscreen() {
    html.document.documentElement?.requestFullscreen();
    isFullScreen = true;
  }
  void exitFullscreen() {
    html.document.exitFullscreen();
    isFullScreen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: GestureDetector(
                    onDoubleTap: isFullScreen ? exitFullscreen : enterFullscreen,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: imageToShow.isNotEmpty
                          ? HtmlWidget("<img src='$imageToShow' />",)
                          : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(hintText: 'Image URL'),
                        onChanged: (value) {
                          setState(() {
                            imageUrl = value;
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          imageToShow = imageUrl;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
          if(isMenuOpen)
            Container(
              color: Colors.black.withOpacity(0.5),
              width: double.infinity,
              height: double.infinity,
            ),
        ],
      ),
      floatingActionButton: PopupMenuButton<String>(
        offset: const Offset(0, -130),
        clipBehavior: Clip.antiAlias,
        onOpened: () {
          setState(() {isMenuOpen = true;});
        },
        onCanceled: () {
          setState(() {isMenuOpen = false;});
        },
        onSelected: (String item) {
          if (item == 'enter_fullscreen') {
            enterFullscreen();
          } else if (item == 'exit_fullscreen') {
            {
              exitFullscreen();
            }
          }
          isMenuOpen = false;
          setState(() {

          });
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<String>(
              value: 'enter_fullscreen',
              child: Text('Enter fullscreen'),
            ),
            const PopupMenuItem<String>(
              value: 'exit_fullscreen',
              child: Text('Exit fullscreen'),
            ),
          ];
        },
        child: Container(
            padding: EdgeInsets.all(8.0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryFixed, shape: BoxShape.circle),child: const Icon(Icons.add)),
      ),
    );
  }
}
