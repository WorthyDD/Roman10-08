//
//  WXPageControl.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/10/9.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "WXPageControl.h"

@interface WXPageControl()

@property (nonatomic) NSMutableArray *dotViews;

@end
@implementation WXPageControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        //默认颜色
        _indicatorColor = [UIColor whiteColor];
        _shadowColor = [UIColor colorWithWhite:0.6 alpha:0.5];
        _dotViews = [NSMutableArray array];
    }
    return self;
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages
{
    if(numberOfPages <= 1){
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
    _numberOfPages = numberOfPages;
    if(numberOfPages > _dotViews.count){
        
        for(NSInteger i = _dotViews.count;i < numberOfPages;i++){
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 16, 3)];
            [_dotViews addObject:view];
            [self addSubview:view];
        }
    }
    else if(numberOfPages < _dotViews.count){
        for(NSInteger i = numberOfPages;i < _dotViews.count;i++){
            UIView *view = [_dotViews lastObject];
            [_dotViews removeLastObject];
            [view removeFromSuperview];
        }

    }
    if(_currentPage >= _dotViews.count){
        _currentPage = 0;
    }
    
    for(NSInteger i = 0; i < _dotViews.count;i++){
        
        UIView *dotView = _dotViews[i];
        if(i == _currentPage){
            [dotView setBackgroundColor:_indicatorColor];
        }
        else{
            [dotView setBackgroundColor:_shadowColor];
        }
        
        //位置
        CGFloat dotLen = 16;
        CGFloat gap = 3;
        CGFloat x = self.center.x+(0.5-numberOfPages/2.0+i)*(dotLen+gap);
        dotView.center = CGPointMake(x, self.center.y);
    }
}

- (void)setCurrentPage:(NSUInteger)currentPage
{
    _currentPage = currentPage;
    if(_currentPage >= _dotViews.count){
        return;
    }
    for(NSInteger i = 0; i < _dotViews.count;i++){
        
        UIView *dotView = _dotViews[i];
        if(i == _currentPage){
            [dotView setBackgroundColor:_indicatorColor];
        }
        else{
            [dotView setBackgroundColor:_shadowColor];
        }
    }
}

@end
