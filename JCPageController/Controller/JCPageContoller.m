//
//  JCPageContoller.m
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "JCPageContoller.h"
#import "JCPageSlideBar.h"

@interface JCPageContoller () <UIScrollViewDelegate, JCPageSlideBarDelegate>

@property (nonatomic, strong) JCPageSlideBar *slideBar;
@property (nonatomic, strong) UIScrollView *contentView;           //controllers 容器
@property (nonatomic, strong) NSMutableDictionary *controllersMap; //用于保存controllers 用 @“index_identifier” 来当做key   value为controller
@property (nonatomic, strong) UIViewController *currentController;
@property (nonatomic, strong) UIViewController *nextController;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, assign) CGFloat lastOffsetX; //记录上一次位移，用于判断滑动方向
@property (nonatomic, assign) NSInteger selectBarIndex;  //记录用户点击的tabbar的索引，用于滚动结束后恢复页面真正位置
@property (nonatomic) BOOL isInteractionScroll;  //是否是用户手势操作
@property (nonatomic) BOOL didSelectBarToChangePage;  //用户点击了tabbar来切换页面

@end

@implementation JCPageContoller

- (CGFloat)width{
    return self.view.frame.size.width;
}

- (CGFloat)height{
    return self.view.frame.size.height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.controllersMap = [NSMutableDictionary dictionary];
}

- (JCPageSlideBar *)slideBar{
    if (!_slideBar) {
        _slideBar = [[JCPageSlideBar alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
        _slideBar.controller = self;
        _slideBar.delegate = self;
        [self.view addSubview:_slideBar];
    }
    return  _slideBar;
}

- (UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.slideBar.frame), self.width, self.height - CGRectGetMaxY(self.slideBar.frame))];
        _contentView.delegate = self;
        _contentView.pagingEnabled = YES;
        _contentView.scrollsToTop = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.alwaysBounceVertical = NO;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (void)setDataSource:(id<JCPageContollerDataSource>)dataSource{
    _dataSource = dataSource;
    self.slideBar.dataSource = dataSource;
}

- (void)reloadData{
    NSInteger count = [self.dataSource numberOfControllersInPageController];
    self.contentView.contentSize = CGSizeMake(count * self.width, self.contentView.frame.size.height);
    [self.slideBar reloadData];
    self.slideBar.lineAinimationType = self.lineAinimationType;
    self.currentIndex = 0;
    [self.slideBar moveBottomLineToIndex:self.currentIndex];
    [self.slideBar selectTabAtIndex:self.currentIndex];
    self.currentController = [self configControllerAtIndex:self.currentIndex];
    [self.delegate pageContoller:self didShowController:self.currentController atIndex:self.currentIndex];
}

- (void)saveController:(UIViewController *)controller atIndex:(NSInteger)index{
    if (!controller) {
        return;
    }
    NSString *identifier = [self.dataSource reuseIdentifierForControllerAtIndex:index];
    if (!identifier) {
        return;
    }
    //用 @“index_identifier” 来当做key
    NSString *key = [NSString stringWithFormat:@"%ld_%@",index,identifier];
    [self.controllersMap setObject:controller forKey:key];
}

- (UIViewController *)getControllerFromMap:(NSInteger)index{
    NSString *identifier = [self.dataSource reuseIdentifierForControllerAtIndex:index];
    if (!identifier) {
        return nil;
    }
    NSString *key = [NSString stringWithFormat:@"%ld_%@",index,identifier];
    UIViewController *vcl = [self.controllersMap objectForKey:key];
    return vcl;
}

- (UIViewController *)configControllerAtIndex:(NSInteger)index{
    NSInteger count = [self.dataSource numberOfControllersInPageController];
    if (index >= count || index < 0) {
        return nil;
    }
    UIViewController* controller = [self.dataSource pageContoller:self controllerAtIndex:index];
    if (!controller) {
        return nil;
    }
    CGRect rect = CGRectMake(index * self.width, 0, self.width, self.contentView.frame.size.height);
    if (!controller.parentViewController) {
        [self addChildViewController:controller];
        [self.contentView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
    }
    [self saveController:controller atIndex:index];
    controller.view.frame = rect;
    return controller;
}

- (UIViewController *)dequeueReusableControllerWithReuseIdentifier:(NSString *)identifier atIndex:(NSInteger)index{
    if (!identifier) {
        return nil;
    }
    NSInteger count = [self.dataSource numberOfControllersInPageController];
    if (index >= count || index < 0) {
        return nil;
    }
    UIViewController *controller = nil;
    NSString *findKey = nil;
    for (NSString *key in self.controllersMap) {
        NSArray *components = [key componentsSeparatedByString:@"_"];
        NSString *indexStr = components.firstObject;
        NSString *identifierStr = components.lastObject;
        NSInteger gap = labs(indexStr.integerValue - index);
        if (self.didSelectBarToChangePage) {
            //点击tabbar切换页面
            if ([identifier isEqualToString:identifierStr]) {
                if (self.currentIndex != indexStr.integerValue) {
                    controller = self.controllersMap[key];
                    findKey = key;
                    break;
                }
            }
        }else{
            //手势滑动切换页面
            if ([identifier isEqualToString:identifierStr] && gap > 1) {
                controller = self.controllersMap[key];
                findKey = key;
                break;
            }
        }
    }
    if (findKey) {
        if ([controller respondsToSelector:@selector(prepareForReuse)]) {
            [controller performSelector:@selector(prepareForReuse)];
        }
        [self.controllersMap removeObjectForKey:findKey];
    }else{
        if ([self getControllerFromMap:index]) {
            controller = [self getControllerFromMap:index];
        }
    }
    return controller;
}

- (UIViewController *)willDraggingToNextController:(NSInteger)nextIndex{
    UIViewController *nextController = [self configControllerAtIndex:nextIndex];
    if (nextController) {
        self.nextIndex = nextIndex;
        self.nextController = nextController;
    }
    return nextController;
}

#pragma mark
#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (!self.isInteractionScroll) {
        return;
    }
    
    if (contentOffsetX < 0) {
        [self.slideBar selectTabAtIndex:0];
        return;
    }
    CGFloat curControllerOriginX = self.currentIndex * self.contentView.frame.size.width;
    NSInteger page = contentOffsetX / self.contentView.frame.size.width;
    NSInteger nextPage = -1;
    NSInteger totalCount = [self.dataSource numberOfControllersInPageController];
    
    BOOL scrollToRight = YES;
    if (contentOffsetX - self.lastOffsetX > 0) {
        if (contentOffsetX <= curControllerOriginX) {
            return;
        }
        //向右滑
        nextPage = page < totalCount - 1 ? page + 1 : totalCount - 1;
    }else{
        if (contentOffsetX >= curControllerOriginX) {
            return;
        }
        //向坐滑
        scrollToRight = NO;
        page = page < totalCount - 1 ? page+1 : totalCount-1;
        nextPage = page > 0 ? page - 1 : 0;
    }
    self.lastOffsetX = contentOffsetX;
    
    if (self.currentIndex != page) {
        self.currentIndex = page;
        self.currentController = self.nextController;
        [self.slideBar selectTabAtIndex:self.currentIndex];
    }
    BOOL needConfigNextPage = NO;
    if (scrollToRight) {
        if (contentOffsetX > self.currentIndex * self.contentView.frame.size.width) {
            needConfigNextPage = YES;
        }
    }else{
        if (contentOffsetX < self.currentIndex * self.contentView.frame.size.width) {
            needConfigNextPage = YES;
        }
    }
    
    if (needConfigNextPage && self.nextIndex != nextPage) {
        [self willDraggingToNextController:nextPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //手势切换页面结束
    NSInteger page = scrollView.contentOffset.x / self.contentView.frame.size.width;
    [self.slideBar selectTabAtIndex:page];
    self.currentIndex = page;
    self.isInteractionScroll = NO;
    self.didSelectBarToChangePage = NO;
    self.selectBarIndex = -1;
    self.lastOffsetX = scrollView.contentOffset.x;
    self.contentView.userInteractionEnabled = YES;
    [self.slideBar moveBottomLineToIndex:self.currentIndex];
    [self.delegate pageContoller:self didShowController:self.currentController atIndex:self.currentIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.didSelectBarToChangePage) {
        //点击tab 切换页面结束 恢复 self.currentController 真正位置
        self.didSelectBarToChangePage = NO;
        self.currentIndex = self.selectBarIndex;
        [self.slideBar selectTabAtIndex:self.currentIndex];
        CGRect rect = self.currentController.view.frame;
        rect.origin.x = self.currentIndex * self.contentView.frame.size.width;
        self.currentController.view.frame = rect;
        [self.contentView setContentOffset:CGPointMake(rect.origin.x, 0)animated:NO];
    }
    self.selectBarIndex = -1;
    self.lastOffsetX = scrollView.contentOffset.x;
    self.contentView.userInteractionEnabled = YES;
    [self.slideBar moveBottomLineToIndex:self.currentIndex];
    [self.delegate pageContoller:self didShowController:self.currentController atIndex:self.currentIndex];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isInteractionScroll = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.isInteractionScroll = NO;
    }
    self.contentView.userInteractionEnabled = YES;
}

#pragma mark
#pragma mark -- JCPageSlideBarDelegate
- (void)pageSlideBar:(JCPageSlideBar *)pageSlideBar didSelectBarAtIndex:(NSInteger)index{
    if (self.currentIndex == index) {
        return;
    }
    if (self.didSelectBarToChangePage) {
        return;
    }
    if (self.isInteractionScroll) {
        //正在手势滑动
        return;
    }
    self.didSelectBarToChangePage = YES;
    self.selectBarIndex = index;
    NSInteger realIndex = self.currentIndex < index ?  self.currentIndex + 1 : self.currentIndex - 1;
    UIViewController *nextVCL = [self willDraggingToNextController:index];
    if (nextVCL) {
        //将nextVCL 放在相邻位置上，待滚动结束后在恢复真正位置
        self.contentView.userInteractionEnabled = NO;//滚动期间 不允许用户手势操作
        self.currentController = nextVCL;
        CGRect rect = nextVCL.view.frame;
        rect.origin.x = realIndex * self.contentView.frame.size.width;
        nextVCL.view.frame = rect;
    }
    [self.contentView setContentOffset:CGPointMake(realIndex * self.contentView.frame.size.width,0) animated:YES];
}




@end
