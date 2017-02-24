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
@property (nonatomic, assign) NSInteger curSelectIndex;
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
    self.curSelectIndex = index;
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    if (self.scaleSelectedBar) {
        UICollectionViewCell *fromCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        fromCell.transform = CGAffineTransformMakeScale(kSlideBarCellScaleSize , kSlideBarCellScaleSize);
    }
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
        case JCSlideBarLineAnimationStretchDynamicWidth:{
            NSString *title = [self.dataSource pageContoller:_controller titleForCellAtIndex:index];
            CGFloat width = [self boundingSizeWithString:title font:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 40)].width;

            [self animateLineWithDynamicWidth:index width:width];
        }
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

- (void)scaleTitleFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
    if (!self.scaleSelectedBar) {
        return;
    }
    CGFloat scale = kSlideBarCellScaleSize;
    CGFloat currentTransform = (scale - 1) * progress;
    UICollectionViewCell *fromCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:fromIndex inSection:0]];
    UICollectionViewCell *toCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0]];
    fromCell.transform = CGAffineTransformMakeScale(scale - currentTransform , scale - currentTransform);
    toCell.transform = CGAffineTransformMakeScale(1 + currentTransform, 1 + currentTransform);
    
    CGFloat narR,narG,narB,narA;
    [kTitleNormalColor getRed:&narR green:&narG blue:&narB alpha:&narA];
    CGFloat selR,selG,selB,selA;
    [kTitleSelectedColor getRed:&selR green:&selG blue:&selB alpha:&selA];
    CGFloat detalR = narR - selR ,detalG = narG - selG,detalB = narB - selB,detalA = narA - selA;
    
    UILabel *fromTitle = [fromCell viewWithTag:kSlideBarCellTitleTag];
    UILabel *toTitle = [toCell viewWithTag:kSlideBarCellTitleTag];
    fromTitle.textColor = [UIColor colorWithRed:selR+detalR*progress green:selG+detalG*progress blue:selB+detalB*progress alpha:selA+detalA*progress];
    toTitle.textColor = [UIColor colorWithRed:narR-detalR*progress green:narG-detalG*progress blue:narB-detalB*progress alpha:narA-detalA*progress];
}

- (void)stretchBottomLineFixedWidthFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
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

- (void)stretchBottomLineFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
    if (self.lineAinimationType == JCSlideBarLineAnimationStretchFixedWidth) {
        [self stretchBottomLineFixedWidthFromIndex:fromIndex toIndex:toIndex progress:progress];
    }else if (self.lineAinimationType == JCSlideBarLineAnimationStretchDynamicWidth) {
        [self stretchBottomLineDynamicWidthFromIndex:fromIndex toIndex:toIndex progress:progress];
    }
}

- (void)stretchBottomLineDynamicWidthFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
    NSString *curTitle = [self.dataSource pageContoller:_controller titleForCellAtIndex:fromIndex];
    NSString *nextTitle = [self.dataSource pageContoller:_controller titleForCellAtIndex:toIndex];
    CGFloat curWidth = [self boundingSizeWithString:curTitle font:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 40)].width;
    CGFloat nextWidth = [self boundingSizeWithString:nextTitle font:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 40)].width;
    
    CGRect nextCellRect = [self cellFrameAtIndex:toIndex];
    CGRect curCellRect = [self cellFrameAtIndex:fromIndex];
    
    CGRect curlineRect = CGRectMake(curCellRect.origin.x + curCellRect.size.width/2 - curWidth/2, self.line.frame.origin.y, curWidth, self.line.frame.size.height);
    CGRect nextlineRect = CGRectMake(nextCellRect.origin.x + nextCellRect.size.width/2 - nextWidth/2, self.line.frame.origin.y, nextWidth, self.line.frame.size.height);
    
    CGFloat originX = curlineRect.origin.x;
    CGFloat centerGap = (nextlineRect.origin.x + nextlineRect.size.width/2) - (curlineRect.origin.x + curlineRect.size.width/2);
    if (fromIndex < toIndex) {
        if (progress <= 0.5) {
            curlineRect.size.width = (centerGap + nextWidth/2 - curWidth/2)*(progress/0.5) +  curWidth;
        }else{
            CGFloat p = (progress-0.5)/0.5;
            curlineRect.size.width = centerGap + curWidth/2 + nextWidth/2 - (centerGap - nextWidth/2 + curWidth/2)*p;
            curlineRect.origin.x = originX + (centerGap - nextWidth/2 + curWidth/2) *p;
        }
    }else{
        centerGap = (curlineRect.origin.x + curlineRect.size.width/2) - (nextlineRect.origin.x + nextlineRect.size.width/2);
        if (progress <= 0.5) {
            CGFloat p = progress/0.5;
            curlineRect.size.width = curWidth + (centerGap - curWidth/2 + nextWidth/2 )*p;
            curlineRect.origin.x = originX - (centerGap - curWidth/2 + nextWidth/2) *p;
        }else{
            CGFloat p = (progress - 0.5 ) /0.5;
            curlineRect.size.width = centerGap + curWidth/2 + nextWidth/2 - (centerGap - nextWidth/2 + curWidth/2)*p;
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
    if (self.scaleSelectedBar) {
        if (self.curSelectIndex != indexPath.row) {
            UICollectionViewCell *fromCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.curSelectIndex inSection:0]];
            fromCell.transform = CGAffineTransformMakeScale(1 , 1);
        }
        UICollectionViewCell *toCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];
        toCell.transform = CGAffineTransformMakeScale(kSlideBarCellScaleSize , kSlideBarCellScaleSize);
    }
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
