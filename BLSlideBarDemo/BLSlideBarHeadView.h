//
//  BLSlideBarHeadView.h
//  BLSlideBarDemo
//
//  Created by busylife on 16/12/23.
//  Copyright © 2016年 busylife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLSlideBarHeadViewItemView.h"

@interface BLSlideBarHeadView : UIView

@property(nonatomic,copy) NSArray<NSString*> *titles;//标题
@property(nonatomic,strong) UIColor *selectColor;//默认淡红色色
@property(nonatomic,strong) UIColor *normalColor;//默认黑色
@property(nonatomic,strong) UIFont *titleFont;//字体，默认13
@property(nonatomic,strong) UIImage *functionImage;//功能键图标
@property(nonatomic,assign) CGPoint contentOffset;//偏移量
@property(nonatomic,getter=isShowPageIndicator) BOOL showPageIndicator;//是否显示翻页指示
@property(nonatomic,getter=isShowFunctionImage) BOOL showFunctionImage;//是否显示功能按键


@property(nonatomic,copy) void(^slideBarHeadViewItemClickHandle)(BLSlideBarHeadView *slideBarHeadView, NSString *title, NSUInteger index);
@property(nonatomic,copy) void(^slideBarHeadViewFunctionClickHandle)(BLSlideBarHeadView *slideBarHeadView, NSString *currentTitle, NSUInteger currentIndex);

- (NSUInteger)setSelectItemView:(NSUInteger)index;

@end
