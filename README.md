# soe_ponyma

腾讯云智聆口语评测SDK的个人封装,**非官方**.



### 简介

**版本**: 0.1.0

**功能**: 内部录制/内部录制结束/结果查询 接口封装

**平台**: Android/iOS.



### 使用方法

1.系统能力授权

```
安卓需要权限:
<uses-permission android:name="android.permission.RECORD_AUDIO"></uses-permission>
<uses-permission android:name="android.permission.INTERNET"></uses-permission>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"></uses-permission>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"></uses-permission>

iOS需要权限:
Privacy - Microphone Usage Description
```

2.引入依赖

```yaml
dependencies:
  soe_ponyma: 0.1.0
```

3.创建SDK对象

```dart
import 'package:soe_ponyma/soe_ponyma.dart';

SoePonyma sdk = new SoePonyma(
  "appId",
  "secretId",
  "secretKey"
);
```

4.调用方法

```dart
//开始录制
sdk.startRecord(controller.text);
//结束录制
sdk.stopRecord();
//查询结果
await sdk.getResult();
```



### 方法介绍

```dart
1.开始录制
void startRecord(String word, {SoeEvalMode mode})
参数: 
	word: 待检测的文本
	mode: 评测模式(可选参数)
	
2.结束录制
void stopRecord()

3.查询结果
Future<double> getResult()


SoeEvalMode 是一个枚举对象,其结构如下:

enum SoeEvalMode {
  WORD,
  SENTENCE,
  PARAGRAPH,
  FREE
}
```