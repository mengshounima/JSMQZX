//
//  DangdaibiaoInfoVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/26.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "DangdaibiaoInfoVC.h"

@interface DangdaibiaoInfoVC ()

@end

@implementation DangdaibiaoInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    _titleLabel.text = [_infoDic objectForKey:@"Title"];
    NSString *timeStr = [_infoDic objectForKey:@"AddDate"];
    NSArray *SS = [timeStr componentsSeparatedByString:@" "];
    NSArray *MM = [SS[0] componentsSeparatedByString:@"/"];
    NSString *year = MM[0];
    NSString *month = MM[1];
    NSString *day= MM[2];
    NSString *date  = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    _dateLabel.text = [NSString stringWithFormat:@"发布者:%@    发布时间:%@",[_infoDic objectForKey:@"User"],date];
    [_webView loadHTMLString:[_infoDic objectForKey:@"Content"] baseURL:nil];
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
