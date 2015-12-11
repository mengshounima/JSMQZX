//
//  SelectFarmerCell.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/11.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "SelectFarmerCell.h"

@implementation SelectFarmerCell

- (void)awakeFromNib {
    // Initialization cod
}
-(void)updateCell:(NSDictionary *)dic{
    NSString *name = [dic objectForKey:@"user_name"];
    NSString *phone = [dic objectForKey:@"user_lxfs"];
    NSNumber *jtcy = [dic objectForKey:@"user_jtcys"];
    NSString *zjd = [dic objectForKey:@"zjd_name"];
    NSString *cun = [dic objectForKey:@"cun_name"];
    NSString *wg = [dic objectForKey:@"wg_name"];
    NSString *lxgbName = [[UserInfo sharedInstance] ReadData].name;//联系干部。即自己
    _UpL.text = [NSString stringWithFormat:@"户主:%@   电话:%@   成员:%@",name,phone,jtcy];
    _downL.text = [NSString stringWithFormat:@"%@ %@ %@      联系干部:%@",zjd,cun,wg,lxgbName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
