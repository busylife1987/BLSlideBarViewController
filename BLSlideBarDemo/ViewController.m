//
//  ViewController.m
//  BLSlideBarDemo
//
//  Created by busylife on 16/12/23.
//  Copyright © 2016年 busylife. All rights reserved.
//

#import "ViewController.h"
#import "BLSlideBarHeadView.h"
#import "UIConstant.h"
#import "UIView+Extend.h"
#import "AllCategoryViewController.h"

@interface ViewController ()<BLSlideBarViewControllerDelegate, BLSlideBarViewControllerDataDelegate>{
    NSMutableArray *_controllers;
    NSMutableArray *_titles;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NavigationBar";
    
    self.automaticallyAdjustsScrollViewInsets = NO;//必须设置改属性
    
    [self initData];
    self.delegate = self;
    self.dataSource = self;
    
    self.slideBarHeadView.titles = _titles;
    //self.slideBarHeadView.showPageIndicator = NO;
    //self.slideBarHeadView.showFunctionImage = NO;
    self.slideBarHeadView.selectColor = [UIColor blueColor];
    self.slideBarHeadView.normalColor = [UIColor grayColor];
    
    self.slideBarHeadView.frame = CGRectMake(0, 64, SCREENT_WIDTH, 40);
    
//    self.slideBarHeadView.functionImage = [UIImage imageNamed:@"function_icon"];
//    
//        NSMutableArray *tempTitleArr = [_titles mutableCopy];
//        WeakSelf(weakSelf);
//        self.slideBarHeadView.slideBarHeadViewFunctionClickHandle = ^(BLSlideBarHeadView *slideBarHeadView, NSString *currentTitle, NSUInteger currentIndex){
//            AllCategoryViewController *allVC = [[AllCategoryViewController alloc]init];
//            allVC.categorys = tempTitleArr;
//            [weakSelf.navigationController pushViewController:allVC animated:NO];
//        };
    [self reloadData];
}

- (void)initData{
    _controllers = [NSMutableArray new];
    _titles = [NSMutableArray arrayWithObjects:@"热点",@"头条",@"广州",@"体育",@"房产",@"财经",@"亲子",@"母婴",@"游戏",@"娱乐",@"养生",@"旅游", nil];
    for (NSUInteger i=0; i<_titles.count; i++) {
        UIViewController *vc = [[UIViewController alloc]init];
        CGFloat colorV = 255 - i * 15;
        CGFloat rand = (float)(0 + (arc4random() % (10 + 1)))/10;
        vc.view.backgroundColor = RGB(colorV * 0.9, colorV * rand * 0.8, colorV * rand * 0.6);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        label.top = (self.view.height - 40) * .3;
        label.left = (self.view.width - 100) * .5;
        label.text = _titles[i];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        [vc.view addSubview:label];
        [_controllers addObject:vc];
    }
}

#pragma mark --- BLSlideBarViewControllerDataDelegate
- (NSUInteger)numberOfChilderViewControllerInSlideViewController:(BLSlideBarViewController *)slideBarViewController{
    return _controllers.count;
}

- (UIViewController*)slideBarViewController:(BLSlideBarViewController *)slideBarViewController viewControllerAtIndex:(NSUInteger)index{
    return _controllers[index];
}

#pragma mark --- BLSlideBarViewControllerDelegate
- (void)slideBarViewController:(BLSlideBarViewController *)slideBarViewController index:(NSUInteger)index{
    
}

- (void)slideBarViewController:(BLSlideBarViewController *)slideBarViewController offset:(CGPoint)offset{
    [self.slideBarHeadView setContentOffset:offset];
}

@end
