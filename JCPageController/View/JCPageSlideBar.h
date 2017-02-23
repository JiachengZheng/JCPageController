//
//  JCPageSlideBar.h
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCPageContoller.h"

@class JCPageContoller;
@class JCPageSlideBar;
@protocol JCPageSlideBarDelegate <NSObject>

@optional
- (void)pageSlideBar:(JCPageSlideBar *)pageSlideBar didSelectBarAtIndex:(NSInteger)index;

@end

@interface JCPageSlideBar : UIView

@property (nonatomic, weak) id<JCPageContollerDataSource> dataSource;
@property (nonatomic, weak) id<JCPageSlideBarDelegate> delegate;
@property (nonatomic, weak) JCPageContoller *controller;

- (void)selectTabAtIndex:(NSInteger)index;

- (void)reloadData;
@end
