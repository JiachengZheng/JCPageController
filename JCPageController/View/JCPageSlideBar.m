//
//  JCPageSlideBar.m
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "JCPageSlideBar.h"
#import "JCPageSlideBarCell.h"

@interface JCPageSlideBar() <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *line;
@end

@implementation JCPageSlideBar

- (UICollectionViewFlowLayout *)colletionViewLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(44, self.frame.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}

- (UIView *)line{
    if (!_line) {
        CGFloat height = 2.5;
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - height-0.5, 23, height)];
        [self.collectionView addSubview:_line];
        [_line.layer setCornerRadius:2];
        _line.backgroundColor = [UIColor redColor];
    }
    return _line;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.colletionViewLayout];
        [_collectionView setContentInset:UIEdgeInsetsZero];
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[JCPageSlideBarCell class] forCellWithReuseIdentifier:@"JCPageSlideBarCell"];
        [self addSubview:_collectionView];
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor lightGrayColor].CGColor;
        line.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
        [self.layer addSublayer:line];
    }
    return _collectionView;
}

- (void)selectTabAtIndex:(NSInteger)index{
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)moveBottomLineToIndex:(NSInteger)index{
    switch (self.lineAinimationType) {
        case JCSlideBarLineAnimationFixedWidth:
            [self animateLineWithDynamicWidth:index width:23];
            break;
        case JCSlideBarLineAnimationDynamicWidth:{
            NSString *title = [self.dataSource pageContoller:_controller titleForCellAtIndex:index];
            CGFloat width = [self boundingSizeWithString:title font:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 40)].width;
            [self animateLineWithDynamicWidth:index width:width];}
            break;
        case JCSlideBarLineAnimationStretchFixedWidth:
            [self animateLineWithDynamicWidth:index width:23];
            break;
        case JCSlideBarLineAnimationStretchDynamicWidth:
            [self animateLineWithDynamicWidth:index width:23];
            break;
    }
}

- (CGRect)cellFrameAtIndex:(NSInteger)index{
    if (index >= [self.dataSource numberOfControllersInPageController]) {
        return CGRectZero;
    }
    UICollectionViewLayoutAttributes * cellAttrs = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cellAttrs.frame;
}

- (void)animateLineWithDynamicWidth:(NSInteger)index width:(CGFloat)width{

    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    CGRect cellRect = [self cellFrameAtIndex:index];
    if (!cell) {
        CGFloat width = [self.dataSource pageContoller:_controller widthForCellAtIndex:0];
        cellRect.size.width = width;
        cellRect.origin.x = 0;
        cellRect.origin.y = 0;
        cellRect.size.height = self.frame.size.height;
    }
    [UIView animateWithDuration:0.16 animations:^{
        CGRect rect = self.line.frame;
        rect.size.width = width;
        self.line.frame = rect;
        self.line.center = CGPointMake(cellRect.origin.x + cellRect.size.width/2, self.line.center.y);
    }];
}

- (void)stretchBottomLineFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
    CGFloat width = 23;
    CGRect nextCellRect = [self cellFrameAtIndex:toIndex];
    CGRect curCellRect = [self cellFrameAtIndex:fromIndex];
    
    CGRect curlineRect = CGRectMake(curCellRect.origin.x + curCellRect.size.width/2 - width/2, self.line.frame.origin.y, width, self.line.frame.size.height);
    CGRect nextlineRect = CGRectMake(nextCellRect.origin.x + nextCellRect.size.width/2 - width/2, self.line.frame.origin.y, width, self.line.frame.size.height);
    
    CGFloat originX = curlineRect.origin.x;
    CGFloat centerGap = (nextlineRect.origin.x + nextlineRect.size.width/2) - (curlineRect.origin.x + curlineRect.size.width/2);
    if (fromIndex < toIndex) {
        if (progress <= 0.5) {
            curlineRect.size.width = width + centerGap*(progress/0.5);
        }else{
            CGFloat p = (progress-0.5)/0.5;
            curlineRect.size.width = width + centerGap - centerGap*p;
            curlineRect.origin.x = originX + centerGap *((progress - 0.5)/0.5);
        }
    }else{
        centerGap = (curlineRect.origin.x + curlineRect.size.width/2) - (nextlineRect.origin.x + nextlineRect.size.width/2);
        if (progress <= 0.5) {
            CGFloat p = progress/0.5;
            curlineRect.size.width = width + centerGap*p;
            curlineRect.origin.x = originX - centerGap *p;
        }else{
            CGFloat p = (progress - 0.5 ) /0.5;
            curlineRect.size.width = width + centerGap - centerGap*p;
            curlineRect.origin.x = nextlineRect.origin.x;
        }
    }
    
    self.line.frame = curlineRect;
}

- (void)reloadData{
    [self.collectionView reloadData];
}

#pragma mark
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource numberOfControllersInPageController];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JCPageSlideBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JCPageSlideBarCell" forIndexPath:indexPath];
    NSString *title = [self.dataSource pageContoller:_controller titleForCellAtIndex:indexPath.row];
    if (!title) {
        title = @"";
    }
    cell.text = title;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = [self.dataSource pageContoller:_controller widthForCellAtIndex:indexPath.row];
    return CGSizeMake(width, self.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.delegate pageSlideBar:self didSelectBarAtIndex:indexPath.row];
}

#pragma mark
#pragma mark -- boundingSizeWithString
- (CGSize)boundingSizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize textSize = CGSizeZero;
#if (__IPHONE_OS_VERSION_MIN_REQUIRED && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0)
    if (![string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // below ios7
        textSize = [string sizeWithFont:font
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByWordWrapping];
    }else
#endif
    {
        //iOS 7
        CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font } context:nil];
        textSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return textSize;
}

@end
