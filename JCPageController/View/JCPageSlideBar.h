//
//  JCPageSlideBar.h
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCPageSlideBarItem;
@class JCPageSlideBarDataSource;

@interface JCPageSlideBar : UIView
@property (nonatomic, strong) JCPageSlideBarDataSource *dataSource;

@end
