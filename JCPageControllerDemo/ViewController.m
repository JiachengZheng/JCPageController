//
//  ViewController.m
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "ViewController.h"
#import "JCPageContoller.h"
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Demo%ld",indexPath.row + 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *pageController = [mainStoryboard instantiateViewControllerWithIdentifier:@"Demo1PageController"];
    pageController.title = [NSString stringWithFormat:@"Demo%ld",indexPath.row];
    [self.navigationController pushViewController:pageController animated:YES];
}


@end
