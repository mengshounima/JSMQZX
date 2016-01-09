//
//  LogConfirmView.m
//  JSMQZX
//
//  Created by 李 燕琴 on 16/1/6.
//  Copyright © 2016年 liyanqin. All rights reserved.
//

#import "LogConfirmView.h"
#define conFirmFont [UIFont systemFontOfSize:16]
@implementation LogConfirmView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   }

-(void)updateView:(NSDictionary *)infoDic{
    self.backgroundColor = [UIColor whiteColor];
    float Width = self.frame.size.width;
    float Height = self.frame.size.height;
    //tite
    UILabel *IDL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, Width-16, 50)];
    IDL.text = [NSString stringWithFormat:@"提交民情日志信息"];
    IDL.textColor = choiceColor(16, 86, 148);
    IDL.font = [UIFont systemFontOfSize:19];
    IDL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:IDL];
    float Y = CGRectGetMaxY(IDL.frame);
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y, Width, 1)];
    line.backgroundColor =  choiceColor(16, 86, 148);
    [self addSubview:line];
    
    //scrollView显示日志信息
    UIScrollView *myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Y+1, Width, Height-80)];
    [self addSubview:myScroll];
    
    UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, Width-16, 40)];//
    dateL.text = [NSString stringWithFormat:@"走访日期：%@",[infoDic objectForKey:@"date"]];
    dateL.font = conFirmFont;
    [myScroll addSubview:dateL];
    
    Y = CGRectGetMaxY(dateL.frame);
    //line
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [myScroll addSubview:line1];
    
    
    UILabel *zfnhL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, Width-16, 40)];//
    zfnhL.text = [NSString stringWithFormat:@"走访农户：%@",[infoDic objectForKey:@"zfnh_name"]];
    zfnhL.font = conFirmFont;
    [myScroll addSubview:zfnhL];
    
    Y = CGRectGetMaxY(zfnhL.frame);
    //line
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [myScroll addSubview:line2];
    
    UILabel *mqgkL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, Width-16, 40)];//
    mqgkL.text = [NSString stringWithFormat:@"民情概况：%@",[infoDic objectForKey:@"mqgk"]];
    mqgkL.font = conFirmFont;
    [myScroll addSubview:mqgkL];
    
    Y = CGRectGetMaxY(mqgkL.frame);
    //line
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [myScroll addSubview:line3];
    
    //共性
     NSString *titleStr = [NSString stringWithFormat:@"是否共性问题：%@",[infoDic objectForKey:@"sfgx"]];
    CGSize titleRect = [self sizeWithText:titleStr font:conFirmFont maxSize:CGSizeMake(Width-16, MAXFLOAT)];
    if (titleRect.height<40) {
        titleRect.height = 40;
    }
     UILabel *sfgxL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, Width-16, titleRect.height)];
     sfgxL.font = conFirmFont;
     sfgxL.numberOfLines = 0;
     sfgxL.text = titleStr;
    [myScroll addSubview:sfgxL];
    
    Y = CGRectGetMaxY(sfgxL.frame);
    //line
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [myScroll addSubview:line4];
    
    //民生类别
    NSString *mslbStr = [NSString stringWithFormat:@"民生类别：%@",[infoDic objectForKey:@"leibie"]];
    CGSize mslbRect = [self sizeWithText:titleStr font:conFirmFont maxSize:CGSizeMake(Width-16, MAXFLOAT)];
    if (mslbRect.height<40) {
        mslbRect.height = 40;
    }

    UILabel *mslbL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, Width-16, mslbRect.height)];
    mslbL.font = conFirmFont;
    mslbL.numberOfLines = 0;
    mslbL.text = mslbStr;
    [myScroll addSubview:mslbL];
    
    Y = CGRectGetMaxY(mslbL.frame);
    //line
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [myScroll addSubview:line5];
    
    
    //民生需求
    NSString *needStr = [NSString stringWithFormat:@"民生需求：%@",[infoDic objectForKey:@"need"]];
    CGSize needRect = [self sizeWithText:needStr font:conFirmFont maxSize:CGSizeMake(Width-16, MAXFLOAT)];
    if (needRect.height<40) {
        needRect.height = 40;
    }

    UILabel *needL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, Width-16, needRect.height)];
    needL.font = conFirmFont;
    needL.numberOfLines = 0;
    needL.text = needStr;
    [myScroll addSubview:needL];
    
    Y = CGRectGetMaxY(needL.frame);
    //line
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line6.backgroundColor = [UIColor lightGrayColor];
    [myScroll addSubview:line6];
    //处理结果
    UILabel *resultL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, Width-16, 40)];//
    resultL.text = [NSString stringWithFormat:@"处理结果：%@",[infoDic objectForKey:@"ztxx"]];
    resultL.font = conFirmFont;
    [myScroll addSubview:resultL];
    
    Y = CGRectGetMaxY(resultL.frame);
    //line
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line7.backgroundColor = [UIColor lightGrayColor];
    [myScroll addSubview:line7];
    //走访人
    UILabel *ZoufangrenL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, Width-16, 40)];//
    ZoufangrenL.text = [NSString stringWithFormat:@"走访人：%@",[infoDic objectForKey:@"zfr"]];
    ZoufangrenL.font = conFirmFont;
    [myScroll addSubview:ZoufangrenL];
    
    Y = CGRectGetMaxY(ZoufangrenL.frame);
    //line
    UIView *line8 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line8.backgroundColor = [UIColor lightGrayColor];
    [myScroll addSubview:line8];
    
    //照片数量
    UILabel *picturesL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, Width-16, 40)];//
    picturesL.text = [NSString stringWithFormat:@"照片数量：%@",[infoDic objectForKey:@"picsNumber"]];
    picturesL.font = conFirmFont;
    [myScroll addSubview:picturesL];
    
    Y = CGRectGetMaxY(picturesL.frame);
    //line
    UIView *line9 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line9.backgroundColor = [UIColor lightGrayColor];
    [myScroll addSubview:line9];
    
    //当前位置
    NSString *locationStr = [NSString stringWithFormat:@"当前位置：%@",[infoDic objectForKey:@"Location"]];
    CGSize locationRect = [self sizeWithText:locationStr font:conFirmFont maxSize:CGSizeMake(Width-16, MAXFLOAT)];
    if (locationRect.height<40) {
        locationRect.height = 40;
    }
    UILabel *locationL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, Width-16, locationRect.height)];
    locationL.font = conFirmFont;
    locationL.numberOfLines = 0;
    locationL.text = locationStr;
    [myScroll addSubview:locationL];
    
    Y = CGRectGetMaxY(locationL.frame);
    
    
    myScroll.contentSize = CGSizeMake(0, Y);
    
    
    Y = CGRectGetMaxY(myScroll.frame);
    
    //提交按钮
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, Y, Width/2, 30)];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendBtn.layer.borderWidth = 1;
    sendBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [sendBtn addTarget:self action:@selector(SendConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(Width/2, Y, Width/2, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cancelBtn addTarget:self action:@selector(CancelConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    
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

//点击提交
-(void)SendConfirm:(UIButton *)button{
    [self dismisself];
    [self.delegate clickSend];
}
//点击取消
-(void)CancelConfirm:(UIButton *)button{
     [self dismisself];
}

- (void)dismisself
{
    if ([self.delegate respondsToSelector:@selector(clickCanceled)]) {
        [self.delegate clickCanceled];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, self.height, 0, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
+(instancetype)initConfirmView{
    
    return self;
}*/
@end
