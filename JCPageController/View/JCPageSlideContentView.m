//
//  JCPageSlideContentView.m
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/12.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "JCPageSlideContentView.h"

@interface JCPageSlideContentView()
@property (nonatomic, strong) NSMutableSet *mutableSet;
@end

@implementation JCPageSlideContentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(3 * self.frame.size.width, self.frame.size.height);
        self.pagingEnabled = YES;
        self.scrollsToTop = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}
@end
