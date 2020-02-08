import 'package:flutter/material.dart';
import 'package:flutter_list_view_provider/videosProvider.dart';
import 'package:provider/provider.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List _playlistList;
  String _errorMessage;
  Stage _stage;

  final _searchTextCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchTextCtrl.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final videosState = Provider.of<VideosProvider>(context);
    _playlistList = videosState.playlist;
    _stage = videosState.stage;
    _errorMessage = videosState.errorMessage;
  }

  void actionSearch() {
    String text = _searchTextCtrl.value.text;
    Provider.of<VideosProvider>(context, listen: false)
        .updateCurrentVideoId(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Videos'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: RaisedButton.icon(
                icon: Icon(Icons.search),
                label: Text("Filter"),
                onPressed: () {
                  actionSearch();
                },
              ),
            ),
            Container(
              child: TextField(
                controller: _searchTextCtrl,
                onSubmitted: (value) {
                  actionSearch();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Please input 1 or 2',
                ),
              ),
            ),
            Flexible(
              child: _stage == Stage.DONE
                  ? PlaylistTree(_playlistList)
                  : _stage == Stage.ERROR
                      ? Center(child: Text("$_errorMessage"))
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
            )
          ],
        ),
      ),
    );
  }
}

class PlaylistTree extends StatelessWidget {
  PlaylistTree(this.playlistList);

  final List playlistList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: playlistList.length,
      itemBuilder: (context, index) {
        var data = playlistList[index];
        return Container(
          child: Text("${data['id']} - ${data['first_name']}"),
        );
      },
    );
  }
}
