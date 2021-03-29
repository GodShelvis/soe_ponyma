#import <Flutter/Flutter.h>
#import <TAISDK/TAIOralEvaluation.h>

@interface SoePonymaPlugin : NSObject<FlutterPlugin,TAIOralEvaluationDelegate>{
TAIOralEvaluationRet *resultData;
NSString *appId;
NSString *secretId;
NSString *secretKey;
int evalMode;
}
@property (strong, nonatomic) TAIOralEvaluation *oralEvaluation;
@end
