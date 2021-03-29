#import "SoePonymaPlugin.h"

@implementation SoePonymaPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"soe_ponyma"
                                     binaryMessenger:[registrar messenger]];
    SoePonymaPlugin* instance = [[SoePonymaPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

// 初始化对象
- (instancetype)init{
    if(self = [super init]){
        //要初始化的内容
        self.oralEvaluation = [[TAIOralEvaluation alloc] init];
        self.oralEvaluation.delegate = self;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"startRecord" isEqualToString:call.method]) {
        //接受传递的参数
        NSDictionary* argument=call.arguments;
        self->appId=argument[@"appId"];
        self->secretId=argument[@"secretId"];
        self->secretKey=argument[@"secretKey"];
        self->evalMode=(int)argument[@"evalMode"];

        NSString *word=argument[@"word"];
        [self startRecord:word];
    } else if([@"stopRecord" isEqualToString:call.method]) {
        [self stopRecord];
    } else if([@"getResult" isEqualToString:call.method]) {
        result([self getResult]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

// 内部录制开始
- (void)startRecord:(NSString *)word {
    self->resultData = nil;
    TAIOralEvaluationParam *param = [self getParam:word];
    [self.oralEvaluation startRecordAndEvaluation:param callback:^(TAIError *error){
        //结果返回
        if (error.desc != nil) {
         NSLog(@"%@", error.desc);
        }
    }];
}
// 内部录制结束
- (void)stopRecord {
    self->resultData = nil;
    [self.oralEvaluation stopRecordAndEvaluation:^(TAIError *error) {
        //结果返回
        if (error.desc != nil) {
         NSLog(@"%@", error.desc);
        }
    }];
}

// 获取结果
- (NSString *)getResult {
    if( self->resultData != nil ) {
        return [NSString stringWithFormat:@"%f", self->resultData.pronAccuracy];
    }
    return @"-2";
}


// 初始化参数
- (TAIOralEvaluationParam *)getParam:(NSString *) word {
  TAIOralEvaluationParam *param = [[TAIOralEvaluationParam alloc] init];
  param.appId = self->appId;
  param.sessionId = [[NSUUID UUID] UUIDString];
  // 传输方式
  param.workMode = TAIOralEvaluationWorkMode_Once;
  // 评测模式
  param.evalMode = self->evalMode;
  // 是否存储音频文件
  param.storageMode = TAIOralEvaluationStorageMode_Disable;
  // 语言类型
  param.serverType = TAIOralEvaluationServerType_English;
  // 数据格式（目前支持mp3）
  param.fileType = TAIOralEvaluationFileType_Mp3;//只支持mp3
  // 苛刻指数，取值为[1.0 - 4.0]范围内的浮点数，用于平滑不同年龄段的分数，1.0为小年龄段，4.0为最高年龄段
  param.scoreCoeff = 1.0;
  // 被评估语音对应的文本
  param.refText = word;
  param.secretId = self->secretId;
  param.secretKey = self->secretKey;
  param.textMode = TAIOralEvaluationTextMode_Noraml;
  param.soeAppId = @"";

  return param;
}

- (void)oralEvaluation:(TAIOralEvaluation *)oralEvaluation onEvaluateData:(TAIOralEvaluationData *)data result:(TAIOralEvaluationRet *)result error:(TAIError *)error
{
    if (data.bEnd) {
        NSLog(@"OVER");
        self->resultData = result;
    }
}

- (void)onEndOfSpeechInOralEvaluation:(TAIOralEvaluation *)oralEvaluation {
    
}


- (void)oralEvaluation:(TAIOralEvaluation *)oralEvaluation onVolumeChanged:(NSInteger)volume {
    
}

@end
