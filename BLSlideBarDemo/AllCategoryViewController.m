//
//  AllCategoryViewController.m
//  BLSlideBarDemo
//
//  Created by busylife on 16/12/28.
//  Copyright © 2016年 busylife. All rights reserved.
//

#import "AllCategoryViewController.h"
#import "UIView+Extend.h"

#define ITEMW 60
#define COLS 4
#define VerticalSpace 20

@interface AllCategoryViewController ()

@end

@implementation AllCategoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部类别";
    
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarItem)];
    self.navigationItem.rightBarButtonItem = closeBtn;
    
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    
    self.navigationItem.hidesBackButton = YES;

    [self initSubView];
}

- (void)initSubView{
    if (_categorys.count == 0) {
        return;
    }
    NSUInteger rows = (_categorys.count - 1) / COLS + 1;
    for (NSUInteger i=0; i<rows; i++) {
        for (NSUInteger j=0; j<COLS; j++) {
            CGFloat spaceW = (self.view.width - COLS * ITEMW) / (COLS + 1);
            CGFloat x = j * (ITEMW + spaceW) + spaceW;
            CGFloat y = i * (ITEMW + VerticalSpace) + VerticalSpace + 64;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, ITEMW, ITEMW)];
            label.text = _categorys[i*COLS + j];
            label.textColor = [UIColor redColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:label];
        }
    }
}

- (void)setCategorys:(NSMutableArray *)categorys{
    _categorys = [NSMutableArray new];
    [_categorys removeAllObjects];
    [_categorys addObjectsFromArray:categorys];
}

- (void)clickRightBarItem{
    [self.navigationController popViewControllerAnimated:NO];
}
@end
