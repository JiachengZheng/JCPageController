//
//  JCPageSlideBarItem.m
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "JCPageSlideBarItem.h"

@implementation JCPageSlideBarItem

- (NSString *)identifier{
    if (!_identifier) {
        return @"";
    }
    return _identifier;
}


@end
