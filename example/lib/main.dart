import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fphello/fphello.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _fphelloPlugin = Fphello();
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    _eventListen();
  }

  Future<void> _checkPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
      });
    } else {
      setState(() {
        _permissionGranted = false;
      });
    }
  }

  void _eventListen(){
    _fphelloPlugin.getEventStream().receiveBroadcastStream().listen((event){
      setState(() {
        toast(event);
      });
    });
  }

  Future<String> getVersion() async{
    String ver;
    try {
      ver = await _fphelloPlugin.getPlatformVersion() ?? "-unKnow Version";
      setState(() {
        _platformVersion = ver;
      });
    } on PlatformException {
      ver = '-failedGet Version';
    }
    return ver;
  }
  Future<void> getLocation() async {
    if(!_permissionGranted) _checkPermission();
    String loc = await _fphelloPlugin.getLocation() ?? "-unKnow Location";
    print(loc);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion = await getVersion();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }
  toast(data){
    Fluttertoast.showToast(
        msg: data.toString(),
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PluginDemoApp'),
        ),
        body: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                  getLocation();
                }, child: Text('获取地理位置')),
                ElevatedButton(onPressed: (){
                  getVersion();
                }, child: Text('获取版本')),
                ElevatedButton(onPressed: (){
                  _fphelloPlugin.soundPlay();
                }, child: Text('播放声音')),
              ],
            )
          ]
        ),
      ),
    );
  }
}
