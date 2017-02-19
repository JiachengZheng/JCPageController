//
//  JCPageSlideBarDataSource.h
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCPageSlideBarDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong, readonly) NSArray *items;

- (instancetype)initWithItems:(NSArray *)items;

- (Class)cellClassForObject:(id)object;

@end
