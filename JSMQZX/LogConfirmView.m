//
//  LogConfirmView.m
//  JSMQZX
//
//  Created by 李 燕琴 on 16/1/6.
//  Copyright © 2016年 liyanqin. All rights reserved.
//

#import "LogConfirmView.h"
#define conFirmFont [UIFont systemFontOfSize:13]
@implementation LogConfirmView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    float Width = rect.size.width;
    float Height = rect.size.height;
    //tite
    UILabel *IDL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, Width-16, 40)];
    IDL.text = [NSString stringWithFormat:@"提交民情日志信息"];
    IDL.textColor = choiceColor(16, 86, 148);
    IDL.font = [UIFont systemFontOfSize:16];
    IDL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:IDL];
    float Y = CGRectGetMaxY(IDL.frame);
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y, Width, 1)];
    line.backgroundColor =  choiceColor(16, 86, 148);
    [self addSubview:line];

    //scrollView显示日志信息
    UIScrollView *myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Y+1, Width, Height-70)];
    [self addSubview:myScroll];
    UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, Width-16, 30)];
    dateL.text = @"dddffg";
    dateL.font = conFirmFont;
    [myScroll addSubview:dateL];
    
    Y = CGRectGetMaxY(dateL.frame);
    //line
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [myScroll addSubview:line1];
    myScroll.contentSize = CGSizeMake(0, 80);
    
    Y = CGRectGetMaxY(myScroll.frame);
    
    //提交按钮
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, Y, Width/2, 30)];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    sendBtn.layer.borderWidth = 1;
    sendBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [sendBtn addTarget:self action:@selector(SendConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(Width/2, Y, Width/2, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cancelBtn addTarget:self action:@selector(CancelConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
}

//点击提交
-(void)SendConfirm:(UIButton *)button{
    [self.delegate clickSend];
}
//点击取消
-(void)CancelConfirm:(UIButton *)button{
    [self.delegate clickCancel];
}
/*
+(instancetype)initConfirmView{
    

     //addSubview:myScroll];
    //党员基本信息
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 150)];
    view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view1.layer.borderWidth = 1;
    view1.layer.cornerRadius = 5;
    [myScroll addSubview:view1];
    //tite
    UILabel *IDL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-36, 40)];
    IDL.text = [NSString stringWithFormat:@"党员基本信息"];
    IDL.textColor = choiceColor(16, 86, 148);
    IDL.font = [UIFont systemFontOfSize:16];
    IDL.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:IDL];
    
    float Y = CGRectGetMaxY(IDL.frame);
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view1 addSubview:line];
    
    //所属村/社区
        //
    UILabel *fuwushequL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    fuwushequL.text = [NSString stringWithFormat:@"所属党委：%@",[_infoDic objectForKey:@"dw_name"]];
    fuwushequL.font = fuwuFont;
    [view1 addSubview:fuwushequL];
    
    Y = CGRectGetMaxY(fuwushequL.frame);
    //line
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [view1 addSubview:line2];
    
    
    NSString *titleStr = [NSString stringWithFormat:@"信件主题:%@",[_infoDic objectForKey:@"mail_title"]];
    CGSize titleRect = [self sizeWithText:titleStr font:mailFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, titleRect.height)];
    _titleL.font = mailFont;
    _titleL.numberOfLines = 0;
    _titleL.text = titleStr;
    [backView addSubview:_titleL];

    return self;
}*/
@end
