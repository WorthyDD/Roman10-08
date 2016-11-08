//
//  APIManager.h
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/8/30.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "MineType.h"
#import "APIRequest.h"
#import "NSError+Message.h"


@interface APIManager : AFHTTPSessionManager

+ (instancetype) shareManager;

/**
 *  发起一个GET/POST请求
 *  @apiPath : api路径
 *  @completion : 请求完成调用的block
 */

- (NSURLSessionDataTask *) requestWithAPI : (APIRequest *)request completion : (void(^)(id result, NSError *error))completion;


//- (NSURLSessionDataTask *) GETWithAPIWithPath : (NSString *)apiPath params : (NSDictionary *)params completion : (void(^)(id jsonObject, NSError *error))completion;

/**
 *  发起一个普通的POST请求
 *  @apiPath : api路径
 *  @params : 请求参数
 *  @completion : 请求完成调用的block
 */

//- (NSURLSessionDataTask *) POSTWithAPIWithPath : (NSString *)apiPath params : (NSDictionary *)params completion : (void(^)(id jsonObject, NSError *error))completion;

/**
 *  POST上传文件
 *  @files: 待上传的文件数组
 *  @progress  : 上传进度 0-100
 *  @completion : 请求完成调用的block
 */
- (NSURLSessionDataTask *) UploadFileWithAPIWithPath : (NSString *)apiPath params : (NSDictionary *)params files : (NSArray<APIUploadFile *> *) files progress: (void(^)(NSInteger progress))progress completion : (void(^)(id jsonObject, NSError *error))completion;

@end


extern NSString *const kAPIRequestOperationManagerErrorInfoMessageKey;
extern NSString *const kAPIRequestOperationManagerErrorInfoServerCodeKey;
extern NSString *const kAPIRequestOperationManagerErrorInfoServerDataKey;
extern NSString *const baseURL;
