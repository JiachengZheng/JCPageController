//
//  JCPageSlideBarItem.h
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JCPageSlideBarItem : NSObject
/**
 标题
 */
@property (nonatomic, copy) NSString *text;

/**
 复用id
 */
@property (nonatomic, copy) NSString *identifier;

/**
 cell的宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 索引
 */
@property (nonatomic, assign) NSInteger index;

@end
