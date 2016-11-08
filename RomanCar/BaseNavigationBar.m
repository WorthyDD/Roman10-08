//
//  BaseNavigationBar.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/5.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "BaseNavigationBar.h"
#import "constant.h"
#import "Tookit.h"

@implementation BaseNavigationBar

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self setBarTintColor:THEME_COLOR];
//    [self setTranslucent:NO];
    [self setTintColor:COLOR_333333];
//    [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

@end
