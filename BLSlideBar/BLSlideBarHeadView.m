//
//  BLSlideBarHeadView.m
//  BLSlideBarDemo
//
//  Created by busylife on 16/12/23.
//  Copyright © 2016年 busylife. All rights reserved.
//

#import "BLSlideBarHeadView.h"
#import "UIConstant.h"
#import "UIView+Extend.h"

#define TITLEFONT 13
#define LineHeight (1 / [UIScreen mainScreen].scale)
#define NormalBlackColor RGB(43.35,58.65,71.4)
#define HighLightRedColor RGB(255,124.95,165.75)
#define SeperatorColor RGB(234,237,240)
#define PageIndicatorHeight 2
#define FunctionImageViewWH 30
#define HeadTitleSpace 10
#define SeperatorSpace 5

@interface BLSlideBarHeadView()<UIScrollViewDelegate>{
    CGSize _viewSize;
}

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *pageIndicator;
@property(nonatomic,strong) CALayer *lineLayer;
@property(nonatomic,strong)  UIImageView *functionImageView;
@property(nonatomic,strong) UIView *separate;
@property(nonatomic,strong) BLSlideBarHeadViewItemView* currentItemView;

@end

@implementation BLSlideBarHeadView

- (instancetype)init{
    if (self = [super init]) {
        [self initlization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _viewSize = frame.size;
        [self initlization];
    }
    return self;
}

- (void)initlization{
    _showPageIndicator = YES;
    _showFunctionImage = YES;
    _selectColor = HighLightRedColor;
    _normalColor = NormalBlackColor;
    _titleFont = [UIFont systemFontOfSize:TITLEFONT];
}

- (void)setContentOffset:(CGPoint)contentOffset{
    _contentOffset = contentOffset;
    CGFloat offsetX = contentOffset.x;
    //当前页
    NSUInteger index = offsetX / SCREENT_WIDTH;
    BLSlideBarHeadViewItemView *willSeletedItemView = (BLSlideBarHeadViewItemView*)[self.scrollView viewWithTag:index + TAGSTART];
    BLSlideBarHeadViewItemView *nextWillSeletedItemView = (BLSlideBarHeadViewItemView*)[self.scrollView viewWithTag:(index + 1 + TAGSTART)];
    //计算
    CGFloat surplusOffsetX = offsetX - index * SCREENT_WIDTH;
    CGFloat progress = surplusOffsetX / SCREENT_WIDTH;
    
    if ([willSeletedItemView isKindOfClass:[BLSlideBarHeadViewItemView class]]) {
        willSeletedItemView.textColor = _selectColor;
        willSeletedItemView.fillColor = _normalColor;
        willSeletedItemView.fillRatio = progress;
    }
    if ([nextWillSeletedItemView isKindOfClass:[BLSlideBarHeadViewItemView class]]) {
        nextWillSeletedItemView.textColor = _normalColor;
        nextWillSeletedItemView.fillColor = _selectColor;
        nextWillSeletedItemView.fillRatio = progress;
    }
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BLSlideBarHeadViewItemView class]]) {
            if (obj.tag != index + TAGSTART && obj.tag != index + 1 + TAGSTART) {
                BLSlideBarHeadViewItemView *itemView = (BLSlideBarHeadViewItemView*)obj;
                itemView.textColor = _normalColor;
                itemView.fillColor = _selectColor;
                itemView.fillRatio = .0;
            }
        }
    }];
    
    self.currentItemView = willSeletedItemView;
    
    self.pageIndicator.x = self.currentItemView.x;
    self.pageIndicator.backgroundColor = _selectColor;
    
    [self adjustVisualTitle];
}

- (void)layoutSubviews{
    NSUInteger count = self.titles.count;
    CGFloat viewItemTitleW = [self calculateMaxTitleWidth];
    
    self.scrollView.frame = CGRectMake(0, 0, _viewSize.width, _viewSize.height - PageIndicatorHeight);
    if (_showFunctionImage) {
        CGFloat functionImageY = (_viewSize.height - FunctionImageViewWH) * .5;
        CGFloat functionImageX = _viewSize.width - FunctionImageViewWH * 0.7 - SeperatorSpace * 2;//todo optimize
        self.functionImageView.frame = CGRectMake(functionImageX, functionImageY, FunctionImageViewWH, FunctionImageViewWH);
        self.scrollView.width -= (FunctionImageViewWH + SeperatorSpace * 2);
        
        CGFloat separateY = (_viewSize.height - FunctionImageViewWH * .6) * .5;
        self.separate.frame = CGRectMake(self.scrollView.width + SeperatorSpace, separateY, .5, FunctionImageViewWH * .6);
    }
    //类别较少情况下，重新计算
    CGFloat reSetSpace = HeadTitleSpace;
    if ((viewItemTitleW + HeadTitleSpace) * count < self.scrollView.width) {
        reSetSpace = (self.scrollView.width - count * viewItemTitleW) / count;
    }
    CGFloat scrollViewContentW = count * (viewItemTitleW + reSetSpace) + reSetSpace;
    self.scrollView.contentSize = CGSizeMake(scrollViewContentW, self.scrollView.height - PageIndicatorHeight);
    
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BLSlideBarHeadViewItemView class]]) {
            obj.frame = CGRectMake(idx * (viewItemTitleW + reSetSpace) + reSetSpace, 0, viewItemTitleW, self.scrollView.height);
        }
    }];

    if (_showPageIndicator) {
        self.pageIndicator.frame = CGRectMake(reSetSpace, self.scrollView.height - PageIndicatorHeight, viewItemTitleW, PageIndicatorHeight);
    }
    //temporary code -- remove
    //self.lineLayer.frame = CGRectMake(0, self.scrollView.height - LineHeight, scrollViewContentW, LineHeight);
    [self setContentOffset:CGPointMake(0, 0)];
}

- (NSUInteger)setSelectItemView:(NSUInteger)index{
    if (index == _titles.count + TAGSTART) {
        index = TAGSTART;
    }
    self.currentItemView = (BLSlideBarHeadViewItemView*)[self.scrollView viewWithTag:index];
    [self setContentOffset:CGPointMake((index - TAGSTART) * SCREENT_WIDTH, 0)];
    return index;
}

//可视类别的调整
- (void)adjustVisualTitle{
    CGFloat titleItemViewBoundX = _currentItemView.x;
    CGFloat offsetX = _scrollView.contentOffset.x;
    CGFloat halfViewW = _viewSize.width * .5;
    CGFloat willOffset = (titleItemViewBoundX - offsetX) - halfViewW;
    
    BOOL isScrollToLeft = willOffset > 0 ? YES : NO;
    //判断 左滑、右滑
    if(isScrollToLeft){
        CGFloat maxCanScroll = _scrollView.contentSize.width - _scrollView.width - offsetX;
        if (willOffset > maxCanScroll) {
            willOffset = maxCanScroll;
        }
        [UIView animateWithDuration:1.0 animations:^{
            [_scrollView setContentOffset:CGPointMake(offsetX + willOffset, 0)];
        }];
    }
    else{
        if ((-1) * willOffset > offsetX) {
            willOffset = (-1) * offsetX;
        }
        [UIView animateWithDuration:1.0 animations:^{
            [_scrollView setContentOffset:CGPointMake(offsetX + willOffset, 0)];
        }];
    }
}

#pragma mark --- private mothed
//计算类别标题最大宽度
- (CGFloat)calculateMaxTitleWidth{
    __block CGFloat maxTitleWidth = 0;
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            CGFloat titleWidth = [obj sizeWithAttributes:@{NSFontAttributeName:self.titleFont}].width;
            if (titleWidth > maxTitleWidth) {
                maxTitleWidth = titleWidth;
            }
        }
    }];
    return maxTitleWidth;
}

//滚动到当前选择title相应的位置
- (void)scrollToCorrespondingPosition{
    [self.scrollView scrollRectToVisible:self.currentItemView.frame animated:YES];
}

#pragma mark --- tapGesture
- (void)tapItemView:(UITapGestureRecognizer*)gesture{
    BLSlideBarHeadViewItemView *itemView = (BLSlideBarHeadViewItemView*)gesture.view;
    if (itemView) {
        self.currentItemView = itemView;
        if (self.slideBarHeadViewItemClickHandle) {
            self.slideBarHeadViewItemClickHandle(self, itemView.text, itemView.tag);
        }
        
        //放在外部block中处理?
        [self setContentOffset:CGPointMake((itemView.tag - TAGSTART) * SCREENT_WIDTH, 0)];
    }
}

- (void)tapFunctionImageView:(UITapGestureRecognizer*)gesture{
    if (self.slideBarHeadViewFunctionClickHandle) {
        self.slideBarHeadViewFunctionClickHandle(self, _currentItemView.text, _currentItemView.tag);
    }
}

#pragma mark --- setter property
- (void)setTitles:(NSArray<NSString *> *)titles{
    _titles = titles;
    //设置标题
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BLSlideBarHeadViewItemView *itemView = [[BLSlideBarHeadViewItemView alloc]init];
        [self.scrollView addSubview:itemView];
        itemView.text = obj;
        itemView.tag = idx + TAGSTART;
        itemView.font = _titleFont;
        itemView.textColor = self.normalColor;
        itemView.textAlignment = NSTextAlignmentCenter;
        itemView.userInteractionEnabled = YES;
        [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapItemView:)]];
    }];
    
    self.lineLayer.frame = CGRectMake(0, self.scrollView.height - LineHeight, SCREENT_WIDTH, LineHeight);
    self.pageIndicator.frame = CGRectMake(0, 0, 0, PageIndicatorHeight);
    [self setNeedsLayout];
}

- (void)setFunctionImage:(UIImage *)functionImage{
    self.functionImageView.image = functionImage;
    _functionImage = functionImage;
    [self setNeedsLayout];
}

- (void)setShowFunctionImage:(BOOL)showFunctionImage{
    _showFunctionImage = showFunctionImage;
    self.functionImageView.hidden = !showFunctionImage;
    self.separate.hidden = !showFunctionImage;
    [self setNeedsLayout];
}

- (void)setShowPageIndicator:(BOOL)showPageIndicator{
    _showPageIndicator = showPageIndicator;
    self.pageIndicator.hidden = !showPageIndicator;
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    [self setNeedsLayout];
}

- (void)setSelectColor:(UIColor *)selectColor{
    _selectColor = selectColor;
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
}


#pragma mark --- getter property (view initialize)
- (UIImageView*)functionImageView{
    if(!_functionImageView){
        _functionImageView = [[UIImageView alloc]init];
        _functionImageView.clipsToBounds = YES;
        _functionImageView.contentMode = UIViewContentModeCenter;
        _functionImageView.userInteractionEnabled = YES;
        _functionImageView.image = [UIImage imageNamed:@"function_default_icon"];
        [_functionImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFunctionImageView:)]];
        [self addSubview:_functionImageView];
    }
    return _functionImageView;
}

- (UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (CALayer*)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        [self.scrollView.layer addSublayer:_lineLayer];
        _lineLayer.backgroundColor = SeperatorColor.CGColor;
    }
    return _lineLayer;
}

- (UIView*)pageIndicator{
    if (!_pageIndicator) {
        _pageIndicator = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, PageIndicatorHeight)];
        _pageIndicator.backgroundColor = _selectColor;
        [self.scrollView addSubview:_pageIndicator];
    }
    return _pageIndicator;
}

- (UIView*)separate{
    if (!_separate) {
        _separate = [[UIView alloc]init];
        [self addSubview:_separate];
        _separate.backgroundColor = [UIColor grayColor];
        _separate.layer.shadowColor = [UIColor grayColor].CGColor;
        _separate.layer.shadowOffset = CGSizeMake(-1, 0);
        _separate.layer.shadowRadius = .5;
        _separate.layer.shadowOpacity = 0.8;
    }
    return _separate;
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

@end
