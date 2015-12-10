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
    UserInfo *user = [[UserInfo shareUserInfo] ReadData];
    NSString *powerStr = [NSString stringWithFormat:@"%@",user.power];
    NSString *administerNameStr = user.administerName;
    /*if ([administerNameStr isEqualToString:@"管理员"]) {
        //两个按钮
        MyLog(@"管理员");
        
    }*/
    if ([powerStr isEqualToString:@"6"]) {
        //两个按钮
        MyLog(@"一般用户");
        
    }
    else if([powerStr isEqualToString:@"3"]){
         MyLog(@"镇干部");
    }
    else if([powerStr isEqualToString:@"1"])
    {
        MyLog(@"管理员");
    }

    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RootNormalToMinQinRiZhi"]) {
        MinQinRiZhiTableVC *minqin = segue.destinationViewController;
    }
}

//民情日志
- (IBAction)clickminqingrizhi:(id)sender {
    [self performSegueWithIdentifier:@"RootNormalToMinQinRiZhi" sender:nil];
}
//日志办理
- (IBAction)clickrizhibanli:(id)sender {
}
@end
