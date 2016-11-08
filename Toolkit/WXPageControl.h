//
//  WXPageControl.h
//  EmployeeAssistant
//  自定义UIPageControl
//  Created by 武淅 段 on 16/10/9.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXPageControl : UIView

@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic) UIColor *indicatorColor;
@property (nonatomic) UIColor *shadowColor;

@end
