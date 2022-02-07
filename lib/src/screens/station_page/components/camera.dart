
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'dart:async';

import 'package:webview_windows/webview_windows.dart';

import '../../../state_container.dart';

enum ConnectionState { notDownloaded, loading, finished }

class LiveStreamingPlayer extends StatefulWidget {
  final int index;
  const LiveStreamingPlayer({Key? key, required this.index}) : super(key: key);

  static const routeName = '/camera';

  @override
  _LiveStreamingPlayerState createState() => _LiveStreamingPlayerState();
}

class _LiveStreamingPlayerState extends State<LiveStreamingPlayer> {
  var db = Mysql();
  late MySqlConnection connection;
  final _controller = WebviewController();
  final _textController = TextEditingController();
  String _url = '';
  late Station _station;
  ConnectionState _connState = ConnectionState.notDownloaded;

  @override
  void initState() {
    super.initState();
    setUpConn();
  }

  void setUpConn() async {
    setState(() {
      _connState = ConnectionState.loading;
    });
    MySqlConnection _connection = await db.getConn();
    setState(() {
      connection = _connection;
      _connState = ConnectionState.finished;
    });
    final container = StateContainer.of(context);

    _station = container.stationList[widget.index];
    await _getCameraUrl();
    initPlatformState();
  }

  

  Future _getCameraUrl() async {
    String sql = await _getCameraUrlCmd();
    if (sql.isNotEmpty) {
      var results = await connection.query(sql);
      for (var row in results) {
        setState(() {
          _url = row[0];
        });
      }
    }
  }

  Future<String> _getCameraUrlCmd() async {
    String cmd = '';
    String sql =
        'SELECT sqlFunction FROM permission WHERE name = "Check camera"';
    var results = await connection.query(sql);
    for (var row in results) {
      cmd = row[0].toString().replaceFirst('{}', '${_station.id}');
    }
    return cmd;
  }

  Future<void> initPlatformState() async {
    await _controller.initialize();
    _controller.url.listen((url) {
      _textController.text = url;
    });

    await _controller.setBackgroundColor(Colors.transparent);
    await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    await _controller.loadUrl(_url);

    if (!mounted) return;

    setState(() {});
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return const Text(
        'Not Initialized',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return (_connState == ConnectionState.finished)
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'URL',
                          contentPadding: const EdgeInsets.all(10.0),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              _controller.reload();
                            },
                          )),
                      textAlignVertical: TextAlignVertical.center,
                      controller: _textController,
                      onSubmitted: (val) {
                        _controller.loadUrl(val);
                      },
                    ),
                  ),
                  Expanded(
                      child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Stack(
                            children: [
                              Webview(
                                _controller,
                                permissionRequested: _onPermissionRequested,
                              ),
                              StreamBuilder<LoadingState>(
                                  stream: _controller.loadingState,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data == LoadingState.loading) {
                                      return const LinearProgressIndicator();
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),
                            ],
                          ))),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: StreamBuilder<String>(
        stream: _controller.title,
        builder: (context, snapshot) {
          return Text(
              snapshot.hasData ? snapshot.data! : 'WebView (Windows) Example');
        },
      )),
      body: Center(
        child: compositeView(),
      ),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}
