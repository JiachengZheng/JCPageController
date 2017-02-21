//
//  JCPageContoller.h
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCPageContoller;

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

@interface JCPageContoller : UIViewController

@property (nonatomic, weak) id<JCPageContollerDataSource> dataSource;
@property (nonatomic, weak) id<JCPageContollerDelegate> delegate;

- (void)reloadData;

- (UIViewController *)dequeueReusableControllerWithReuseIdentifier:(NSString *)identifier;







@end
