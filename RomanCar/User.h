//
//  User.h
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/10/10.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "BaseObject.h"

@interface User : BaseObject

@property (nonatomic) NSString *avatarUrl;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *phone;
@property (nonatomic, assign) NSInteger identifier;


@end

