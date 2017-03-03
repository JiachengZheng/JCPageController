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
        _pageController.scaleSelectedBar = self.scaleSelectedBar;
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

- (UIViewController *)pageContoller:(JCPageContoller *)pageContoller controllerAtIndex:(NSInteger)index{
    DemoBarItem *item = self.model.barItems[index];
    UIViewController *controller = [pageContoller dequeueReusableControllerWithReuseIdentifier:item.identifier atIndex:index];
    if (!controller) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         TestViewController *testController = [mainStoryboard instantiateViewControllerWithIdentifier:@"TestViewController"];
        controller = testController;
        
        CGRect rect = self.pageController.view.bounds;
        rect.origin.y = 40;//slideBar height
        rect.size.height = rect.size.height - rect.origin.y;
        testController.view.frame = rect;//这里的frame就是象征性设置下，为了调用testController viewDidLoad，之后还会重新设置frame，有待改进
    }
    TestViewController *testVCL = (TestViewController *)controller;
    [testVCL reloadData:item];
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
