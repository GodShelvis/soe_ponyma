
import 'dart:async';

import 'package:flutter/services.dart';

enum SoeEvalMode {
  WORD,
  SENTENCE,
  PARAGRAPH,
  FREE
}
class SoePonyma {
  String appId;
  String secretId;
  String secretKey;

  SoePonyma(this.appId, this.secretId, this.secretKey);

  static const MethodChannel _channel = const MethodChannel('soe_ponyma');

  startRecord(String word, {SoeEvalMode mode}) {
    _channel.invokeMethod(
        'startRecord',
        Map<String,dynamic>.from(
            {
              "word": word,
              "evalMode": mode!=null?mode.index:SoeEvalMode.WORD.index,
              "appId": appId,
              "secretId": secretId,
              "secretKey": secretKey
            }
        )
    );
  }

  stopRecord() {
    _channel.invokeMethod(
        'stopRecord'
    );
  }

  Future<double> getResult() async {
    String s = await _channel.invokeMethod(
        'getResult'
    );
    return double.parse(s);
  }


}