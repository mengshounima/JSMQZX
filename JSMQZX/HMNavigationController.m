//
//  HMNavigationController.m
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMNavigationController.h"
#import "PicViewController.h"
@interface HMNavigationController ()<UIActionSheetDelegate>

@end

@implementation HMNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/**
 *  当导航控制器的view创建完毕就调用
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

/**
 *  当第一次使用这个类的时候调用1次
 */
+ (void)initialize
{
    // 设置UINavigationBarTheme的主
    [self setupNavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 设置导航栏背景
    appearance.barTintColor = choiceColor(123, 0, 15);
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
    textAttrs[UITextAttributeFont] = [UIFont boldSystemFontOfSize:20];
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs];
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:15];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
   /* NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[UITextAttributeTextColor] = [UIColor grayColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[UITextAttributeTextColor] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
    [appearance setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];*/
}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"返回" highImageName:@"返回-选中" target:self action:@selector(back)];
        //右上角设置按钮
    
    if ([viewController isKindOfClass:[PicViewController class]]) {
        
    }
    else
    {
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"设置" highImageName:@"设置-灰" target:self action:@selector(Setting)];
    }
    
    //}
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
#warning 这里用的是self, 因为self就是当前正在使用的导航控制器
    [self popViewControllerAnimated:YES];
}

- (void)Setting
{
    //弹出设置框
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.frame = [UIScreen mainScreen].bounds;
    }
    
    if (_setView == nil) {
        _setView = [SetView sharedSetView];
        _setView.delegate = self;
        _setView.frame = CGRectMake(SCREEN_WIDTH, 64, 100, 200);
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backView];//加上第一个蒙版
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackCancel:)];
    
    [_backView addGestureRecognizer:tap];
    [window addSubview:_setView];
    [UIView animateWithDuration:0.1 animations:^{
        _setView.frame = CGRectMake(SCREEN_WIDTH-100, 64, 100, 200);
        _backView.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:0.5];
    } completion:^(BOOL finished) {
    }];
}

-(void)clickBackCancel:(UIGestureRecognizer *)gesture
{
    [self Cancel];
}
#pragma mark
- (void)Cancel
{
    [UIView animateWithDuration:0.1 animations:^{
        _backView.backgroundColor = [UIColor colorWithRed:238 green:238 blue:238 alpha:0];
        
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        [_setView removeFromSuperview];
    }];
}
-(void)SetViewClose{
    //关闭
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"注销用户提示" message:@"是否确认关闭嘉善县民生在线客户端?如需注销账号请选择注销用户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"关闭",nil];
    alert.tag = 100;
    [alert show];

}
-(void)SetViewHelp{
    
}                                                                                                                                                                                                                                                                                                                                                                      
-(void)SetViewSignUp{
    //注销
   UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"注销用户提示" message:@"是否确认注销当前登录用户，注销后下次登录必须重新输入用户名和密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"注销",nil];
    alert.tag = 101;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        //关闭
        if (buttonIndex == 1) {
        [self exitApplication];
        }
    }
    else{
        if (buttonIndex == 1) {
            [USERDEFAULTS setObject:[NSNumber numberWithBool:NO] forKey:@"IsLogin"];//将记住的账号清除
            [self exitApplication];
        }

    }
    [self Cancel];
}
- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}


- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}

-(void)SetViewUser{
    UserInfoTableVC *userVC = [[UserInfoTableVC alloc] init];
    [self Cancel];
    [self pushViewController:userVC animated:YES];
}
@end
