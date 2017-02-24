# JCPageController

page scroll View controller 水平滚动页面控制器

# CocoaPods

```
pod 'JCPageController'
```

# ScreenShot

![](https://github.com/JiachengZheng/JCPageController/blob/master/JCPageControllerDemo/demo.gif)

#Datasource and delegate

```
@protocol JCPageContollerDataSource <NSObject>

@required
// return number of subControllers
- (NSInteger)numberOfControllersInPageController;

// return each viewController
- (UIViewController *)pageContoller:(JCPageContoller *)pageContoller controllerAtIndex:(NSInteger)index;

// return each bar width
- (CGFloat)pageContoller:(JCPageContoller *)pageContoller widthForCellAtIndex:(NSInteger)index;

// return each controller reuse identifier
- (NSString *)reuseIdentifierForControllerAtIndex:(NSInteger)index;

@optional
// return each bar title
- (NSString *)pageContoller:(JCPageContoller *)pageContoller titleForCellAtIndex:(NSInteger)index;

@optional

@end

@protocol JCPageContollerDelegate <NSObject>

@optional
- (void)pageContoller:(JCPageContoller *)pageContoller didShowController:(UIViewController *)controller atIndex:(NSInteger)index;

@end
```

#Demo

```
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
    return count;
}

- (NSString *)reuseIdentifierForControllerAtIndex:(NSInteger)index;{
    return identifier;
}

- (UIViewController *)pageContoller:(JCPageContoller *)pageContoller controllerAtIndex:(NSInteger)index{
    UIViewController *controller = [pageContoller dequeueReusableControllerWithReuseIdentifier:identifier atIndex:index];
    if (!controller) {
        //controller init
    }
    return controller;
}

- (CGFloat)pageContoller:(JCPageContoller *)pageContoller widthForCellAtIndex:(NSInteger )index{
    return width;
}

- (NSString *)pageContoller:(JCPageContoller *)pageContoller titleForCellAtIndex:(NSInteger)index{
    return text;
}


```


# About Me

QQ:1083841067

Email:jiacheng_zheng@163.com

如果你发现bug，please pull reqeust me 

如果你有更好的改进，please pull reqeust me 
