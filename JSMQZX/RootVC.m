//
//  RootVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/6.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "RootVC.h"
#import "HMTitleButton.h"
@interface RootVC ()

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
   
   // NSString *administerNameStr = [UserInfo sharedInstance].administerName;
    /*if ([administerNameStr isEqualToString:@"管理员"]) {
        //两个按钮
        MyLog(@"管理员");
        
    }*/
    if ([powerStr isEqualToString:@"6"]) {
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

- (IBAction)clickGanliyuanRizhibanli:(id)sender {
    
    
    
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
@end
