//
//  BaseViewController.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/5.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController()

//  假的导航栏背景
@property (nonatomic) UIView *barView;
@property (nonatomic) UIView *shadowLine;       //投影

@end
@implementation BaseViewController

+ (instancetype)instanceFromStoryboard
{
    return [self instanceFromStoryboardWithName:@"Main"];
}

+ (instancetype)instanceFromStoryboardWithName:(NSString *)name
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:name bundle:nil];
    id instance = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    //设置返回文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    /*UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackBarButtonItem:)];
    if(self.navigationController.childViewControllers.count>1){
        self.navigationItem.leftBarButtonItem = backItem;
    }*/
    //设置假的导航背景
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [barView setBackgroundColor:THEME_COLOR];
    //投影
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    [line setBackgroundColor:[UIColor colorWithRGB:0xdddddd alpha:0.8]];
    [barView addSubview:line];
    _shadowLine = line;
    [self.view addSubview:barView];
    _barView = barView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_navigationBarShouldClear){
        [_barView removeFromSuperview];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        if(self.navigationController.childViewControllers.count>1){
//            [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        }
    }
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    if(!_navigationBarShouldClear){
//        [self.view bringSubviewToFront:_barView];
//    }
//}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if(!_navigationBarShouldClear){
        [self.view bringSubviewToFront:_barView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_navigationBarShouldClear){
        [self.navigationController.navigationBar setTintColor:THEME_COLOR];
    }
}


- (void) didTapBackBarButtonItem : (id)sender
{
    if(self.navigationController.viewControllers.count > 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)setNavigationShadowLineHide:(BOOL)hide
{
    _shadowLine.hidden = hide;
}

- (void)dealloc
{
    NSLog(@"BaseViewController dealloc---%@", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
