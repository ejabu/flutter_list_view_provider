import 'package:flutter/material.dart';
import 'package:flutter_list_view_provider/videosProvider.dart';
import 'package:provider/provider.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final _searchTextCtrl = TextEditingController();
  List _playlistList;
  String _errorMessage;
  Stage _stage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final videosState = Provider.of<VideosProvider>(context);
    _playlistList = videosState.playlist;
    _stage = videosState.stage;
    _errorMessage = videosState.errorMessage;
  }

  @override
  void dispose() {
    _searchTextCtrl.dispose();
    super.dispose();
  }

  void actionSearch() {
    String value = _searchTextCtrl.value.text;
    Provider.of<VideosProvider>(context, listen: false)
        .updateCurrentVideoId(value);
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
                label: Text("Filter Videos"),
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
            _stage == Stage.DONE
                ? Flexible(
                    child: ListView.builder(
                      itemCount: _playlistList.length,
                      itemBuilder: (context, index) {
                        return PlaylistTreeItem(_playlistList[index]);
                      },
                    ),
                  )
                : _stage == Stage.ERROR
                    ? Center(child: Text("$_errorMessage"))
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
          ],
        ),
      ),
    );
  }
}

class PlaylistTreeItem extends StatelessWidget {
  final Map data;
  PlaylistTreeItem(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("${data['id']} - ${data['first_name']}"),
    );
  }
}
