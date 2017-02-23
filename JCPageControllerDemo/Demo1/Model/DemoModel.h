//
//  DemoModel.h
//  JCPageControllerDemo
//
//  Created by zhengjiacheng on 2017/2/21.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoModel : NSObject

@property (nonatomic, strong) NSArray *barItems;

- (void)loadItems:(NSDictionary *)params completion:(void (^)(NSDictionary *))completion;
@end
