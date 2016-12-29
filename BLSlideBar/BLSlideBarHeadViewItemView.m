//
//  BLSlideBarHeadViewItemView.m
//  BLSlideBarDemo
//
//  Created by busylife on 16/12/23.
//  Copyright © 2016年 busylife. All rights reserved.
//

#import "BLSlideBarHeadViewItemView.h"

@implementation BLSlideBarHeadViewItemView

- (void)setFillRatio:(CGFloat)fillRatio{
    _fillRatio = fillRatio;
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:rect];
    
    [_fillColor set];
    CGRect fillRect = rect;
    fillRect.size.width = rect.size.width * self.fillRatio;
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);//向当前绘图环境所创建的内存中的图片上填充一个矩形，绘制使用指定的混合模式。
}

@end
