//
//  FuwuCell.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/26.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "FuwuCell.h"

@implementation FuwuCell

- (void)awakeFromNib {
    _huodongL = [[UILabel alloc] init];
    _huodongL.font=[UIFont systemFontOfSize:13];
    _huodongL.textColor = [UIColor darkGrayColor];
    _huodongL.numberOfLines =0;
    [self.contentView addSubview:_huodongL];
    
    _dangyuanL = [[UILabel alloc] init];
    _dangyuanL.font=[UIFont systemFontOfSize:13];
    _dangyuanL.textColor = [UIColor darkGrayColor];
    _dangyuanL.numberOfLines =0;
    [self.contentView addSubview:_dangyuanL];
}
-(void)updateCell:(NSDictionary *)infoDic{
    NSString *timeStr = [infoDic objectForKey:@"fw_date"];
    NSArray *SS = [timeStr componentsSeparatedByString:@" "];
    NSArray *MM = [SS[0] componentsSeparatedByString:@"/"];
    NSString *year = MM[0];
    NSString *month = MM[1];
    NSString *day= MM[2];
    NSString *date  = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    if (!ISNULLSTR(date)) {
        _dateLabel.text = [NSString stringWithFormat:@"服务日期:%@",date];

    }
    else{
        _dateLabel.text = @"服务日期:";
    }
    NSString *fw_lx = [infoDic objectForKey:@"fw_lx"];
    if (!ISNULLSTR(fw_lx)) {
         _typeLabel.text = [NSString stringWithFormat:@"类别:%@",fw_lx];
    }
    else{
        _typeLabel.text = @"类别:";
    }
    NSString *cun_name = [infoDic objectForKey:@"cun_name"];
    if (!ISNULLSTR(cun_name)) {
        _fuwushequLabel.text = [NSString stringWithFormat:@"服务社区:%@",cun_name];
    }
    else{
        _fuwushequLabel.text = @"服务社区:";
    }
    
    NSString *fw_dybdsq_name = [infoDic objectForKey:@"fw_dybdsq_name"];
    if (!ISNULLSTR(fw_dybdsq_name)) {
        _baodaoshequLabel.text = [NSString stringWithFormat:@"报到社区:%@",fw_dybdsq_name];
    }
    else{
        _baodaoshequLabel.text = @"报到社区:";
    }
   
    NSString *fw_nr = [infoDic objectForKey:@"fw_nr"];
    if (!ISNULLSTR(fw_nr)) {
        _huodongL.text = [NSString stringWithFormat:@"活动内容:%@",fw_nr];
    }
    else{
         _huodongL.text = @"活动内容:";
    }
    NSString *fw_dy_name =[infoDic objectForKey:@"fw_dy_name"];
    if (!ISNULLSTR(fw_dy_name)) {
        _dangyuanL.text = [NSString stringWithFormat:@"参加党员:%@",fw_dy_name];
    }
    else{
        _dangyuanL.text = @"参加党员:";
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setStatusFrame:(MJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 1.设置数据
    //[self settingData];
    
    // 2.设置frame
    [self settingFrame];
}
//
///**
// *  设置frame
// */
- (void)settingFrame
{
    _huodongL.frame=_statusFrame.HuoDongF;
    _dangyuanL.frame = _statusFrame.DangYuanF;
}

@end
