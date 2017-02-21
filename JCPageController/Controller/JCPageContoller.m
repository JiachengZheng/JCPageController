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
@property (nonatomic, strong) UIViewController *nextController;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger nextIndex;
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
    NSMutableSet *set = [self.controllersMap objectForKey:identifier];
    if (set) {
        [set addObject:controller];
    }else{
        NSMutableSet *set = [NSMutableSet setWithObjects:controller, nil];
        [self.controllersMap setObject:set forKey:identifier];
    }
}

- (UIViewController *)configControllerAtIndex:(NSInteger)index{
    NSInteger count = [self.dataSource numberOfControllersInPageController];
    if (index >= count || index < 0) {
        return nil;
    }
    
    UIViewController *controller = [self.dataSource pageContoller:self controllerAtIndex:index];
    if (!controller) {
        return nil;
    }
//    NSLog(@"正在配置index 为 %ld 的controller",index);
    CGRect rect = CGRectMake(index * self.width, 0, self.width, self.contentView.frame.size.height);
    if (!controller.parentViewController) {
        [self addChildViewController:controller];
        [self.contentView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        [self saveController:controller atIndex:index];
    }
    controller.view.frame = rect;
    return controller;
}

- (UIViewController *)dequeueReusableControllerWithReuseIdentifier:(NSString *)identifier{
    if (!identifier) {
        return nil;
    }
    NSMutableSet *set = [self.controllersMap objectForKey:identifier];
    if (!set) {
        return nil;
    }
    UIViewController *controller = nil;
    for (UIViewController *obj in set) {
        if (obj != self.currentController) {
            controller = obj;
            break;
        }
    }
    return controller;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat curControllerOffset = self.currentIndex * self.width;
    if (scrollView.contentOffset.x < 0) {
        return;
    }
    NSInteger page = scrollView.contentOffset.x / self.width;

    if (scrollView.contentOffset.x > curControllerOffset) {
        //right
        [self willDraggingToNextController:page+1];
    }else if (scrollView.contentOffset.x < curControllerOffset) {
        //left
        [self willDraggingToNextController:page];
    }
}

- (void)willDraggingToNextController:(NSInteger)nextIndex{
    if (nextIndex == self.nextIndex) {
        return;
    }
    
    UIViewController *nextController = [self configControllerAtIndex:nextIndex];
    if (nextController) {
        self.nextController = nextController;
        self.nextIndex = nextIndex;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / self.width;
    self.currentIndex = page;
    self.currentController = self.nextController;
    [self.slideBar selectTabAtIndex:self.currentIndex];
}






@end
