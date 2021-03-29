import 'dart:async';

import 'package:flutter/material.dart';

import 'package:soe_ponyma/soe_ponyma.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String score = '未开始';
  bool _recording = false;
  SoePonyma sdk = new SoePonyma(
    "appId",
    "secretId",
    "secretKey"
  );
  TextEditingController controller;


  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "hello");
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('录音测试'),
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: controller,
              ),
              Text("分数: $score"),
              _recording?TextButton(
                  child: Text("停止"),
                  onPressed: () async {
                    await stopRecord();
                  }
              ):TextButton(
                  child: Text("录音"),
                  onPressed: () async {
                    await startRecord();
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

  startRecord() {
    sdk.startRecord(controller.text);
    setState(() {
      _recording = true;
      score = "正在评分...";
    });
  }
  stopRecord() async {
    setState(() {
      _recording = false;
    });
    sdk.stopRecord();
    
    int i = 50;
    Timer.periodic(Duration(milliseconds: 200), (timer) async {
      i--;
      double res = await sdk.getResult();
      if(i<0 || res!=-2) {
        timer.cancel();
        if(i<0) {
          setState(() {
            score = "超时";
          });
        } else {
          if (res == -1) {
            setState(() {
              score = '未匹配';
            });
          } else {
            setState(() {
              score = '$res %';
            });
          }
        }
      }
    });
  }
}
