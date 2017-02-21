//
//  Demo1PageController.m
//  JCPageControllerDemo
//
//  Created by zhengjiacheng on 2017/2/21.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "Demo1PageController.h"
#import "Demo1Model.h"
#import "Demo1BarItem.h"
#import "JCPageContoller.h"

#define kRandomColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:arc4random()%255/255.0];

@interface Demo1PageController () <JCPageContollerDataSource, JCPageContollerDelegate>
@property (nonatomic, strong) Demo1Model *model;
@property (nonatomic, strong) JCPageContoller *pageController;
@end

@implementation Demo1PageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [Demo1Model new];
    self.pageController.view.frame = self.view.bounds;
    [self loadItems];
    // Do any additional setup after loading the view.
}

- (void)loadItems{
    __weak typeof(self) instance = self;
    [self.model loadItems:nil completion:^(NSDictionary *dic) {
        [instance.pageController reloadData];
    }];
}

- (JCPageContoller *)pageController{
    if (!_pageController) {
        _pageController = [[JCPageContoller alloc]init];
        _pageController.delegate = self;
        _pageController.dataSource = self;
        [self addChildViewController:_pageController];
        [self.view addSubview:_pageController.view];
    }
    return _pageController;
}

- (NSInteger)numberOfControllersInPageController{
    return self.model.barItems.count;
}

- (NSString *)reuseIdentifierForControllerAtIndex:(NSInteger)index;{
    Demo1BarItem *item = self.model.barItems[index];
    return @"1";//item.identifier;
}

- (UIViewController *)testController{
    UIViewController *testController = [[UIViewController alloc]init];
    UILabel *label = [[UILabel alloc]initWithFrame:testController.view.bounds];
    [testController.view addSubview:label];
    label.font = [UIFont systemFontOfSize:19];
    testController.view.backgroundColor = kRandomColor;
    label.tag = 2000;
    label.textAlignment = NSTextAlignmentCenter;
    return testController;
}

- (UIViewController *)pageContoller:(JCPageContoller *)pageContoller controllerAtIndex:(NSInteger)index{
    Demo1BarItem *item = self.model.barItems[index];
    UIViewController *controller = [pageContoller dequeueReusableControllerWithReuseIdentifier:@"1"];
    if (!controller) {
        controller = self.testController;
    }
    UILabel *label = [controller.view viewWithTag:2000];
    label.text = [NSString stringWithFormat:@"page%ld",index];
    return controller;
}

- (CGFloat)pageContoller:(JCPageContoller *)pageContoller widthForCellAtIndex:(NSInteger )index{
    Demo1BarItem *item = self.model.barItems[index];
    return item.width;
}

- (NSString *)pageContoller:(JCPageContoller *)pageContoller titleForCellAtIndex:(NSInteger)index{
    Demo1BarItem *item = self.model.barItems[index];
    return item.text;
}

@end
