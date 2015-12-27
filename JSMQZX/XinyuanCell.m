//
//  XinyuanCell.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/27.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "XinyuanCell.h"

@implementation XinyuanCell

- (void)awakeFromNib {
   //心愿内容
    _contentL = [[UILabel alloc] init];
    _contentL.font=[UIFont systemFontOfSize:12];
    _contentL.textColor = [UIColor darkGrayColor];
    _contentL.numberOfLines =0;
    [self.contentView addSubview:_contentL];
    
    //是否完成
    _finishL = [[UILabel alloc] init];
    _finishL.font=[UIFont systemFontOfSize:12];
    _finishL.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_finishL];
    
    //日期
    _dateL = [[UILabel alloc] init];
    _dateL.font=[UIFont systemFontOfSize:12];
    _dateL.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_dateL];
}
-(void)updateWithInfoDic:(NSDictionary *) infoDic{
    NSString *wxy_xm = [infoDic objectForKey:@"wxy_xm"];
    if (!ISNULLSTR(wxy_xm)) {
        _nameL.text = [NSString stringWithFormat:@"姓名：%@",wxy_xm];
    }
    else{
        _nameL.text = @"姓名：";
    }
    
    NSString *wxy_lb_name = [infoDic objectForKey:@"wxy_lb_name"];
    if (!ISNULLSTR(wxy_lb_name)) {
        _jiduL.text = [NSString stringWithFormat:@"季度类别：%@",wxy_lb_name];
    }
    else{
        _jiduL.text = @"季度列表：";
    }
    NSString *cun_name = [infoDic objectForKey:@"cun_name"];
    if (!ISNULLSTR(cun_name)) {
        _cunL.text = [NSString stringWithFormat:@"所属村/社区：%@",cun_name];
    }
    else{
        _cunL.text = @"所属村/社区：";
    }
    
    NSString *wxy_nr = [infoDic objectForKey:@"wxy_nr"];
    if (!ISNULLSTR(wxy_nr)) {
        _contentL.text = [NSString stringWithFormat:@"心愿内容：%@",wxy_nr];
    }
    else{
        _contentL.text = @"心愿内容：";
    }
    
    NSString *wxy_sfwc = [infoDic objectForKey:@"wxy_sfwc"];
    NSString *wxy_c_rlr = [infoDic objectForKey:@"wxy_c_rlr"];
    if (!ISNULLSTR(wxy_sfwc)&&!ISNULLSTR(wxy_c_rlr)) {
        _finishL.text = [NSString stringWithFormat:@"是否完成：%@   认领人：%@",wxy_sfwc,wxy_c_rlr];
    }
    else if(ISNULLSTR(wxy_sfwc)&&!ISNULLSTR(wxy_c_rlr)){
        _finishL.text = [NSString stringWithFormat:@"是否完成：   认领人：%@",wxy_c_rlr];
    }
    else if (!ISNULLSTR(wxy_sfwc)&&ISNULLSTR(wxy_c_rlr)){
        _finishL.text = [NSString stringWithFormat:@"是否完成：%@   认领人：",wxy_sfwc];
    }
    else{
        _finishL.text = [NSString stringWithFormat:@"是否完成：   认领人："];

    }
    
    
    NSString *timeStr = [infoDic objectForKey:@"wxy_date"];//开始时间
    NSArray *SS = [timeStr componentsSeparatedByString:@" "];
    NSArray *MM = [SS[0] componentsSeparatedByString:@"/"];
    NSString *year = MM[0];
    NSString *month = MM[1];
    NSString *day= MM[2];
    NSString *StartDate  = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    
    NSString *timeStr1 = [infoDic objectForKey:@"wxy_wcsj"];//完成时间
    NSArray *SS1 = [timeStr1 componentsSeparatedByString:@" "];
    NSArray *MM1 = [SS1[0] componentsSeparatedByString:@"/"];
    NSString *year1 = MM1[0];
    NSString *month1 = MM1[1];
    NSString *day1= MM1[2];
    NSString *EndDate  = [NSString stringWithFormat:@"%@年%@月%@日",year1,month1,day1];
    

    if (!ISNULLSTR(StartDate)&&!ISNULLSTR(EndDate)) {
        _dateL.text = [NSString stringWithFormat:@"登记日期：%@   完成日期：%@",StartDate,EndDate];
    }
    else if(ISNULLSTR(StartDate)&&!ISNULLSTR(EndDate)){
        _dateL.text = [NSString stringWithFormat:@"登记日期：   完成日期：%@",EndDate];
    }
    else if (!ISNULLSTR(StartDate)&&ISNULLSTR(EndDate)){
        _dateL.text = [NSString stringWithFormat:@"登记日期：%@   完成日期：",StartDate];
    }
    else{
        _dateL.text = [NSString stringWithFormat:@"登记日期：   完成日期："];
        
    }

}
- (void)setStatusFrame:(XinyuanCellFrame *)statusFrame
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
    _contentL.frame=_statusFrame.contentF;
    _finishL.frame = _statusFrame.finisheF;
    _dateL.frame = _statusFrame.dateF;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
