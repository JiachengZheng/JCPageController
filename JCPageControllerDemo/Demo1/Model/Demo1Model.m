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
    NSNumber *needReuse = params[@"needReuse"];
    NSArray *titleArr = @[@"精选",@"男装",@"鞋",@"数码产品",@"儿童装",@"文娱文娱用品",@"我是标题",@"我是很长的标题"];
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        Demo1BarItem *item = [Demo1BarItem new];
        item.text = titleArr[i];
        item.width = [self boundingSizeWithString:item.text font:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 40)].width + 30 ;
        item.identifier = [NSString stringWithFormat:@"id%ld",i];
        if (needReuse.boolValue) {
            item.identifier = @"sameId";
        }
        [mutableArr addObject:item];
    }
    self.barItems = mutableArr;
    completion(nil);
}

// text size
- (CGSize)boundingSizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize textSize = CGSizeZero;
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0)
    
    if (![string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // below ios7
        textSize = [string sizeWithFont:font
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
#endif
    {
        //iOS 7
        CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font } context:nil];
        textSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    
    return textSize;
}
@end
