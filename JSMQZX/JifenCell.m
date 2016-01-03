//
//  JifenCell.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/29.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "JifenCell.h"

@implementation JifenCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)updateCell:(NSDictionary *)infoDic{
    _nameL.text = [NSString stringWithFormat:@"姓名：%@",[infoDic objectForKey:@"gl_zsxm"]];
    _zongfenL.text = [NSString stringWithFormat:@"总分：%@",[infoDic objectForKey:@"gl_zf_ms_hj"]];
     _Label1.text = [NSString stringWithFormat:@"走访积分：%@",[infoDic objectForKey:@"gl_zfhj"]];
     _Label2.text = [NSString stringWithFormat:@"基础走访分：%@",[infoDic objectForKey:@"gl_zfjcf"]];
     _Label3.text = [NSString stringWithFormat:@"附加走访分：%@",[infoDic objectForKey:@"gl_zffjf"]];
     _Label4.text = [NSString stringWithFormat:@"服务积分：%@",[infoDic objectForKey:@"gl_mssjblhj"]];
     _Label5.text = [NSString stringWithFormat:@"民事收集分：%@",[infoDic objectForKey:@"gl_mssjf"]];
     _Label6.text = [NSString stringWithFormat:@"民事办理分：%@",[infoDic objectForKey:@"gl_msbljf"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
