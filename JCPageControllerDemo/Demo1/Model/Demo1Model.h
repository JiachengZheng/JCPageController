//
//  Demo1Model.h
//  JCPageControllerDemo
//
//  Created by zhengjiacheng on 2017/2/21.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Demo1Model : NSObject

@property (nonatomic, strong) NSArray *barItems;

- (void)loadItems:(NSDictionary *)params completion:(void (^)(NSDictionary *))completion;
@end
