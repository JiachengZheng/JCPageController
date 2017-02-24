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
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *widthSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *reuseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stretchSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *scaleSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Demo";
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushDemoController:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DemoPageController *pageController = [mainStoryboard instantiateViewControllerWithIdentifier:@"DemoPageController"];
    pageController.title = @"Demo";
    pageController.needReuse = self.reuseSwitch.on;
    JCSlideBarLineAnimationType type = JCSlideBarLineAnimationFixedWidth;
    if(self.widthSwitch.on){
        if (self.stretchSwitch.on) {
            type = JCSlideBarLineAnimationStretchDynamicWidth;
        }else{
            type = JCSlideBarLineAnimationDynamicWidth;
        }
    }else{
        if (self.stretchSwitch.on) {
            type = JCSlideBarLineAnimationStretchFixedWidth;
        }else{
            type = JCSlideBarLineAnimationFixedWidth;
        }
    }
    pageController.scaleSelectedBar = self.scaleSwitch.on;
    pageController.lineAinimationType = type;
    [self.navigationController pushViewController:pageController animated:YES];
}



@end
