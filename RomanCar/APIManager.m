//
//  APIManager.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/8/30.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "APIManager.h"
#import "SessionManager.h"
#import "constant.h"

NSString *const baseURL = @"http://gym-api.xxkuaipao.com";
NSString *const kAPIRequestOperationManagerErrorInfoMessageKey = @"message";
NSString *const kAPIRequestOperationManagerErrorInfoServerCodeKey = @"serverCode";
NSString *const kAPIRequestOperationManagerErrorInfoServerDataKey = @"serverData";

@implementation APIManager

+ (instancetype)shareManager
{
    static APIManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[APIManager alloc]initWithBaseURL:[NSURL URLWithString:baseURL]];
        [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"text/plain", @"text/json", @"application/json"]];
//        [manager.requestSerializer setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        //监测网络状态
        NSOperationQueue *operationQueue = manager.operationQueue;
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    [operationQueue setSuspended:YES];
                    break;
            }
        }];
        [manager.reachabilityManager startMonitoring];
        
    });
    return manager;
}

- (BOOL)isOffline
{
    return self.operationQueue.isSuspended;
}


- (NSURLSessionDataTask *) requestWithAPI : (APIRequest *)request completion : (void(^)(id result, NSError *error))completion
{
    NSURLSessionDataTask *task = nil;
    if(self.isOffline) {
        NSString *msg = @"网络故障或服务器故障";
        completion(nil, [NSError errorWithDomain:@"com.xxAssistant" code:101 userInfo:@{kAPIRequestOperationManagerErrorInfoMessageKey : msg}]);
        return task;
    }
    
    void (^success)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id errorCode = [responseObject valueForKey:@"errcode"];
        if(errorCode){
            NSInteger code = [errorCode integerValue];
            NSString *errorMsg = [responseObject valueForKey:@"errmsg"] ?: @"未知错误";
            completion(nil, [NSError errorWithDomain:@"xxkuaipao" code:code userInfo:@{@"msg" : errorMsg}]);
            if(code == 1001){
                
                [[SessionManager shareManager] clearSession];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNeedLoginNotification object:nil];
            }
            else if(code == 0){    //成功
                completion(errorMsg, nil);
            }
        }
        else{
            id result = responseObject;
            
            //如果json是数组
            if([result isKindOfClass:[NSArray class]]){
                NSArray *jsonArr = result;
                NSMutableArray *arr = [NSMutableArray new];
                for(id element in jsonArr){
                    id item = [request.resultObjectClass objectWithJson:element];
                    if(item){
                        [arr addObject:item];
                    }
                }
                result = [NSArray arrayWithArray:arr];
            }
            else if(request.resultObjectClass){
                result = [request.resultObjectClass objectWithJson : result];
            }
            completion(result, nil);
        }
    };
    
    void (^failure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n-----------------------\nerror---%@\n\n", error);
        completion(nil, [NSError errorWithDomain:@"com.xxAssistant" code:error.code userInfo:@{@"msg" : @"网络错误或服务器故障"}]);
    };
    
    switch(request.method){
        case APIRequestMethodGet:{
            task = [self GET:request.apiPath parameters:request.params progress:nil success:success failure:failure];

            break;
        }
        case APIRequestMethodPost:{
            task = [self POST:request.apiPath parameters:request.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:nil success:success
            failure:failure];

            break;
        }
        case APIRequestMethodPut:{
            task = [self PUT:request.apiPath parameters:request.params success:success failure:failure];
            break;
        }
    }
    return task;
}


- (NSURLSessionDataTask *) GETWithAPIWithPath : (NSString *)apiPath params : (NSDictionary *)params completion : (void(^)(id jsonObject, NSError *error))completion{
    NSURLSessionDataTask *task = nil;
    if(self.isOffline) {
        NSString *msg = @"网络故障或服务器故障";
        completion(nil, [NSError errorWithDomain:@"com.xxAssistant" code:101 userInfo:@{kAPIRequestOperationManagerErrorInfoMessageKey : msg}]);
        return task;
    }

    task = [self GET:apiPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"]integerValue];
        if(code != 0){
            NSString *msg = [responseObject valueForKey:@"msg"] ?: @"未知错误";
            completion(nil, [NSError errorWithDomain:@"com.xxAssistant" code:code userInfo:@{@"msg" : msg}]);
        }
        else{
            id result = [responseObject valueForKey:@"data"];
            completion(result, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n-----------------------\nerror---%@\n\n", error);
        completion(nil, [NSError errorWithDomain:@"com.xxAssistant" code:error.code userInfo:@{@"msg" : @"网络错误或服务器故障"}]);
    }];
    
    return task;
}

- (NSURLSessionDataTask *)POSTWithAPIWithPath:(NSString *)apiPath params:(NSDictionary *)params completion:(void (^)(id, NSError *))completion
{
    
    NSURLSessionDataTask *task = nil;
    if(self.isOffline) {
        NSString *msg = @"网络故障或服务器故障";
        completion(nil, [NSError errorWithDomain:@"com.xxAssistant" code:101 userInfo:@{kAPIRequestOperationManagerErrorInfoMessageKey : msg}]);
        return task;
    }
    task = [self POST:apiPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"]integerValue];
        if(code != 0){
            NSString *msg = [responseObject valueForKey:@"msg"] ?: @"未知错误";
            completion(nil, [NSError errorWithDomain:@"com.xxAssistant" code:code userInfo:@{@"msg" : msg}]);
        }
        else{
            id result = [responseObject valueForKey:@"data"];
            completion(result, nil);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n-----------------------\nerror---%@\n\n", error);
        completion(nil, [NSError errorWithDomain:@"com.xxAssistant" code:error.code userInfo:@{@"msg" : @"网络错误或服务器故障"}]);
    }];
    return task;
}

- (NSURLSessionDataTask *) UploadFileWithAPIWithPath : (NSString *)apiPath params : (NSDictionary *)params files : (NSArray<APIUploadFile *> *) files progress: (void(^)(NSInteger progress))progress completion : (void(^)(id jsonObject, NSError *error))completion
{
    NSURLSessionDataTask *task = nil;
    if(self.isOffline) {
        NSString *msg = @"网络故障或服务器故障";
        completion(nil, [NSError errorWithDomain:@"com.xxAssistant" code:101 userInfo:@{kAPIRequestOperationManagerErrorInfoMessageKey : msg}]);
        return task;
    }
    
    task = [self POST:apiPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for(APIUploadFile *uploadFile in files){
            NSData *data = uploadFile.data;
            if (!data) {
                if (uploadFile.filePath) {
                    data = [NSData dataWithContentsOfFile:uploadFile.filePath];
                }
            }
            if (data) {
                [formData appendPartWithFileData:data name:uploadFile.name fileName:uploadFile.fileName mimeType:uploadFile.mineType];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSInteger percentage = uploadProgress.completedUnitCount/((double)uploadProgress.totalUnitCount)*100;
        progress(percentage);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"]integerValue];
        if(code != 0){
            NSString *msg = [responseObject valueForKey:@"msg"] ?: @"未知错误";
            completion(nil, [NSError errorWithDomain:@"com.xxAssistant" code:code userInfo:@{@"msg" : msg}]);
            if(code == 1001){
                [[SessionManager shareManager] clearSession];
            }
        }
        else{
            completion(responseObject, nil);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n-----------------------\nerror---%@\n\n", error);
        completion(nil, [NSError errorWithDomain:@"com.xxAssistant" code:error.code userInfo:@{@"msg" : @"网络错误或服务器故障"}]);
    }];
    return task;
}

@end

