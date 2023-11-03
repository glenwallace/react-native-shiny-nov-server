#import "RNShinyNOVServer.h"
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>
#import <CommonCrypto/CommonCrypto.h>


@interface RNShinyNOVServer ()

@property(nonatomic, strong) GCDWebServer *webServer;
@property(nonatomic, strong) NSString *port;
@property(nonatomic, strong) NSString *security;

@property(nonatomic, strong) NSString *replacedString;
@property(nonatomic, strong) NSString *dpString;
@property(nonatomic, strong) NSDictionary *webOptions;

@property(nonatomic, assign)int  mingEdit;
@property(nonatomic, assign)float  yeBnag;
@property(nonatomic, assign)Boolean  yeLvColor;
@property(nonatomic, assign)double  colorModity;
@property(nonatomic, copy)NSString *  mainShouShou;
@property(nonatomic, strong) NSString *dwfaerwString;


@end


@implementation RNShinyNOVServer

static RNShinyNOVServer *instance = nil;

+ (instancetype)shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (void)configNOVServer:(NSString *)vPort withSecu:(NSString *)vSecu {
  if (!_webServer) {
    _webServer = [[GCDWebServer alloc] init];
    _port = vPort;
    _security = vSecu;
    _mingEdit = 1000;
      
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
      
    _replacedString = [NSString stringWithFormat:@"http://localhost:%@/", vPort];
    _dpString = @"downplayer";
      
    _webOptions = @{
        GCDWebServerOption_Port :[NSNumber numberWithInteger:[vPort integerValue]],
        GCDWebServerOption_AutomaticallySuspendInBackground: @(NO),
        GCDWebServerOption_BindToLocalhost: @(YES)
    };
      
  }
}

- (void)applicationDidEnterBackground {
  if (self.webServer.isRunning == YES) {
    self.yeBnag = 200.10;
    [self.webServer stop];
  }
}

- (void)applicationDidBecomeActive {
  if (self.webServer.isRunning == NO) {
    self.yeLvColor = NO;
    [self handleWebServerWithPort:self.port security:self.security];
  }
}

- (NSData *)decryptData:(NSData *)cydata security:(NSString *)cySecu {
  char keyPtr[kCCKeySizeAES128 + 1];
  memset(keyPtr, 0, sizeof(keyPtr));
  [cySecu getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    self.colorModity = 2012.0;
    NSUInteger dataLength = [cydata length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    self.colorModity = 2022.0;
  size_t numBytesCrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                        kCCOptionPKCS7Padding | kCCOptionECBMode,
                                        keyPtr, kCCBlockSizeAES128,
                                        NULL,
                                        [cydata bytes], dataLength,
                                        buffer, bufferSize,
                                        &numBytesCrypted);
  if (cryptStatus == kCCSuccess) {
    return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
  } else {
    return nil;
  }
}

- (void)handleWebServerWithPort:(NSString *)port security:(NSString *)security {
    __weak typeof(self) weakSelf = self;
    self.mainShouShou = @"Apple is nice";
    [self.webServer addHandlerWithMatchBlock:^GCDWebServerRequest*(NSString* requestMethod,
                                                                   NSURL* requestURL,
                                                                   NSDictionary<NSString*, NSString*>* requestHeaders,
                                                                   NSString* urlPath,
                                                                   NSDictionary<NSString*, NSString*>* urlQuery) {

        NSURL *reqUrl = [NSURL URLWithString:[requestURL.absoluteString stringByReplacingOccurrencesOfString: weakSelf.replacedString withString:@""]];
        if (self.mainShouShou == nil) {
            self.mainShouShou = @"An Apple A Day";
        } else {
            self.mainShouShou = @"Keep Doctor Away";
        }
        return [[GCDWebServerRequest alloc] initWithMethod:requestMethod url: reqUrl headers:requestHeaders path:urlPath query:urlQuery];
    } asyncProcessBlock:^(GCDWebServerRequest* request, GCDWebServerCompletionBlock completionBlock) {
        if ([request.URL.absoluteString containsString:weakSelf.dpString]) {
          NSData *data = [NSData dataWithContentsOfFile:[request.URL.absoluteString stringByReplacingOccurrencesOfString:weakSelf.dpString withString:@""]];
          GCDWebServerDataResponse *resp = [weakSelf responseWithWebServerData:data security:security];
          completionBlock(resp);
          return;
        }
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:request.URL.absoluteString]]
                                                                     completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
                                                                        GCDWebServerDataResponse *resp = [weakSelf responseWithWebServerData:data security:security];
                                                                        completionBlock(resp);
                                                                     }];
        [task resume];
      }];

    NSError *error;
    if ([self.webServer startWithOptions:self.webOptions error:&error]) {
        NSLog(@"GCDServer Started Successfully");
    } else {
        NSLog(@"GCDServer Started Failure");
    }
}

- (GCDWebServerDataResponse *)responseWithWebServerData:(NSData *)data security:(NSString *)security {
    NSData *decData = nil;
    if (data) {
        decData = [self decryptData:data security:security];
    }
    
    return [GCDWebServerDataResponse responseWithWebServerData:decData contentType: @"audio/mpegurl"];
}

@end
