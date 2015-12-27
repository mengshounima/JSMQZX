//
//  XinyuanInfoVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/27.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "XinyuanInfoVC.h"
#define fuwuFont [UIFont systemFontOfSize:14]
@interface XinyuanInfoVC ()

@end

@implementation XinyuanInfoVC

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
    IDL.text = [NSString stringWithFormat:@"微心愿详细信息[ID：%@]",[_infoDic objectForKey:@"wxy_id"]];
    IDL.textColor = choiceColor(16, 86, 148);
    IDL.font = [UIFont systemFontOfSize:16];
    IDL.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:IDL];
    
    float Y = CGRectGetMaxY(IDL.frame);
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line];
    
    //所属村/社区
    UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    dateL.text = [NSString stringWithFormat:@"所属村/社区：%@",[_infoDic objectForKey:@"cun_name"]];
    dateL.font = fuwuFont;
    [backView addSubview:dateL];
    
    Y = CGRectGetMaxY(dateL.frame);
    //line
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line1];
    //姓名
    UILabel *fuwushequL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    fuwushequL.text = [NSString stringWithFormat:@"姓名：%@",[_infoDic objectForKey:@"wxy_xm"]];
    fuwushequL.font = fuwuFont;
    [backView addSubview:fuwushequL];
    
    Y = CGRectGetMaxY(fuwushequL.frame);
    //line
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line2];
    
    //季度类别
    UILabel *baodaoshequL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    baodaoshequL.text = [NSString stringWithFormat:@"季度类别：%@",[_infoDic objectForKey:@"wxy_lb_name"]];
    baodaoshequL.font = fuwuFont;
    [backView addSubview:baodaoshequL];
    
    Y = CGRectGetMaxY(baodaoshequL.frame);
    //line
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line3];
    
    //心愿内容
    NSString *contentStr = [NSString stringWithFormat:@"心愿内容：%@",[_infoDic objectForKey:@"wxy_nr"]];
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
    //是否完成
    UILabel *sfFinishL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    sfFinishL.text = [NSString stringWithFormat:@"是否完成：%@",[_infoDic objectForKey:@"wxy_sfwc"]];
    sfFinishL.font = fuwuFont;
    [backView addSubview:sfFinishL];
    
    Y = CGRectGetMaxY(sfFinishL.frame);
    //line
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line6.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line6];
    
    //认领人
    UILabel *rlrL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    rlrL.text = [NSString stringWithFormat:@"认领人：%@",[_infoDic objectForKey:@"wxy_c_rlr"]];
    rlrL.font = fuwuFont;
    [backView addSubview:rlrL];
    
    Y = CGRectGetMaxY(rlrL.frame);
    //line
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line7.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line7];
    
    //登记日期
    UILabel *dengjiL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    dengjiL.text = [NSString stringWithFormat:@"登记日期：%@",[_infoDic objectForKey:@"wxy_date"]];
    dengjiL.font = fuwuFont;
    [backView addSubview:dengjiL];
    
    Y = CGRectGetMaxY(dengjiL.frame);
    //line
    UIView *line8 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line8.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line8];
    
    //认领日期
    UILabel *rlDateL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    rlDateL.text = [NSString stringWithFormat:@"认领日期：%@",[_infoDic objectForKey:@"wxy_rlsj"]];
    rlDateL.font = fuwuFont;
    [backView addSubview:rlDateL];
    
    Y = CGRectGetMaxY(rlDateL.frame);
    //line
    UIView *line9 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line9.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line9];
    //完成日期
    UILabel *EndDateL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    EndDateL.text = [NSString stringWithFormat:@"完成日期：%@",[_infoDic objectForKey:@"wxy_wcsj"]];
    EndDateL.font = fuwuFont;
    [backView addSubview:EndDateL];
    
    float AllHeight = Y+EndDateL.height+20;
    
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
