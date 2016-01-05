//
//  DangyuanCell.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/18.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "DangyuanCell.h"

@implementation DangyuanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateCell:(NSDictionary *)infoDic{
    MyLog(@"%@",infoDic);
    _nameL.text = [NSString stringWithFormat:@"姓名:%@",[infoDic objectForKey:@"bd_name"]];
    _shequL.text = [NSString stringWithFormat:@"报到社区:%@",[infoDic objectForKey:@"cun_name"]];
    _dwL.text = [NSString stringWithFormat:@"所属党委:%@",[infoDic objectForKey:@"dw_name"]];
    
    NSString *date = [infoDic objectForKey:@"bd_bdrq"];
    NSArray *arrdate = [date componentsSeparatedByString:@" "];
    
    _dateL.text = [NSString stringWithFormat:@"报到日期:%@",arrdate[0]];
    _workDanweiL.text = [NSString stringWithFormat:@"工作单位:%@",[infoDic objectForKey:@"bd_gzdw"]];
    _familyL.text = [NSString stringWithFormat:@"家园奉献岗位:%@",[infoDic objectForKey:@"fxgw_name"]];
}

@end
