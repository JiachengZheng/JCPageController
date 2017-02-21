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

@interface JCPageContoller ()
@property (nonatomic, strong) JCPageSlideBar *slideBar;
@property (nonatomic, strong) JCPageSlideContentView *contentView;
@property (nonatomic, strong) NSMutableDictionary *controllersMap;
@property (nonatomic, strong) UIViewController *currentController;
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
    [self scrollToPageAtIndex:0];
}

- (void)scrollToPageAtIndex:(NSInteger)index{
    UIViewController *controller = [self.dataSource pageContoller:self controllerAtIndex:index];
    if (!controller) {
        return;
    }
    if (!controller.parentViewController) {
        controller.view.frame = self.contentView.bounds;
        [self addChildViewController:controller];
        [self.contentView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        NSString *identifier = [self.dataSource reuseIdentifierForControllerAtIndex:index];
        if (!identifier) {
            identifier = @"";
        }
        NSMutableSet *set = [self.controllersMap objectForKey:identifier];
        if (set) {
            [set addObject:controller];
        }else{
            NSMutableSet *set = [NSMutableSet setWithObjects:controller, nil];
            [self.controllersMap setObject:set forKey:identifier];
        }
    }else{
        controller.view.frame = self.contentView.bounds;
    }
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




@end
