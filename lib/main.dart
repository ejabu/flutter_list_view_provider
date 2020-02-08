import 'package:flutter/material.dart';
import 'package:flutter_list_view_provider/playlistScreen.dart';
import 'package:flutter_list_view_provider/videosProvider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class PlaylistScreenProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideosProvider>(
      create: (_) {
        return VideosProvider();
      },
      child: PlaylistScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Go To StatefulWidget Screen"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return PlaylistScreenProvider();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Provider',
      theme: buildThemeData(context),
      home: MainScreen(),
    );
  }

  ThemeData buildThemeData(BuildContext context) {
    return ThemeData(
      primaryColor: cBlue,
      primaryIconTheme: IconThemeData(
        color: cBlack,
      ),
      appBarTheme: AppBarTheme(
        color: Colors.white,
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.w800,
            color: cBlue,
          ),
        ),
      ),
      textTheme: TextTheme(
        title: TextStyle(
          color: cBlue,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        body1: TextStyle(
          color: cBlack,
          fontSize: 18.0,
          height: 3.1,
        ),
      ),
    );
  }
}

const Color cBlue = Color(0xff212555);
const Color cBlack = Color(0xff000000);
