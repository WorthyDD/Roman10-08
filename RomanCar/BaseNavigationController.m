//
//  BaseNavigationController.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/13.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "BaseNavigationController.h"
#import "Tookit.h"
#import "constant.h"

@interface BaseNavigationController()


@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UINavigationBar appearance] setTranslucent:YES];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];  //背景色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : COLOR_333333, NSFontAttributeName : [UIFont systemFontOfSize:17.0f]}];     //标题色
    [[UINavigationBar appearance] setTintColor:THEME_COLOR];       //主题色(返回按钮)
    
    //将本身的navigationBar背景设置为透明
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

@end
