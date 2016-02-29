//
//  RootVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/6.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "RootVC.h"
#import "HMTitleButton.h"
#import "GuanliLogTableVC.h"
@interface RootVC ()

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //test
    /*NSDate *nowDate = [NSDate date] ;
    NSTimeInterval timeStamp= [nowDate timeIntervalSince1970];//当前日期转化为毫秒数,用作图片名称
    NSTimeInterval timeStampIN = timeStamp*1000000;
    MyLog(@"%lld",(long long)timeStampIN);*/
    [self initView];
}
-(void)initView{
    _mingqingrizhi.titleLabel.textAlignment = NSTextAlignmentCenter;
    _rizhibanli.titleLabel.textAlignment = NSTextAlignmentCenter;
    _ganburizhibanli.titleLabel.textAlignment = NSTextAlignmentCenter;
    _ganbuzaizhidangyuan.titleLabel.textAlignment = NSTextAlignmentCenter;
    _ganbumingshengdongtai.titleLabel.textAlignment = NSTextAlignmentCenter;
    _ganbufenxiyanpan.titleLabel.textAlignment = NSTextAlignmentCenter;
    _guanlirizhibanli.titleLabel.textAlignment = NSTextAlignmentCenter;
    _guanlizaizhidangyuan.titleLabel.textAlignment = NSTextAlignmentCenter;
    _guanlimingshendongtai.titleLabel.textAlignment = NSTextAlignmentCenter;
    _guanlizhiyuanfuwu.titleLabel.textAlignment = NSTextAlignmentCenter;
    _guanliweixinyuan.titleLabel.textAlignment = NSTextAlignmentCenter;
    _guanlidangdaibiao.titleLabel.textAlignment = NSTextAlignmentCenter;
    _guanlifenxiyanpan.titleLabel.textAlignment = NSTextAlignmentCenter;
    _guanlidangjianhongyun.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *powerStr = [NSString stringWithFormat:@"%@",[[DataCenter sharedInstance] ReadData].UserInfo.power];
   
      if ([powerStr isEqualToString:@"6"]||[powerStr isEqualToString:@"4"]) {
        //两个按钮
        MyLog(@"一般用户");
        _yonghuView.hidden = NO;
        _ganbuView.hidden = YES;
        _guanliyuanView.hidden = YES;
        
    }
    else if([powerStr isEqualToString:@"3"]){
         MyLog(@"镇干部");
        _yonghuView.hidden = YES;
        _ganbuView.hidden = NO;
        _guanliyuanView.hidden = YES;
    }
    else if([powerStr isEqualToString:@"1"])
    {
        MyLog(@"管理员");
        _yonghuView.hidden = YES;
        _ganbuView.hidden = YES;
        _guanliyuanView.hidden = NO;
    }

    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*if ([segue.identifier isEqualToString:@"RootNormalToMinQinRiZhi"]) {
        MinQinRiZhiTableVC *minqin = segue.destinationViewController;
    }
    */
}

//民情日志
- (IBAction)clickminqingrizhi:(id)sender {
    [self performSegueWithIdentifier:@"RootNormalToMinQinRiZhi" sender:nil];
}
//日志办理
- (IBAction)clickrizhibanli:(id)sender {
    [self performSegueWithIdentifier:@"RootNormalToRiZhiBanLi" sender:nil];
}



//干部在职党员
- (IBAction)clickGanbuZaizhidangyuan:(id)sender {
     [self performSegueWithIdentifier:@"GanbuRootToZaizhiDangyuan" sender:nil];
    
}
//干部日志办理
- (IBAction)clickGanbuRizhibanli:(id)sender {
    [self performSegueWithIdentifier:@"RootToLogBanliFGanbu" sender:nil];
    
}
//干部 民生动态
- (IBAction)clickGanbuMinshendongtai:(id)sender {
    [self performSegueWithIdentifier:@"GanbuRootToMessageBoard" sender:nil];
}
//干部 分析研判
- (IBAction)clickGanbuFenxiyanpan:(id)sender {
    [self performSegueWithIdentifier:@"RootNormalToFenxiYanpan" sender:nil];
    
}

//管理员 日志办理
- (IBAction)clickGanliyuanRizhibanli:(id)sender {
     [self performSegueWithIdentifier:@"RootToGuanliyuanLogTable" sender:nil];
    
}




//管理员 在职党员
- (IBAction)clickGuanliyuanZaizhidangyuan:(id)sender {
   
     [self performSegueWithIdentifier:@"GanbuRootToZaizhiDangyuan" sender:nil];
}
//管理员 民生动态
- (IBAction)clickGaunliyuanMinshendongtai:(id)sender {
    [self performSegueWithIdentifier:@"GanbuRootToMessageBoard" sender:nil];
}
//管理员 志愿服务
- (IBAction)clickGuanliyuanFuwu:(id)sender {
     [self performSegueWithIdentifier:@"GuanliyuanRootToZhiyuanfuwu" sender:nil];
    
}
//管理员 微心愿
- (IBAction)clickGaunliyuanWeixinyuan:(id)sender {
     [self performSegueWithIdentifier:@"GaunliyuanRootToWeixinyuan" sender:nil];
    
}
//管理员  党代表接待日
- (IBAction)clickGaunliyuanDangdaibiao:(id)sender {
    [self performSegueWithIdentifier:@"GuanliyaunRootToDangdaibiao" sender:nil];
    
}
//管理员 分析研判
- (IBAction)clickGaunliyuanFenxi:(id)sender {
     [self performSegueWithIdentifier:@"RootNormalToFenxiYanpan" sender:nil];
}

//红云
- (IBAction)clickGaunliyuanHongyun:(id)sender {
     [self performSegueWithIdentifier:@"RootToHongyun" sender:nil];
}
//设置按钮
- (IBAction)clickRightBar:(id)sender {
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
    NSNumber *power = [[DataCenter sharedInstance] ReadData].UserInfo.power;
    HelperVC *helper = [[HelperVC alloc] init];
    [self Cancel];
    helper.flagHelp = power;
    [self.navigationController pushViewController:helper animated:YES];
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
    [self.navigationController pushViewController:userVC animated:YES];
}


@end
