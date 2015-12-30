//
//  EvaluateCell.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/24.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "EvaluateCell.h"

@implementation EvaluateCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)updateCellWithInfoDic:(NSDictionary *)infoDic{
    MyLog(@"%@",infoDic);
   /* _itemNumL.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"index"]];*/
    _nameL.text = [NSString stringWithFormat:@"姓名：%@",[infoDic objectForKey:@"gl_zsxm"]];
    NSNumber *pingjia = [infoDic objectForKey:@"gl_pjzs"];
    _zongpinjiaL.text = [NSString stringWithFormat:@"总评价：%.1f",pingjia.floatValue];
    _sszL.text =  [NSString stringWithFormat:@"所属社区：%@",[infoDic objectForKey:@"zjd_name"]];
    
    NSNumber *zfl =  [infoDic objectForKey:@"gl_zfl"];
    _ZouFangLvL.text = [NSString stringWithFormat:@"%.2f%%",zfl.floatValue];
    
    NSNumber *bjl =  [infoDic objectForKey:@"gl_bjl"];
    _BanJieLv.text = [NSString stringWithFormat:@"%.2f%%",bjl.floatValue];
    
    NSNumber *myl =  [infoDic objectForKey:@"gl_zfmyl"];
    _ManYiDuL.text = [NSString stringWithFormat:@"%.2f%%",myl.floatValue];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
