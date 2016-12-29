//
//  TodoWarnning.h
//  MyPrecious
//
//  Created by busylife on 16/7/14.
//  Copyright © 2016年 busylife. All rights reserved.
//

//判断表识是否已被定义，条件指示符#ifndef 的最主要目的是防止头文件的重复包含和编译
#ifndef UIConstant_h
#define UIConstant_h
#endif /* UIConstant_h */

#define FontName     @"Helvetica Neue"
#define BoldFontName @"Helvetica-Bold"

//main screent
#define SCREENT_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREENT_HEIGHT [[UIScreen mainScreen]bounds].size.height

// RGB Color
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

/**
 *  弱指针
 */
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define TAGSTART 1000
