//
//  SessionManager.h
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/10/10.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIFramework.h"

@interface SessionManager : NSObject


@property (nonatomic, assign) BOOL isLogin;     //登录状态
@property (nonatomic) User *user;

+ (instancetype) shareManager;

/**
 *  用户名 密码 登录
 */
- (void) loginWithUserName : (NSString *)name password : (NSString *)password completion : (void(^)(BOOL success, NSError *error)) completion;

/**
 *  退出登录
 */
- (void) logoutCurrentUserWithcompletion : (void(^)(BOOL success, NSError *error)) completion;

/**
 *  清除本地cookie
 */
- (void) clearSession;


@end
