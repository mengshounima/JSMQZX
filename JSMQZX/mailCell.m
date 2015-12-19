//
//  mailCell.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/19.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "mailCell.h"

@implementation mailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateCell:(NSDictionary *)listDic{
    _titleL.text = [NSString stringWithFormat:@"标题:%@",[listDic objectForKey:@"mail_title"]];
    _ZhuangTaiL.text = [listDic objectForKey:@"ZT"];
    _peopleL.text = [NSString stringWithFormat:@"留言人:%@",[listDic objectForKey:@"username"]];
    _danweiL.text = [NSString stringWithFormat:@"办理单位:%@",[listDic objectForKey:@"sjr_name"]];
    NSString *dateStr = [listDic objectForKey:@"add_date"];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:dateStr];
    NSDateFormatter *OutFormatter = [[NSDateFormatter alloc] init];
    [OutFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *date = [OutFormatter stringFromDate:inputDate];
    
    _dateL.text = date;
}

@end
