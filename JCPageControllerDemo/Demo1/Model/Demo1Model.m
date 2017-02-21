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
    Demo1BarItem *item1 = [Demo1BarItem new];
    item1.text = item1.identifier = @"item0";
    item1.width = 64;
    Demo1BarItem *item2 = [Demo1BarItem new];
    item2.text = item2.identifier = @"item1";
    item2.width = 60;
    Demo1BarItem *item3 = [Demo1BarItem new];
    item3.text = item3.identifier = @"item2";
    item3.width = 84;
    Demo1BarItem *item4 = [Demo1BarItem new];
    item4.text = item4.identifier = @"item3";
    item4.width = 94;

    Demo1BarItem *item5 = [Demo1BarItem new];
    item5.text = item5.identifier = @"item4";
    item5.width = 74;

    Demo1BarItem *item6 = [Demo1BarItem new];
    item6.text = item6.identifier = @"item5";
    item6.width = 90;

    Demo1BarItem *item7 = [Demo1BarItem new];
    item7.text = item7.identifier = @"item6";
    item7.width = 67;

    Demo1BarItem *item8 = [Demo1BarItem new];
    item8.text = item8.identifier = @"item7";
    item8.width = 60;

    self.barItems = @[item1,item2,item3,item4,item5,item6,item7,item8];
    completion(nil);
}
@end
