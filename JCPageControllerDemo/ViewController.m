//
//  ViewController.m
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "ViewController.h"
#import "JCPageContoller.h"
#import "DemoPageController.h"
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Demo";
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];
    
    NSString *title = @"";
    if (indexPath.row == 0) {
        title = @"固定宽度，不重用";
    }
    if (indexPath.row == 1) {
        title = @"动态文字宽度，重用";
    }
    if (indexPath.row == 2) {
        title = @"固定宽度，重用，拉伸效果";
    }
    if (indexPath.row == 3) {
        title = @"动态宽度，重用，拉伸效果";
    }
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DemoPageController *pageController = [mainStoryboard instantiateViewControllerWithIdentifier:@"DemoPageController"];
    if (indexPath.row == 0) {
        pageController.needReuse = NO;
        pageController.lineAinimationType = JCSlideBarLineAnimationFixedWidth;
    }
    if (indexPath.row == 1) {
        pageController.needReuse = YES;
        pageController.lineAinimationType = JCSlideBarLineAnimationDynamicWidth;
    }
    if (indexPath.row == 2) {
        pageController.needReuse = YES;
        pageController.lineAinimationType = JCSlideBarLineAnimationStretchFixedWidth;
    }
    if (indexPath.row == 3) {
        pageController.needReuse = YES;
        pageController.lineAinimationType = JCSlideBarLineAnimationStretchDynamicWidth;
    }
    pageController.title = @"Demo";
    [self.navigationController pushViewController:pageController animated:YES];
}


@end
