package com.godshelvis.soe_ponyma;

import android.Manifest;
import android.app.Activity;
import android.content.Context;

import android.media.AudioRecord;
import android.media.MediaRecorder;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import com.tencent.taisdk.*;

import java.util.EventListener;
import java.util.UUID;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class SoePonymaPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {

  private MethodChannel channel;

  private static String appId;
  private static String secretId;
  private static String secretKey;
  private static int evalMode;

  // 一、声明并定义对象
  private TAIOralEvaluation oral = new TAIOralEvaluation();
  // context
  private Context context;
  private Activity activity;

  TAIOralEvaluationRet resultData;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.context = flutterPluginBinding.getApplicationContext();

    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "soe_ponyma");
    channel.setMethodCallHandler(this);

    // 设置数据回调
    this.oral.setListener(new TAIOralEvaluationListener() {
      @Override
      public void onEvaluationData(final TAIOralEvaluationData data, final TAIOralEvaluationRet result, final TAIError error) {
        //数据和结果回调（只有data.bEnd为true，result有效）
        if (data.bEnd) {
          resultData = result;
        }
      }
    });
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("startRecord")) {
      String word = call.argument("word");
      appId = call.argument("appId");
      secretId = call.argument("secretId");
      secretKey = call.argument("secretKey");
      evalMode = call.argument("evalMode");
      startRecordVoice(word);
    } else if (call.method.equals("stopRecord")) {
      stopRecordVoice();
    } else if (call.method.equals("getResult")) {
      result.success(getResult());
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  // 初始化参数
  TAIOralEvaluationParam getParam(String word) {
    TAIOralEvaluationParam param = new TAIOralEvaluationParam();
    param.context = this.context;
    param.appId = appId;
    param.sessionId = UUID.randomUUID().toString();
    // 传输方式
    param.workMode = TAIOralEvaluationWorkMode.ONCE;
    // 评测模式
    param.evalMode = evalMode;
    // 是否存储音频文件
    param.storageMode = TAIOralEvaluationStorageMode.DISABLE;
    // 语言类型
    param.serverType = TAIOralEvaluationServerType.ENGLISH;
    // 数据格式（目前支持mp3）
    param.fileType = TAIOralEvaluationFileType.MP3;//只支持mp3
    // 苛刻指数，取值为[1.0 - 4.0]范围内的浮点数，用于平滑不同年龄段的分数，1.0为小年龄段，4.0为最高年龄段
    param.scoreCoeff = 1.0;
    // 被评估语音对应的文本
    param.refText = word;
    param.secretId = secretId;
    param.secretKey = secretKey;

    return param;
  }

  // 内部录制 开始
  void startRecordVoice(String word) {
    resultData = null;
    TAIOralEvaluationParam param = getParam(word);
    this.oral.startRecordAndEvaluation(param, new TAIOralEvaluationCallback() {
      @Override
      public void onResult(final TAIError error) {
        //接口调用结果返回
        if (error.desc!=null) {
          System.out.println("requestId::"+error.requestId);
          System.out.println("code::"+error.code);
          System.out.println("desc::"+error.desc);
        }
      }
    });
  }

  // 内部录制 结束
  void stopRecordVoice() {
    resultData = null;
    this.oral.stopRecordAndEvaluation(new TAIOralEvaluationCallback() {
      @Override
      public void onResult(final TAIError error) {
        //接口调用结果返回
        if (error.desc!=null) {
          System.out.println("requestId::"+error.requestId);
          System.out.println("code::"+error.code);
          System.out.println("desc::"+error.desc);
        }
      }
    });
  }

  String getResult() {
    if (this.resultData != null) {
      return new StringBuilder().append(this.resultData.pronAccuracy).toString();
    }
    return "-2";
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    // 绑定
    this.activity = binding.getActivity();
    // 获取录音权限
    ActivityCompat.requestPermissions(this.activity,new String[]{Manifest.permission.RECORD_AUDIO}, 10001);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {}

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {}

  @Override
  public void onDetachedFromActivity() {}
}
