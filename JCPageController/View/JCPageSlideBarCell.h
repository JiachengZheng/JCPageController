//
//  JCPageSlideBarCell.h
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitleSelectedColor [UIColor redColor]
#define kTitleNormalColor [UIColor blackColor]
#define kSlideBarCellTitleTag   2000
#define kSlideBarCellScaleSize  1.13

@interface JCPageSlideBarCell : UICollectionViewCell

@property (nonatomic, copy) NSString *text;

@end
