//
//  FuwuInfoVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/27.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "FuwuInfoVC.h"
#define fuwuFont [UIFont systemFontOfSize:14]
@interface FuwuInfoVC ()

@end

@implementation FuwuInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    UIScrollView *myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIView *backView = [[UIView alloc] init];
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 5;
    [myScroll addSubview:backView];
    
    //ID
    UILabel *IDL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-36, 40)];
    IDL.text = [NSString stringWithFormat:@"志愿服务详细信息[ID：%@]",[_infoDic objectForKey:@"fw_id"]];
    IDL.textColor = choiceColor(16, 86, 148);
    IDL.font = [UIFont systemFontOfSize:16];
    IDL.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:IDL];
    
    float Y = CGRectGetMaxY(IDL.frame);
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line];
    
    //服务日期
    UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    dateL.text = [NSString stringWithFormat:@"服务日期：%@",[_infoDic objectForKey:@"fw_date"]];
    dateL.font = fuwuFont;
    [backView addSubview:dateL];
    
     Y = CGRectGetMaxY(dateL.frame);
    //line
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line1];
    //服务社区
    UILabel *fuwushequL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    fuwushequL.text = [NSString stringWithFormat:@"服务社区：%@",[_infoDic objectForKey:@"cun_name"]];
    fuwushequL.font = fuwuFont;
    [backView addSubview:fuwushequL];
    
    Y = CGRectGetMaxY(fuwushequL.frame);
    //line
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line2];
    
    //报到社区
    UILabel *baodaoshequL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    baodaoshequL.text = [NSString stringWithFormat:@"报到社区：%@",[_infoDic objectForKey:@"fw_dybdsq_name"]];
    baodaoshequL.font = fuwuFont;
    [backView addSubview:baodaoshequL];
    
    Y = CGRectGetMaxY(baodaoshequL.frame);
    //line
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line3];
    
    //服务岗位
    UILabel *gangweiL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    gangweiL.text = [NSString stringWithFormat:@"服务岗位：%@",[_infoDic objectForKey:@"fw_dybdsq_name"]];
    gangweiL.font = fuwuFont;
    [backView addSubview:gangweiL];
    
    Y = CGRectGetMaxY(gangweiL.frame);
    //line
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line4];
    //活动内容
    NSString *contentStr = [NSString stringWithFormat:@"活动内容：%@",[_infoDic objectForKey:@"fw_nr"]];
    CGSize contentRect = [self sizeWithText:contentStr font:fuwuFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
    UILabel *_contentL = [[UILabel alloc] initWithFrame: CGRectMake(8, Y, SCREEN_WIDTH-36, contentRect.height)];
    _contentL.font = fuwuFont;
    _contentL.numberOfLines = 0;
    _contentL.text = contentStr;

    [backView addSubview:_contentL];
    
    Y = CGRectGetMaxY(_contentL.frame);
    //line
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line];
    
    //参与党员
    NSString *dangyuanStr = [NSString stringWithFormat:@"参与党员：%@",[_infoDic objectForKey:@"fw_dy_name"]];
    CGSize dangyuanRect = [self sizeWithText:dangyuanStr font:fuwuFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
    UILabel *dangyuanL = [[UILabel alloc] initWithFrame: CGRectMake(8, Y, SCREEN_WIDTH-36, dangyuanRect.height)];
    dangyuanL.font = fuwuFont;
    dangyuanL.numberOfLines = 0;
    dangyuanL.text = dangyuanStr;
    
    [backView addSubview:dangyuanL];
    
    Y = CGRectGetMaxY(dangyuanL.frame);
    //line
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line6.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line6];
    
    //备注信息
    NSString *beizhuStr = [NSString stringWithFormat:@"备注信息：%@",[_infoDic objectForKey:@"fw_bz"]];
    CGSize baizhuRect = [self sizeWithText:beizhuStr font:fuwuFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
    UILabel *beizhuL = [[UILabel alloc] initWithFrame: CGRectMake(8, Y, SCREEN_WIDTH-36, baizhuRect.height)];
    beizhuL.font = fuwuFont;
    beizhuL.numberOfLines = 0;
    beizhuL.text = beizhuStr;
    
    [backView addSubview:beizhuL];
    float AllHeight = Y+baizhuRect.height+20;
    
    backView.frame = CGRectMake(10, 20, SCREEN_WIDTH-20, AllHeight);
    myScroll.contentSize = CGSizeMake(0, AllHeight);
    [self.view addSubview:myScroll];

}
//计算文本尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    MyLog(@"%@",[text class]);
    if (ISNULL(text))
    {
        return CGSizeMake(0, 25);
    }
    else
    {
        return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
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
