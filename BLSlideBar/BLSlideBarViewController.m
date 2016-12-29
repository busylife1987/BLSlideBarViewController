//
//  BLSlideBarViewController.m
//  BLSlideBarDemo
//
//  Created by busylife on 16/12/26.
//  Copyright © 2016年 busylife. All rights reserved.
//

#import "BLSlideBarViewController.h"
#import "UIConstant.h"
#import "UIView+Extend.h"

#define UISTATUSBARH 20
#define SCROLLVIEWH 40

@interface BLSlideBarViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIViewController *currentViewController;

@end

@implementation BLSlideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.slideBarHeadView.frame = CGRectMake(0, UISTATUSBARH, self.view.width, SCROLLVIEWH);
    self.scrollView.frame = CGRectMake(0, _slideBarHeadView.bottom, self.view.width, self.view.height - UISTATUSBARH - SCROLLVIEWH);
    self.scrollView.contentSize = CGSizeMake([self numberOfViewController] * SCREENT_WIDTH, self.scrollView.height);
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)reloadData{
    self.scrollView.frame = CGRectMake(0, _slideBarHeadView.bottom, self.view.width, self.view.height - UISTATUSBARH - SCROLLVIEWH);;
    self.scrollView.contentSize = CGSizeMake([self numberOfViewController] * SCREENT_WIDTH, self.scrollView.height);
    [self scrollViewDidScroll:self.scrollView];
}

- (UIScrollView*)scrollView{
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (BLSlideBarHeadView*)slideBarHeadView{
    if (!_slideBarHeadView) {
        _slideBarHeadView = [[BLSlideBarHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, SCROLLVIEWH)];
        [self.view addSubview:_slideBarHeadView];
        WeakSelf(weakSelf);
        _slideBarHeadView.slideBarHeadViewItemClickHandle = ^(BLSlideBarHeadView *slideBarHeadView, NSString *title, NSUInteger index){
            //[UIView animateWithDuration:.3 animations:^{
                [weakSelf.scrollView setContentOffset:CGPointMake((index - TAGSTART) * SCREENT_WIDTH, 0)];
            //}];
            
        };
        
        _slideBarHeadView.slideBarHeadViewFunctionClickHandle = ^(BLSlideBarHeadView *slideBarHeadView, NSString *currentTitle, NSUInteger currentIndex){
            NSUInteger selectItemIndex = [weakSelf.slideBarHeadView setSelectItemView:(currentIndex + 1)];
            //[UIView animateWithDuration:.3 animations:^{
                [weakSelf.scrollView setContentOffset:CGPointMake((selectItemIndex - TAGSTART) * SCREENT_WIDTH, 0)];
            //}];
        };
    }
    return _slideBarHeadView;
}

- (NSUInteger)numberOfViewController{
    if([self.dataSource respondsToSelector:@selector(numberOfChilderViewControllerInSlideViewController:)]){
        return [self.dataSource numberOfChilderViewControllerInSlideViewController:self];
    }
    return 0;
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSUInteger currentIndex = scrollView.contentOffset.x / SCREENT_WIDTH;
    
    if ([self.dataSource respondsToSelector:@selector(slideBarViewController:index:)]) {
        UIViewController *viewController = [self.dataSource slideBarViewController:self viewControllerAtIndex:currentIndex];
        
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
        [self.scrollView addSubview:viewController.view];
        viewController.view.frame = CGRectMake(currentIndex * SCREENT_WIDTH, 0, self.scrollView.width, self.scrollView.height);
        
        _currentViewController = viewController;
    }
    
    if ([self.delegate respondsToSelector:@selector(slideBarViewController:offset:)]) {
        [self.delegate slideBarViewController:self offset:scrollView.contentOffset];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(slideBarViewController:index:)]) {
        [self.delegate slideBarViewController:self index:scrollView.contentOffset.x / SCREENT_WIDTH];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(slideBarViewController:offset:)]) {
        [self.delegate slideBarViewController:self offset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(slideBarViewController:offset:)]) {
        [self.delegate slideBarViewController:self offset:scrollView.contentOffset];
    }
}

//store viewcontroller


@end
