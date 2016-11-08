//
//  BaseViewController.h
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/5.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tookit.h"
#import "constant.h"
#import "BaseTextView.h"

@interface BaseViewController : UIViewController

/**
 *  导航栏是否透明
 */
@property (nonatomic, assign) BOOL navigationBarShouldClear;

/**
 *      从storyboard中获取实例对象  前提是storyboard中的storyboardID跟类名保持一致
 */
+ (instancetype) instanceFromStoryboard;

+ (instancetype) instanceFromStoryboardWithName:(NSString *)name;

/**
 *  设置投影的隐藏
 */
- (void) setNavigationShadowLineHide : (BOOL) hide;

@end
