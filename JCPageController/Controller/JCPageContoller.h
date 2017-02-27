//
//  JCPageContoller.h
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCPageContoller;

typedef NS_ENUM(NSUInteger, JCSlideBarLineAnimationType) {
    JCSlideBarLineAnimationFixedWidth = 0,                 //固定宽度
    JCSlideBarLineAnimationDynamicWidth = 1,               //动态宽度，与标题文字等宽
    JCSlideBarLineAnimationStretchFixedWidth = 2,          //拉伸效果 固定宽度
    JCSlideBarLineAnimationStretchDynamicWidth = 3,        //拉伸效果 动态宽度，与标题文字等宽
};

@protocol JCPageContollerDataSource <NSObject>

@required
// return number of subControllers
- (NSInteger)numberOfControllersInPageController;

// return each viewController
- (UIViewController *)pageContoller:(JCPageContoller *)pageContoller controllerAtIndex:(NSInteger)index;

// return each bar width
- (CGFloat)pageContoller:(JCPageContoller *)pageContoller widthForCellAtIndex:(NSInteger)index;

// return each controller reuse identifier
- (NSString *)reuseIdentifierForControllerAtIndex:(NSInteger)index;

@optional
// return each bar title
- (NSString *)pageContoller:(JCPageContoller *)pageContoller titleForCellAtIndex:(NSInteger)index;

@optional

@end

@protocol JCPageContollerDelegate <NSObject>

@optional
- (void)pageContoller:(JCPageContoller *)pageContoller didShowController:(UIViewController *)controller atIndex:(NSInteger)index;

@end

/**
 *  Note
 *
 *  可以根据identifier 来重用的ViewController，重用最多创建两个ViewController
 *  重用的ViewController 可以通过实现prepareForReuse 方法来做重用之前的准备
 *
 *
 */
@interface JCPageContoller : UIViewController

@property (nonatomic, assign) JCSlideBarLineAnimationType lineAinimationType;
@property (nonatomic) BOOL scaleSelectedBar;

@property (nonatomic, weak) id<JCPageContollerDataSource> dataSource;
@property (nonatomic, weak) id<JCPageContollerDelegate> delegate;

/**
 重新刷新页面
 *
 */
- (void)reloadData;

/**
 根据identifier 获取重用的Controller

 @param identifier 唯一标识
 @param index 展示的位置索引
 */
- (UIViewController *)dequeueReusableControllerWithReuseIdentifier:(NSString *)identifier atIndex:(NSInteger)index;







@end
