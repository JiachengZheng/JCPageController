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
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) NSMutableDictionary *controllersMap;
@property (nonatomic, strong) UIViewController *currentController;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, assign) CGFloat lastOffsetX;
@property (nonatomic) BOOL isInteractionScroll;
@property (nonatomic) BOOL didSelectBarToChangePage;
@property (nonatomic, assign) NSInteger selectBarIndex;
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
    self.currentIndex = 0;
    [self.slideBar selectTabAtIndex:self.currentIndex];
    UIViewController *controller = [self configControllerAtIndex:self.currentIndex];
    if (controller) {
        self.currentController = controller;
    }
}

- (void)saveController:(UIViewController *)controller atIndex:(NSInteger)index{
    if (!controller) {
        return;
    }
    NSString *identifier = [self.dataSource reuseIdentifierForControllerAtIndex:index];
    if (!identifier) {
        return;
    }
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
    UIViewController *controller = [self getControllerFromMap:index];
    if (!controller){
        controller = [self.dataSource pageContoller:self controllerAtIndex:index];
        if (!controller) {
            return nil;
        }
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
        [self.controllersMap removeObjectForKey:findKey];
    }
    return controller;
}

- (UIViewController *)willDraggingToNextController:(NSInteger)nextIndex{
    UIViewController *nextController = [self configControllerAtIndex:nextIndex];
    if (nextController) {
        self.nextIndex = nextIndex;
    }
    return nextController;
}

#pragma mark
#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.isInteractionScroll) {
        return;
    }
    
    if (scrollView.contentOffset.x < 0) {
        [self.slideBar selectTabAtIndex:0];
        return;
    }
    CGFloat curControllerOriginX = self.currentIndex * self.contentView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / self.contentView.frame.size.width;
    NSInteger nextPage = -1;
    NSInteger totalCount = [self.dataSource numberOfControllersInPageController];
    if (scrollView.contentOffset.x - self.lastOffsetX > 0) {
        if (scrollView.contentOffset.x <= curControllerOriginX) {
            return;
        }
        nextPage = page < totalCount - 1 ? page + 1 : totalCount - 1;
    }else{
        if (scrollView.contentOffset.x >= curControllerOriginX) {
            return;
        }
        page = page < totalCount - 1 ? page+1 : totalCount-1;
        nextPage = page > 0 ? page - 1 : 0;
    }
    self.lastOffsetX = scrollView.contentOffset.x;
    
    if (self.currentIndex != page) {
        self.currentIndex = page;
        self.currentController = [self configControllerAtIndex:self.currentIndex];
        [self.slideBar selectTabAtIndex:self.currentIndex];
    }
    
    if (self.nextIndex != nextPage) {
        [self willDraggingToNextController:nextPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / self.contentView.frame.size.width;
    [self.slideBar selectTabAtIndex:page];
    self.currentIndex = page;
    self.isInteractionScroll = NO;
    self.didSelectBarToChangePage = NO;
    self.selectBarIndex = -1;
    self.lastOffsetX = scrollView.contentOffset.x;
    self.contentView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.didSelectBarToChangePage) {
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
        return;
    }
    self.didSelectBarToChangePage = YES;
    self.selectBarIndex = index;
    NSInteger realIndex = self.currentIndex < index ?  self.currentIndex + 1 : self.currentIndex - 1;
    UIViewController *nextVCL = [self willDraggingToNextController:index];
    if (nextVCL) {
        self.contentView.userInteractionEnabled = NO;
        self.currentController = nextVCL;
        CGRect rect = nextVCL.view.frame;
        rect.origin.x = realIndex * self.contentView.frame.size.width;
        nextVCL.view.frame = rect;
    }
    [self.contentView setContentOffset:CGPointMake(realIndex * self.contentView.frame.size.width,0) animated:YES];
}




@end
