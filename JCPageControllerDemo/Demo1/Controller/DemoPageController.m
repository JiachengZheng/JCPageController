//
//  DemoPageController.m
//  JCPageControllerDemo
//
//  Created by zhengjiacheng on 2017/2/21.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "DemoPageController.h"
#import "DemoModel.h"
#import "DemoBarItem.h"

#import "TestViewController.h"

#define kRandomColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:arc4random()%255/255.0];

@interface DemoPageController () <JCPageContollerDataSource, JCPageContollerDelegate>
@property (nonatomic, strong) DemoModel *model;
@property (nonatomic, strong) JCPageContoller *pageController;
@end

@implementation DemoPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.model = [DemoModel new];
    CGRect rect = self.view.bounds;
    rect.origin.y = 64;
    rect.size.height = rect.size.height - 64;
    self.pageController.view.frame = rect;
    [self loadItems];
    // Do any additional setup after loading the view.
}

- (void)loadItems{
    __weak typeof(self) instance = self;
    NSDictionary *dic = @{@"needReuse":@(self.needReuse)};
    [self.model loadItems:dic completion:^(NSDictionary *dic) {
        [instance.pageController reloadData];
    }];
}

- (JCPageContoller *)pageController{
    if (!_pageController) {
        _pageController = [[JCPageContoller alloc]init];
        _pageController.delegate = self;
        _pageController.lineAinimationType = self.lineAinimationType;
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
    DemoBarItem *item = self.model.barItems[index];
    return item.identifier;
}

- (UIViewController *)testController{
    TestViewController *testController = [[TestViewController alloc]init];
    UILabel *label = [[UILabel alloc]initWithFrame:testController.view.bounds];
    [testController.view addSubview:label];
    label.font = [UIFont systemFontOfSize:18];
    testController.view.backgroundColor = kRandomColor;
    label.tag = 2000;
    label.textAlignment = NSTextAlignmentCenter;
    return testController;
}

- (UIViewController *)pageContoller:(JCPageContoller *)pageContoller controllerAtIndex:(NSInteger)index{
    DemoBarItem *item = self.model.barItems[index];
    UIViewController *controller = [pageContoller dequeueReusableControllerWithReuseIdentifier:item.identifier atIndex:index];
    if (!controller) {
        controller = self.testController;
    }
    UILabel *label = [controller.view viewWithTag:2000];
    label.text = item.text;
    return controller;
}

- (CGFloat)pageContoller:(JCPageContoller *)pageContoller widthForCellAtIndex:(NSInteger )index{
    DemoBarItem *item = self.model.barItems[index];
    return item.width;
}

- (NSString *)pageContoller:(JCPageContoller *)pageContoller titleForCellAtIndex:(NSInteger)index{
    DemoBarItem *item = self.model.barItems[index];
    return item.text;
}

- (void)pageContoller:(JCPageContoller *)pageContoller didShowController:(UIViewController *)controller atIndex:(NSInteger)index{
//    NSLog(@"page %ld did show",index);
}

@end
