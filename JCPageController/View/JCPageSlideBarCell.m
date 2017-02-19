//
//  JCPageSlideBarCell.m
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "JCPageSlideBarCell.h"
#import "JCPageSlideBarItem.h"

@interface JCPageSlideBarCell()
@property (nonatomic, strong) UILabel *label;
@end

@implementation JCPageSlideBarCell
{
    JCPageSlideBarItem *_item;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

+ (NSString *)cellIdentifier{
    return NSStringFromClass(self);
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:_label];
        _label.font = [UIFont systemFontOfSize:13];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
    }
    return  _label;
}

- (void)setObject:(id)item{
    _item = item;
    self.label.text = _item.text;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        _label.textColor = [UIColor redColor];
    }else{
        _label.textColor = [UIColor blackColor];
    }
}
@end
