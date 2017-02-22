//
//  JCPageContoller.m
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "JCPageContoller.h"
#import "JCPageSlideBar.h"
#import "JCPageSlideContentView.h"

@interface JCPageContoller () <UIScrollViewDelegate>
@property (nonatomic, strong) JCPageSlideBar *slideBar;
@property (nonatomic, strong) JCPageSlideContentView *contentView;
@property (nonatomic, strong) NSMutableDictionary *controllersMap;
@property (nonatomic, strong) UIViewController *currentController;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, assign) CGFloat lastOffsetX;
@property (nonatomic) BOOL isInteractionScroll;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.controllersMap = [NSMutableDictionary dictionary];
}

- (JCPageSlideBar *)slideBar{
    if (!_slideBar) {
        _slideBar = [[JCPageSlideBar alloc]initWithFrame:CGRectMake(0, 64, self.width, 37)];
        _slideBar.controller = self;
        [self.view addSubview:_slideBar];
    }
    return  _slideBar;
}

- (JCPageSlideContentView *)contentView{
    if (!_contentView) {
        _contentView = [[JCPageSlideContentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.slideBar.frame), self.width, self.height - CGRectGetMaxY(self.slideBar.frame))];
        _contentView.delegate = self;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (void)setDataSource:(id<JCPageContollerDataSource>)dataSource{
    _dataSource = dataSource;
    self.slideBar.dataSource = dataSource;
}

- (void)reloadData{
    [self.slideBar reloadData];
    NSInteger count = [self.dataSource numberOfControllersInPageController];
    self.contentView.contentSize = CGSizeMake(count * self.width, self.contentView.frame.size.height);
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
        if ([identifier isEqualToString:identifierStr] && gap > 1) {
            controller = self.controllersMap[key];
            findKey = key;
            break;
        }
    }
    if (findKey) {
        [self.controllersMap removeObjectForKey:findKey];
    }
    return controller;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.isInteractionScroll) {
        return;
    }
    
    if (scrollView.contentOffset.x < 0) {
        [self.slideBar selectTabAtIndex:0];
        return;
    }
    NSInteger page = scrollView.contentOffset.x / self.contentView.frame.size.width;
    NSInteger nextPage = -1;
    NSInteger totalCount = [self.dataSource numberOfControllersInPageController];
    if (scrollView.contentOffset.x - self.lastOffsetX > 0) {
        if (scrollView.contentOffset.x <= self.currentController.view.frame.origin.x) {
            return;
        }
        nextPage = page < totalCount - 1 ? page + 1 : totalCount - 1;
    }else{
        if (scrollView.contentOffset.x >= self.currentController.view.frame.origin.x) {
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
    self.isInteractionScroll = NO;
}

- (void)willDraggingToNextController:(NSInteger)nextIndex{
    UIViewController *nextController = [self configControllerAtIndex:nextIndex];
    if (nextController) {
        self.nextIndex = nextIndex;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isInteractionScroll = YES;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.isInteractionScroll = NO;
    }
}


@end
