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
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
