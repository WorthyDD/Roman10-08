//
//  User.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/10/10.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "User.h"


@implementation User

+ (NSDictionary *)JSONMap
{
    static NSDictionary *config;
    if ( !config ){
        config = @{@"avatar_url" : @"avatarUrl",
                   @"name" : @"name",
                   @"phone" : @"phone",
                   @"id" : @"identifier"};
    }
    return config;
}



@end
