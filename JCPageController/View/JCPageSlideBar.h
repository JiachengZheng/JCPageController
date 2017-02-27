//
//  JCPageSlideBar.h
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCPageContoller.h"
@class JCPageSlideBar;

@protocol JCPageSlideBarDelegate <NSObject>

@optional
- (void)pageSlideBar:(JCPageSlideBar *)pageSlideBar didSelectBarAtIndex:(NSInteger)index;
@end

@interface JCPageSlideBar : UIView

@property (nonatomic, assign) JCSlideBarLineAnimationType lineAinimationType;
@property (nonatomic, weak) id<JCPageContollerDataSource> dataSource;
@property (nonatomic, weak) id<JCPageSlideBarDelegate> delegate;
@property (nonatomic, weak) JCPageContoller *controller;
@property (nonatomic) BOOL scaleSelectedBar;

- (void)selectTabAtIndex:(NSInteger)index;

- (void)moveBottomLineToIndex:(NSInteger)index;

- (void)stretchBottomLineFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

- (void)scaleTitleFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

- (void)reloadData;

@end
