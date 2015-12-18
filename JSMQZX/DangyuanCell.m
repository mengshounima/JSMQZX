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
    _nameL.text = [infoDic objectForKey:@"bd_name"];
    _shequL.text = [infoDic objectForKey:@"cun_name"];
    _dwL.text = [infoDic objectForKey:@"dw_name"];
    _dateL.text = [infoDic objectForKey:@"bd_bdrq"];
    _workDanweiL.text = [infoDic objectForKey:@"bd_gzdw"];
    _familyL.text = [infoDic objectForKey:@"fxgw_name"];
}

@end
