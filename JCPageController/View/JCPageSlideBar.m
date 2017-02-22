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

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.colletionViewLayout];
        _collectionView.delegate = self;
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

- (void)reloadData{
    [self.collectionView reloadData];
}

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
}

@end
