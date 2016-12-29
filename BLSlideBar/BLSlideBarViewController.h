//
//  BLSlideBarViewController.h
//  BLSlideBarDemo
//
//  Created by busylife on 16/12/26.
//  Copyright © 2016年 busylife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLSlideBarHeadView.h"

@class BLSlideBarViewController;

@protocol BLSlideBarViewControllerDelegate <NSObject>

@optional
- (void)slideBarViewController:(BLSlideBarViewController*)slideBarViewController offset:(CGPoint)offset;
- (void)slideBarViewController:(BLSlideBarViewController *)slideBarViewController index:(NSUInteger)index;
@end


@protocol BLSlideBarViewControllerDataDelegate <NSObject>

@required
- (NSUInteger)numberOfChilderViewControllerInSlideViewController:(BLSlideBarViewController*)slideBarViewController;
- (UIViewController*)slideBarViewController:(BLSlideBarViewController*)slideBarViewController viewControllerAtIndex:(NSUInteger)index;

@end


@interface BLSlideBarViewController : UIViewController

@property(nonatomic,weak) id<BLSlideBarViewControllerDelegate> delegate;
@property(nonatomic,weak) id<BLSlideBarViewControllerDataDelegate> dataSource;
@property(nonatomic,assign) NSUInteger currentIndex;
@property(nonatomic,strong) BLSlideBarHeadView *slideBarHeadView;
@property(nonatomic,strong) UIScrollView *scrollView;

- (void)reloadData;

@end
