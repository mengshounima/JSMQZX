//
//  LogCell.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/14.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "LogCell.h"

@implementation LogCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)updateContent:(NSDictionary *)infoDic{
    MyLog(@"%@",infoDic);
    NSNumber *rz_mqgk = [infoDic objectForKey:@"rz_mqgk"];
    if (rz_mqgk.integerValue==1) {
        [_GKImageView setImage:[UIImage imageNamed:@"晴天"]];
    }
    else if (rz_mqgk.integerValue==2){
        [_GKImageView setImage:[UIImage imageNamed:@"多云"]];
    }
    else if (rz_mqgk.integerValue==3){
        [_GKImageView setImage:[UIImage imageNamed:@"阴天"]];
    }
    else {
        [_GKImageView setImage:[UIImage imageNamed:@"下雨"]];
    }
    _nameL.text = [infoDic objectForKey:@"rz_zfnh_name"];
    _ZFGBLabel.text = [NSString stringWithFormat:@"走访干部:%@",[infoDic objectForKey:@"rz_zfrxm"]];//干部
   
    NSNumber *ZFXX = [infoDic objectForKey:@"rz_ztxx"];
    if (ZFXX.integerValue == 1) {
        _BanliZTLabel.text = @"已办理";
    }
    else if (ZFXX.integerValue == 2) {
        _BanliZTLabel.text = @"未办理";
    }
    else if (ZFXX.integerValue == 3) {
        _BanliZTLabel.text = @"转交上级";
    }
    else if (ZFXX.integerValue == 4) {
        _BanliZTLabel.text = @"无诉求";
    }
    _dateL.text = [infoDic objectForKey:@"rz_zfrq"];
    _TypeLabel.text = [NSString stringWithFormat:@"民情类别:%@",[infoDic objectForKey:@"rz_mqlb_name"]];
    _NeedLabel.text = [NSString stringWithFormat:@"民情需求:%@",[infoDic objectForKey:@"rz_msxq"]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
