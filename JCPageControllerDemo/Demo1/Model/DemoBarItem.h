//
//  DemoBarItem.h
//  JCPageControllerDemo
//
//  Created by zhengjiacheng on 2017/2/21.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DemoBarItem : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) NSInteger index;
@end
