# BLSlideBarViewController
  多视图滑动切换控制器

BLSlideBarViewController实现多个视图间的滑动切换效果，能够自动调整视图类别标题的可视范围，并可以定制标题颜色、字体大小以及可选扩展功能菜单，简单易用!!!

## 如何使用
```
//新建视图控制器，并继承自BLSlideBarViewController
    
@interface ViewController : BLSlideBarViewController

//并实现相应代理方法 
@interface ViewController ()<BLSlideBarViewControllerDelegate, BLSlideBarViewControllerDataDelegate>{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO; //必须设置改属性
    self.delegate = self;
    self.dataSource = self;
    
    self.slideBarHeadView.titles = @[]; // 设置类别标题
    self.slideBarHeadView.showPageIndicator = NO; // 是否显示滑动指示标，默认为YES
    self.slideBarHeadView.showFunctionImage = NO; // 是否显示扩展功能菜单, 默认为YES
    self.slideBarHeadView.selectColor = [UIColor purpleColor]; // 设置当前选择标题的颜色, 默认为粉红色
    self.slideBarHeadView.normalColor = [UIColor grayColor]; //设置未选择的标题颜色，默认为灰色
    
    self.slideBarHeadView.frame = CGRectMake(0, 64, SCREENT_WIDTH, 40);//调整位置
    
    self.slideBarHeadView.functionImage = [UIImage imageNamed:@"function_icon"];//设置扩展功能菜单图标
    
    self.slideBarHeadView.slideBarHeadViewItemClickHandle = ^(BLSlideBarHeadView *slideBarHeadView, NSString *title, NSUInteger index){}; //点击标题事件处理(不设置默认为切换到对应的视图) 
    self.slideBarHeadView.slideBarHeadViewFunctionClickHandle = ^(BLSlideBarHeadView *slideBarHeadView, NSString *currentTitle, NSUInteger currentIndex){}; // 功能菜单点击事件处理(不设置默认为切换到下一个视图)
    [self reloadData]; 
}


#pragma mark --- BLSlideBarViewControllerDataDelegate
- (NSUInteger)numberOfChilderViewControllerInSlideViewController:(BLSlideBarViewController *)slideBarViewController{
    return _controllers.count;
}

- (UIViewController*)slideBarViewController:(BLSlideBarViewController *)slideBarViewController viewControllerAtIndex:(NSUInteger)index{
    return _controllers[index];
}

#pragma mark --- BLSlideBarViewControllerDelegate
- (void)slideBarViewController:(BLSlideBarViewController *)slideBarViewController offset:(CGPoint)offset{
    [self.slideBarHeadView setContentOffset:offset];
}

```
详细使用方法见Demo中ViewController代码

效果展示<br/>

![Screenshots gif1](http://oggi1up78.bkt.clouddn.com/show1.gif)      ![Screenshots gif2](http://oggi1up78.bkt.clouddn.com/show2.gif)


## 安装
 * 使用 CocoaPods安装
```
  platform: iOS, '8.0'
  pod 'BLSlideBarViewController','~>1.1'
  
```
