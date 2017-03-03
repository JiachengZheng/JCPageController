//
//  TestViewController.m
//  JCPageControllerDemo
//
//  Created by zhengjiacheng on 2017/2/23.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "TestViewController.h"
#import "DemoPageController.h"
@interface TestViewController ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@end

@implementation TestViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label = ({
        UILabel *label = [[UILabel alloc]initWithFrame:self.view.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor blackColor];
        label;
    });    
    [self.view addSubview:self.label];
    
    self.button= ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 40);
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn;
    });
    [self.view addSubview:self.button];
    
    self.view.backgroundColor = kRandomColor;
       // Do any additional setup after loading the view.
}

- (void)prepareForReuse{
    //重用
    self.label.text = @"";
//    NSLog(@"%@ 执行 prepareForReuse",self);
}

- (void)reloadData:(DemoBarItem *)item{
    if (!item) {
        return;
    }
    self.label.text = item.text;
    if (item.index % 2 == 0) {
        self.button.hidden = YES;
    }else{
        self.button.hidden = NO;
        [self.button setTitle:item.text forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
