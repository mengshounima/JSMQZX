//
//  GanbuZFInfoCell.h
//  JSMQZX
//
//  Created by 李 燕琴 on 16/1/11.
//  Copyright © 2016年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GanbuZFInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *zongpinjiaL;

@property (weak, nonatomic) IBOutlet UILabel *ZouFangLvL;
@property (weak, nonatomic) IBOutlet UILabel *BanJieLv;
@property (weak, nonatomic) IBOutlet UILabel *ManYiDuL;
-(void)updateCellWithInfoDic:(NSDictionary *)infoDic;
@end
