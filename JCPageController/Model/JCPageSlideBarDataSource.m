//
//  JCPageSlideBarDataSource.m
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "JCPageSlideBarDataSource.h"
#import <objc/runtime.h>
#import "JCPageSlideBarCell.h"
@interface JCPageSlideBarDataSource()

@end

@implementation JCPageSlideBarDataSource

- (instancetype)initWithItems:(NSArray *)items{
    self = [self init];
    _items = items ? items : @[];
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.items) {
        return self.items.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id obj = nil;
    if (indexPath.row < self.items.count) {
        obj = self.items[indexPath.row];
    }
    Class cellClass = [self cellClassForObject:obj];
    
    NSString *identifier = [cellClass cellIdentifier];
    if (!identifier) {
        const char *className = class_getName(cellClass);
        identifier = [[NSString alloc] initWithBytesNoCopy:(char *) className
                                                    length:strlen(className)
                                                  encoding:NSASCIIStringEncoding freeWhenDone:NO];
    }
    [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
    
    UICollectionViewCell *cell =
    (UICollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[JCPageSlideBarCell class]]) {
        [(JCPageSlideBarCell *) cell setObject:obj];
    }
    return cell;
}

- (Class)cellClassForObject:(id)object{
    return [JCPageSlideBarCell class];
}


@end

