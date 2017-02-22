//
//  Demo1Model.m
//  JCPageControllerDemo
//
//  Created by zhengjiacheng on 2017/2/21.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "Demo1Model.h"
#import "Demo1BarItem.h"
@implementation Demo1Model
- (void)loadItems:(NSDictionary *)params completion:(void (^)(NSDictionary *))completion{
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 8; i++) {
        Demo1BarItem *item = [Demo1BarItem new];
        item.text = [NSString stringWithFormat:@"item%ld",i];
        item.width = random()%50 + 70 ;
        item.identifier = i % 2 ? @"id1" : @"id2";
        [mutableArr addObject:item];
    }
    self.barItems = mutableArr;
    completion(nil);
}
@end
