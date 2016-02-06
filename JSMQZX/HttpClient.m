//
//  HttpClient.m
//  beiying
//
//  Created by Shen Jun on 15/5/26.
//  Copyright (c) 2015年 沈骏. All rights reserved.
//

#import "HttpClient.h"
#import "RTJSONResponseSerializerWithData.h"

@interface HttpClient()

@property (strong, nonatomic) AFHTTPSessionManager *manager;
// 请求对象
@property (strong, nonatomic) NSMutableURLRequest *request;
// 网络请求
@property (strong, nonatomic) AFHTTPRequestOperation *requestOperaion;

// 请求管理对象
@property (strong, nonatomic) AFHTTPRequestOperationManager *opManager;

@end

@implementation HttpClient

static id _instace;

- (id)init
{
    if (self = [super init]) {
        // 初始化请求管理对象
        self.opManager = [AFHTTPRequestOperationManager manager];
        self.opManager.responseSerializer.acceptableContentTypes =
        [NSSet setWithObjects:@"application/json",@"charset=utf-8",@"image/jpeg",@"text/html",@"text/xml",nil];
            // 初始化 请求对象
            [self initRequest];

            self.manager = [AFHTTPSessionManager manager];
            
            self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            //响应结果序列化类型
            self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
             self.manager.requestSerializer.timeoutInterval = 15;
            //设置相应内容类型
            self.manager.responseSerializer.acceptableContentTypes =
            [NSSet setWithObjects:@"application/json",@"charset=utf-8",@"image/jpeg",@"text/html",@"text/xml",nil];
             /*self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接受类型不一致请替换一致text/html或别的*/
            
            // 1.获得网络监控的管理者
            AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
            
            // 2.设置网络状态改变后的处理
            [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                // 当网络状态改变了, 就会调用这个block
                switch (status) {
                    case AFNetworkReachabilityStatusUnknown: // 未知网络
                        NSLog(@"未知网络");
                        self.netWorkStaus = AFNetworkReachabilityStatusUnknown;
                        [self showExceptionDialog];
                        break;
                        
                    case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                        NSLog(@"没有网络(断网)");
                        self.netWorkStaus = AFNetworkReachabilityStatusNotReachable;
                        [self showExceptionDialog];
                        break;
                        
                    case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                        NSLog(@"手机自带网络");
                        self.netWorkStaus = AFNetworkReachabilityStatusReachableViaWWAN;
                        break;
                        
                    case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                        NSLog(@"WIFI");
                        self.netWorkStaus = AFNetworkReachabilityStatusReachableViaWiFi;
                        break;
                }
            }];
            
            // 3.开始监控
            [mgr startMonitoring];
    }
    
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)httpClient
{
    return [[HttpClient alloc] init];
}

- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters prepareExecute:(PrepareExecuteBlock)prepareExecute
                success:(void (^)(NSURLSessionDataTask *, id))success
                failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    //请求的URL
    NSLog(@"%@",parameters);
    
    if (prepareExecute) {
        prepareExecute();
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BaseURL, url];
    switch (method) {
        case TBHttpRequestGet:
        {
            [self.manager GET:urlStr parameters:parameters success:success failure:failure];
        }
            break;
        case TBHttpRequestPost:
        {
            [self.manager POST:urlStr parameters:parameters success:success failure:failure];
        }
            break;
        case TBHttpRequestDelete:
        {
            [self.manager DELETE:urlStr parameters:parameters success:success failure:failure];
        }
            break;
        case TBHttpRequestPut:
        {
            [self.manager PUT:urlStr parameters:parameters success:success failure:false];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 初始化 请求对象
- (void)initRequest
{
    self.request = [[NSMutableURLRequest alloc] init];
    self.request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    self.request.timeoutInterval = 30;

    self.requestOperaion = [[AFHTTPRequestOperation alloc] initWithRequest:self.request];
    self.requestOperaion.responseSerializer = [AFJSONResponseSerializer serializer];
    
}


#pragma mark - 请求管理请求
- (void)requestOperaionManageWithURl:(NSString *)urlStr
                          httpMethod:(NSInteger)method
                          parameters:(id)parameters
                            bodyData:(NSData *)bodyData
                          DataNumber:(NSInteger)number
                             success:(void (^)(AFHTTPRequestOperation*, id))success
                             failure:(void (^)(AFHTTPRequestOperation*, NSError *))failure
{
    switch (method) {
        case TBHttpRequestGet:
        {
            [self.opManager GET:urlStr parameters:nil success:success failure:failure];
        }
            break;
        case TBHttpRequestPost:
        {
            self.opManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            self.opManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [self.opManager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                /*for (int i =0 ; i<number; i++) {
                    NSString *fileName = [parameters objectForKey:@"filename"][i];
                    [formData appendPartWithFileData:bodyData[i] name:@"file" fileName:fileName mimeType:@"image/jpg"];
                }*/
                
                if (bodyData) {
                    [formData appendPartWithFileData:bodyData name:@"file" fileName:[parameters objectForKey:@"filename"] mimeType:@"image/jpg"];
                }
            } success:success failure:failure];
        }
        default:
            break;
    }
}


// 弹出网络错误提示框
- (void)showExceptionDialog
{
    [[[UIAlertView alloc] initWithTitle:@"提示"
                                message:@"网络异常,请检查网络连接"
                               delegate:self
                      cancelButtonTitle:@"好的"
                      otherButtonTitles:nil, nil] show];
}


@end
