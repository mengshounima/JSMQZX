//
//  ganbuLogCell.m
//  JSMQZX
//
//  Created by aiteyuan on 15/12/30.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "ganbuLogCell.h"

@implementation ganbuLogCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)updateCell:(NSDictionary *)infoDic{
    NSString *rz_mqgk = [infoDic objectForKey:@"rz_mqgk"];
    if ([rz_mqgk isEqualToString:@"1"]) {
        _imageV.image = [UIImage imageNamed:@"晴天"];
    }
    else if ([rz_mqgk isEqualToString:@"2"]) {
        _imageV.image = [UIImage imageNamed:@"多云"];
    }
    else if ([rz_mqgk isEqualToString:@"3"]) {
        _imageV.image = [UIImage imageNamed:@"阴天"];
    }
    else{
        _imageV.image = [UIImage imageNamed:@"下雨"];
    }
    
    //走访干部
    NSString *rz_zfnh_name = [infoDic objectForKey:@"rz_zfnh_name"];
    if (!ISNULLSTR(rz_zfnh_name)) {
        _nameL.text = rz_zfnh_name;
    }
    
    
    NSString *peopleStr = [infoDic objectForKey:@"rz_zfrxm"];
    if (!ISNULLSTR(peopleStr)) {
        _peopleL.text =[NSString stringWithFormat:@"走访干部:%@",peopleStr];

    }
    else{
        _peopleL.text = @"走访干部";
    }
    
    //日期
    NSString *date1 = [infoDic objectForKey:@"rz_zfrq"];
    NSArray *dateArr1 = [date1 componentsSeparatedByString:@" "];
    NSString *date = dateArr1[0];
    if (!ISNULLSTR(date)) {
        _timeL.text = date;
        
    }
    //逾期,根据当前时间算出来
    NSDate  *nowDate = [NSDate date];
    NSTimeInterval nowInt = [nowDate timeIntervalSince1970];
    
    NSString *zfrq = [infoDic objectForKey:@"rz_txrq"];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];    formater.dateFormat = @"yyyy/MM/dd hh:mm:ss";
    NSDate *zfrqDate = [formater dateFromString:zfrq];
    NSTimeInterval zfrqInt = [nowDate timeIntervalSince1970];
    double Sub = abs(nowInt-zfrqInt);
    Sub = Sub/24;
    NSNumber *powerStr = [[DataCenter sharedInstance] ReadData].UserInfo.power;
    if (powerStr.integerValue ==1) {
        //管理员
        if (Sub>15) {
            _yuqiL.text = @"逾期:是";
        }
        else{
            _yuqiL.text = @"逾期:否";
        }
        
    }
    else{
        if (Sub>30) {
            _yuqiL.text = @"逾期:是";
        }
        else{
            _yuqiL.text = @"逾期:否";
        }

    }
    
    
    
    //类别
    NSString *leibirStr = [infoDic objectForKey:@"rz_mqlb_name"];
    if (!ISNULLSTR(leibirStr)) {
        _leibieL.text = [NSString stringWithFormat:@"民情类别:%@",leibirStr];
    }
    else{
        _leibieL.text = @"民情类别";
    }
    //需求
    NSString *xvqiuStr = [infoDic objectForKey:@"rz_msxq"];
    if (!ISNULLSTR(xvqiuStr)) {
        _xvqiuL.text = [NSString stringWithFormat:@"民情需求:%@",xvqiuStr];
    }
    else{
        _xvqiuL.text = @"民情需求";
    }
    //镇村网格
    
    NSString *ZJDStr = [infoDic objectForKey:@"zjd_name"];
    NSString *CUNStr = [infoDic objectForKey:@"cun_name"];
    NSString *WangGeStr = [infoDic objectForKey:@"wg_name"];
    if (!ISNULLSTR(ZJDStr)&&!ISNULLSTR(CUNStr)&&!ISNULLSTR(WangGeStr)) {
        _ZJDL.text = [NSString stringWithFormat:@"%@  %@  %@",ZJDStr , CUNStr,WangGeStr];
    }
    //是否办结
    NSString *banjieStr = [infoDic objectForKey:@"rz_ztxx"];
    if ([banjieStr isEqualToString:@"3"]) {
        _banliL.text = @"是否办结:未办理";
    }
    else if ([banjieStr isEqualToString:@"1"]) {
        _banliL.text = @"是否办结:已办理";
    }
    if ([banjieStr isEqualToString:@"2"]) {
        _banliL.text = @"是否办结:转交上级";
    }
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
