//
//  JCPageContoller.h
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCPageSlideBarItem;

@protocol JCPageContollerDelegate <NSObject>

@required

- (UIViewController<JCPageContollerDelegate> *)pageForRowByItem:(JCPageSlideBarItem *)item;

- (UIViewController<JCPageContollerDelegate> *)dequeueReusablePageWithItem:(JCPageSlideBarItem *)item;

@optional

@end

@interface JCPageContoller : UIViewController <JCPageContollerDelegate>

@property (nonatomic, strong) NSArray<JCPageSlideBarItem *> *slideBarItems;

@end
